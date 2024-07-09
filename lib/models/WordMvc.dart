import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';

class WordMvc {
  int id;
  String name;
  String quicktranslate = "";
  List<ReordableElement> synonyms = [];
  List<ReordableElement> examples = [];
  List<ReordableElement> means = [];
  String mean = "";
  String kindOfWord = "";
  String artikel = "";
  String important = "";

  WordMvc(
    this.id,
    this.name,
  );

  static WordMvc read({Word? word, int id = -99, String name = ""}) {
    var result = WordMvc(id, name);
    return result;
  }

  void save() {}
}
