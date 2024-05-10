import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/LeipzigWord.dart';

Future<String> getLeipzigHtml(String word) async {
  String result = "";
  // var uriConstr = Uri.https("corpora.uni-leipzig.de", "de/res",
  // "?corpusId=deu_news_2023&word=" + Uri.encodeFull(word));
  String url =
      "https://corpora.uni-leipzig.de/de/res?corpusId=deu_news_2023&word=${Uri.encodeFull(word)}";
  final response = await http.get(Uri.parse(url));

  //print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  result = "";
  if (response.statusCode == 200) {
    result = response.body;
  }

  return result;
}

LeipzigWord parseHtml(String text, LeipzigWord wortObj) {
  final document = html_parser.parse(text);
  wortObj.rawHTML = text;

  var wordbox = document.getElementById('wordBox');
  var def = wordbox!.getElementsByClassName("panel-body").singleOrNull;
  var pElements = def!.getElementsByTagName("p");

  var result = getBaseHeaders(wortObj, pElements);

  return wortObj;
}

Map<String, dynamic> getBaseHeaders(
    LeipzigWord wortObj, List<dom.Element> headElements) {
  String basicKindOfWord = "";

  String? basicPreviosKindOfWord;
  Map<String, dynamic> mapOfHead = {};
  List<String> basicValue = [];
  for (var pValue in headElements) {
    mapOfHead[basicKindOfWord] = basicValue;

    basicKindOfWord = "";
    basicValue = [];
    for (var (index, value) in pValue.nodes.indexed) {
      if (value.nodeType == 1 &&
          ((value as dom.Element).localName == "b" ||
              (value as dom.Element).localName == "span")) {
        basicKindOfWord.isNotEmpty
            ? mapOfHead[basicKindOfWord] = basicValue
            : basicKindOfWord = value.text.trim();

        basicKindOfWord = value.text.trim();
        basicValue = [];
        if (basicKindOfWord == "Synonym:") {
          List<MapTextUrls> synonyms = getTextFromListHrefs(value.parent!);
          List<leipzSynonym> leipzigsynonyms = [];
          for (var element in synonyms) {
            leipzigsynonyms
                .add(leipzSynonym(element.Value!, "", element.href!));
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
  // print(mapOfHead);
  mapOfHead.forEach((key, value) {
    switch (key) {
      case "":
        {}
      case "Grundform:":
        {
          wortObj.BaseWord = (value as List<String>).isNotEmpty
              ? (value as List<String>)[0]
              : wortObj.name;
        }
      case "Wortart:":
        {
          wortObj.KindOfWort =
              (value as List<String>).isNotEmpty ? (value).join(",") : "";
        }
      case "Artikel:":
        {
          wortObj.KindOfWort = (value as List<String>).isNotEmpty
              ? (value).toString().trim()
              : "";
        }
      case "Beschreibung:":
        {
          wortObj.Definitions = value;
        }
      case "Kompositum:":
        {}
      case "Siehe auch":
        {}
      case "Silbentrennung:":
        {}
      case "Synonym:":
        {
          wortObj.Synonym = value;
        }
      case "Sachgebiet:":
        {}
      case "Grundform von:":
        {}
      default:
        {
          debugPrint("found $key: $value");
        }
    }
  });
  wortObj.BaseWord = wortObj.BaseWord.isEmpty ? wortObj.name : wortObj.BaseWord;
  return mapOfHead;
}

List<MapTextUrls> getTextFromListHrefs(dom.Element root) {
  List<MapTextUrls> result = [];
  List<dom.Element> temp = root.getElementsByTagName('a');
  for (var element in temp) {
    result.add(MapTextUrls(
        Value: element.text.trim(), href: element.attributes["href"]!));
    // print(element.text);
  }
  // List<String> wortObj;
  return result;
}
