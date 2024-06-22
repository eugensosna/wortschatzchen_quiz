import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';

class WordMvc {
  int id;
  String name;
  String quicktranslate;
  List<ReordableElement> synonyms = [];
  List<ReordableElement> examples = [];
  List<ReordableElement> means = [];
  String mean = "";
  String kindOfWord = "";
  String artikel = "";
  String important = "";

  WordMvc(this.id, this.name, this.quicktranslate);
}
