
import '../api/leipzig_parse.dart';

class LeipzigWord {
  String name;
  List<leipzSynonym> Synonym = [];
  List<MapTextUrls> Examples = [];
  List<String> Definitions = [];
  String KindOfWort = "";
  String BaseWord = "";
  List<String> baseForWords = [];
  String rawHTML = "";

  LeipzigWord(this.name);

  Future<String> getFromInternet() async {
    String body = await getLeipzigHtml(this.name);
    if (body.isNotEmpty) {
      parseHtml(body, this);
    }
    return "Ok";
  }
}

class leipzSynonym {
  String name;
  String translate;
  String leipzigHref = "";
  leipzSynonym(this.name, this.translate, this.leipzigHref);
  Map<String, dynamic> toMap() =>
      {"name": name, "translate": translate, "href": leipzigHref};
}

class MapTextUrls {
  String? Value;
  String? href;
  MapTextUrls({this.Value = "", this.href = ""});
}
