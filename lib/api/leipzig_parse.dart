import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:html/dom.dart' as dom;

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/leipzig_word.dart';

// class leipzigApiParser {
//   final Talker talker;
//   <Dio> getHttpLib(){
//     var dio = Dio();
//     dio 
//   }

// }

String getUrlForLeipzigCorporaWord(String word,
    {String corpusId = "deu_news_2023"}) {
  return "https://corpora.uni-leipzig.de/de/res?corpusId=$corpusId&word=${Uri.encodeFull(word)}";
}

String getUrlExamplesForLeipzigCorporaWord(String word,
    {String corpusId = "deu_news_2023"}) {
  // "https://corpora.uni-leipzig.de/de/webservice/index?corpusId=deu_news_2023&action=loadExamples&word=${Uri.encodeFull(word)}";

  return "https://corpora.uni-leipzig.de/de/webservice/index?corpusId=$corpusId&&action=loadExamples&word=${Uri.encodeFull(word)}";
}


Future<Response> getLeipzigHtml(String word, Dio dio) async {
  // var uriConstr = Uri.https("corpora.uni-leipzig.de", "de/res",
  // "?corpusId=deu_news_2023&word=" + Uri.encodeFull(word));
  String url = getUrlForLeipzigCorporaWord(word);
      
  final response = await dio.get(Uri.parse(url).toString());

  if (response.statusCode == 200) {}

  return response;
}

Future<LeipzigWord> parseHtml(String text, LeipzigWord wortObj) async {
  final document =  html_parser.parse(text);
  wortObj.rawHTML = text;

  var wordbox = document.getElementById('wordBox');
  var def = wordbox!.getElementsByClassName("panel-body").singleOrNull;
  var pElements = def!.getElementsByTagName("p");

  getBaseHeaders(wortObj, pElements);

  // var respond = await getLeipzigExamples(wortObj.name, wortObj.getDio());
  // var examples = parseHtmlExamples(respond);
  // wortObj.examples.clear();
  // for (var value in examples.values) {
  //   for (var item in value) {
  //     wortObj.examples.add(MapTextUrls(value: item));
  //   }
  // }

  return wortObj;
}

Map<String, dynamic> getBaseHeaders(
    LeipzigWord wortObj, List<dom.Element> headElements) {
  String basicKindOfWord = "";

  Map<String, dynamic> mapOfHead = {};
  List<String> basicValue = [];
  for (var pValue in headElements) {
    mapOfHead[basicKindOfWord] = basicValue;

    basicKindOfWord = "";
    basicValue = [];
    if (pValue.nodeType == 1) {
      for (var (_, value) in pValue.nodes.indexed) {
        if (value.nodeType == 1 &&
            ((value as dom.Element).localName == "b" ||
                (value).localName == "span")) {
          basicKindOfWord.isNotEmpty
              ? mapOfHead[basicKindOfWord] = basicValue
              : basicKindOfWord = value.text.trim();

          basicKindOfWord = value.text.trim();
          basicValue = [];
          if (basicKindOfWord == "Synonym:") {
            List<MapTextUrls> synonyms = getTextFromListHrefs(value.parent!);
            List<LeipzigSynonym> leipzigsynonyms = [];
            for (var element in synonyms) {
              leipzigsynonyms
                  .add(LeipzigSynonym(element.value!, "", element.href!));
            }

            mapOfHead[basicKindOfWord] = leipzigsynonyms;
            basicKindOfWord = "";
          }
          continue;
        }
        var reg = RegExp(r'\s\s');
        if (basicKindOfWord.isNotEmpty &&
            value.text!.trim().isNotEmpty &&
            !(value.text!.trim() == "," || value.text!.trim() == ":")) {
          basicValue.add(value.text!.trim().replaceAll(reg, ""));
        }
      }
      // var k = value;
      mapOfHead[basicKindOfWord] = basicValue;
    }
  }
  // print(mapOfHead);
  mapOfHead.forEach((key, value) {
    switch (key) {
      case "":
        {}
      case "Grundform:":
        {
          wortObj.baseWord =
              (value as List<String>).isNotEmpty ? (value)[0] : wortObj.name;
        }
      case "Grundform von:":
        {
          wortObj.baseWordFor =
              (value as List<String>).isNotEmpty ? (value)[0] : wortObj.name;
        }
      case "Wortart:":
        {
          wortObj.kindOfWort =
              (value as List<String>).isNotEmpty ? (value).join(",") : "";
        }
      case "Artikel:":
        {
          wortObj.article = (value as List<String>).isNotEmpty
              ? (value[0]).toString().trim()
              : "";
        }
      case "Beschreibung:":
        {
          wortObj.definitions = value;
        }
      case "Kompositum:":
        {}
      case "Siehe auch":
        {}
      case "Silbentrennung:":
        {}
      case "Synonym:":
        {
          wortObj.synonyms = value;
        }
      case "Sachgebiet:":
        {}
      default:
        {
          debugPrint("found $key: $value");
        }
    }
  });
  // wortObj.baseWord = wortObj.baseWord.isEmpty ? wortObj.name : wortObj.baseWord;
  return mapOfHead;
}

List<MapTextUrls> getTextFromListHrefs(dom.Element root) {
  List<MapTextUrls> result = [];
  List<dom.Element> temp = root.getElementsByTagName('a');
  for (var element in temp) {
    result.add(MapTextUrls(
        value: element.text.trim(), href: element.attributes["href"]!));
    // print(element.text);
  }
  // List<String> wortObj;
  return result;
}

Future<String> getLeipzigExamples(String word, Dio dio) async {
  String result = "";
  String url = getUrlExamplesForLeipzigCorporaWord(word);
  // "https://corpora.uni-leipzig.de/de/webservice/index?corpusId=deu_news_2023&action=loadExamples&word=${Uri.encodeFull(word)}";
  final response = await dio.get(Uri.parse(url).toString());

  // print('Response body: ${response.body}');
  result = response.data;

  return result;
}

Future<String> getOpenthesaurus(String word, Dio dio) async {
  String result = "";
  // var uriConstr = Uri.https("corpora.uni-leipzig.de", "de/res",
  // "?corpusId=deu_news_2023&word=" + Uri.encodeFull(word));
  String url = "https://www.openthesaurus.de/synonyme/${Uri.encodeFull(word)}";
  final response = await dio.get(Uri.parse(url).toString());

  // print('Response body: ${response.body}');
  result = response.data;

  return result;
}

Future<String> getLeipzigDornseif(String word) async {
  String result = "";
  // var uriConstr = Uri.https("corpora.uni-leipzig.de", "de/res",
  // "?corpusId=deu_news_2023&word=" + Uri.encodeFull(word));
  String url =
      "https://corpora.uni-leipzig.de/de/webservice/index?corpusId=deu_news_2023&action=loadWordSetBox&word=${Uri.encodeFull(word)}";
  final response = await http.get(Uri.parse(url));

  // print('Response body: ${response.body}');
  result = response.body;

  return result;
}

Map<int, List<String>> parseHtmlDornseif(String text) {
  Map<int, List<String>> result = {};
  List<String> line = [];
  final document = html_parser.parse(text);
  var wordset = document.getElementById('wordset');
  var li = wordset!.getElementsByTagName("li");
  for (var (index, item) in li.indexed) {
    line = [];
    if (item.nodes.isNotEmpty) {
      for (var listItem in item.nodes) {
        if (listItem.text != null &&
            listItem.text!.trim().isNotEmpty &&
            listItem.text!.trim().length > 1) {
          line.add(listItem.text!.trim());
        }
        // print(listItem.text);
      }
    }
    result[index] = line;
  }
  return result;
}

Map<int, List<String>> parseHtmlExamples(String text) {
  Map<int, List<String>> result = {};
  List<String> line = [];
  final document = html_parser.parse(text);
  var tes = document.getElementsByClassName("exampleSencentes");
  for (var classElem in tes) {
    var li = classElem.getElementsByTagName("li");
    for (var (index, item) in li.indexed) {
      line = [];
      if (item.nodes.isNotEmpty) {
        for (var listItem in item.nodes) {
          if (listItem.text != null &&
              listItem.text!.trim().isNotEmpty &&
              listItem.text!.trim().length > 1) {
            var prefix = "";
            var suffix = "";
            var word = "";
            if (listItem.nodes.length == 3) {
              for (var (index, nodeItem) in listItem.nodes.indexed) {
                if (index == 0) {
                  prefix = nodeItem.text!;
                }
                if (index == 1) {
                  word = nodeItem.text!;
                }
                if (index == 2) {
                  suffix = nodeItem.text!;
                }
              }
            }
            // ignore: unused_local_variable
            String resultString = prefix + word + suffix;
            if (resultString.trim() == listItem.text!.trim()) {}
            line.add(listItem.text!.trim());
            break;
          }
          // print(listItem.text);
        }
      }
      result[index] = line;
    }
  }
  return result;
}



Future<List<String>> parseHtmlOpenthesaurus(String text) async {
  List<String> result = [];
  final document = html_parser.parse(text);
  var wiktionaryList = document.getElementsByClassName("wiktionaryItem");
  if (wiktionaryList.isNotEmpty) {
    var parent = wiktionaryList[0].parent;
    for (var item in parent!.nodes) {
      if (item.text != null &&
          item.nodeType == 3 &&
          item.text!.trim().isNotEmpty) {
        result.add(item.text!.trim());
      }
    }
  }
  return result;
}
