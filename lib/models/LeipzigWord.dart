import 'package:wortschatzchen_quiz/db/db.dart';

import '../api/leipzig_parse.dart';

class LeipzigWord {
  String name;
  List<leipzSynonym> Synonym = [];
  List<Map<String, String>> Beispill = [];
  String KindOfWort = "";

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
  leipzSynonym(this.name, this.translate);
  Map<String, dynamic> toMap() => {"name": name, "translate": translate};
}
