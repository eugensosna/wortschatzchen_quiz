import 'package:html/dom.dart';
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

void parseHtml(String text_to_parse, LeipzigWord wortObj) {
  final document = html_parser.parse(text_to_parse);
  // LeipzigWord wortObj = LeipzigWord(wort);

  var wordbox = document.getElementById('wordBox');
  var elem = wordbox!.getElementsByClassName('wordBoxTT');
  var elem1 = elem[0];
  for (var rootTemp in elem) {
    if (rootTemp.text.contains("Synonym:")) {
      if (rootTemp.parent != null) {
        List<String> synonyms = getTextFromListHrefs(rootTemp.parent!);
        for (String elemsItem in synonyms) {
          wortObj.Synonym.add(leipzSynonym(elemsItem, ""));
        }
        continue;
      }
    }
    if (rootTemp.text.contains('Siehe auch')) {
      var elementsKind = rootTemp.parent!.getElementsByTagName('br');
      for (var elemKind in elementsKind) {
        if (elemKind.text.contains("Wortart:")) {
          if (elemKind.firstChild == null) {
          } else {
            wortObj.KindOfWort = elemKind.firstChild!.text!;
          }
        }
      }
    }
    print(rootTemp.text);
  }
  List<Element> temp = elem1.getElementsByTagName('a');
  for (var element in temp) {
    print(element.text);
  }
  // return wortObj;
}

List<String> getTextFromListHrefs(Element root) {
  List<String> result = [];
  List<Element> temp = root.getElementsByTagName('a');
  for (var element in temp) {
    result.add(element.text);
    // print(element.text);
  }
  return result;
}
