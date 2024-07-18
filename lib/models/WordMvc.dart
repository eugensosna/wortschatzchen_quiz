import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';

class WordMvc {
  int id;
  String uuid;
  String name;
  String quicktranslate = "";
  List<ReordableElement> synonyms = [];
  List<ReordableElement> examples = [];
  List<ReordableElement> means = [];
  String mean = "";
  String kindOfWord = "";
  String artikel = "";
  String important = "";
  final DbHelper db;
  final AppDataProvider appProvider;

  WordMvc(
    this.db,
    this.appProvider,
    this.id,
    this.name,
    this.uuid,
  );

  static Future<WordMvc> read(DbHelper db, AppDataProvider appProvider,
      {Word? word, int id = -99, String uuid = "", String name = ""}) async {
    var result = WordMvc(db, appProvider, id, name, uuid);
    var wordDb = await db.getWordById(id, uuid: uuid);
    if (wordDb != null) {
      result.mean = wordDb.mean;
      result.name = wordDb.name;
      result.important = wordDb.important;

      result.synonyms = await db.getSynonymsByWord(wordDb.id);
      result.means = await db.getMeansByWord(wordDb.id);
      result.examples = await db.getExamplesByWord(wordDb.id);
      // result
    }
    return result;
  }

  void save() async {
    if (id<=0){
      db.into(db.words).insert(WordsCompanion.insert(name: name, important: important, description: quicktranslate, mean: mean, baseForm: baseForm, baseLang: baseLang, rootWordID: rootWordID))
    }


  }

  WordMvc fromJson(Map<String, dynamic> json) {
    var result = WordMvc(db, appProvider, id, name, uuid);
    result.id = json["id"];
    result.mean = json["mean"];
    result.name = json["name"];

    result.kindOfWord = json.containsKey("kindOfWord") ? json["kindOfWord"] : "";
    result.uuid = json["uuid"];
    result.quicktranslate = json.containsKey("quicktranslate")
        ? json["quicktranslate"]
        : json.containsKey("description")
            ? json["description"]
            : "";
    result.mean = json["mean"];
    result.artikel = json.containsKey("artikel") ? json["artikel"] : "";
    result.important = json["important"];
    result.synonyms = json.containsKey("synonyms")
        ? json["synonyms"].map((e) => ReordableElement.fromJson(e)).toList()
        : [];
    result.examples = json.containsKey("examples")
        ? json["examples"].map((e) => ReordableElement.fromJson(e)).toList()
        : [];
    result.means = json.containsKey("means")
        ? json["means"].map((e) => ReordableElement.fromJson(e)).toList()
        : [];

    return result;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'mean': mean,
      'kindOfWord': kindOfWord,
      'uuid': uuid,
      'quicktranslate': quicktranslate,
      'artikel': artikel,
      'important': important,
      'synonyms': synonyms.map((e) => e.toJson()).toList(),
      'examples': examples.map((e) => e.toJson()).toList(),
      'means': means.map((e) => e.toJson()).toList()
    };
  }
}
