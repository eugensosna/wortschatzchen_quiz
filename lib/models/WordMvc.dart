import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

class WordMvc {
  int id;
  String uuid;
  String name;
  String quicktranslate = "";
  List<ReordableElement> synonyms = [];
  List<ReordableElement> examples = [];
  List<ReordableElement> means = [];
  String mean = "";
  String? kindOfWord = "";
  int? kindOfWordRef = 0;
  String artikel = "";
  String important = "";
  String baseForm = "";
  int baseLang = 0;
  int rootWordID = 0;
  String currentSession = "";
  bool isNew = false;
  final DbHelper db;
  final AppDataProvider appProvider;

  WordMvc(
    this.db,
    this.appProvider,
    this.id,
    this.name,
    this.uuid,
  );

  static Future<WordMvc> read(AppDataProvider appProvider,
      {Word? word,
      int id = -99,
      String uuid = "",
      String name = "",
      String baseForm = "",
      int baseLang = 0,
      int rootWordID = 0}) async {
    var db = appProvider.db;
    var result = WordMvc(db, appProvider, id, name, uuid);
    var wordDb = await db.getWordById(id, uuid: uuid);
    if (wordDb != null) {
      result.mean = wordDb.mean;
      result.id = wordDb.id;
      result.name = wordDb.name;
      result.important = wordDb.important;
      result.baseForm = wordDb.baseForm;
      result.baseLang = wordDb.baseLang;
      result.rootWordID = wordDb.rootWordID;
      result.quicktranslate = wordDb.description;
      result.kindOfWord = wordDb.kindOfWord;

      result.synonyms = await db.getSynonymsByWord(wordDb.id);
      result.means = await db.getMeansByWord(wordDb.id);
      result.examples = await db.getExamplesByWord(wordDb.id);
      var sessionRow = await db.getSessionEntryByWord(wordDb);
      if (sessionRow != null) {
        result.currentSession = sessionRow.typesession;
      }
      // result
    } else {

      

    }

    if (result.currentSession.isEmpty) {
      result.currentSession = getDefaultSessionName();
    }
    return result;
  }

  Future<WordMvc?> save() async {

    Word? editWordDB;

   
    if (id<=0){
      var idLocal = await db.into(db.words).insert(WordsCompanion.insert(
          name: name,
          important: important,
          description: quicktranslate,
          mean: mean,
          baseForm: baseForm,
          baseLang: baseLang,
            rootWordID: rootWordID,
            kindOfWord: Value<String>(kindOfWord ?? ""),
          ));
      isNew = true;

      editWordDB = await db.getWordById(idLocal);
    } else {
      editWordDB = await db.getWordById(0, uuid: uuid);

      if (editWordDB == null) {
        var idLocal = await db.into(db.words).insert(WordsCompanion.insert(
            name: name,
            important: important,
            description: quicktranslate,
            mean: mean,
            baseForm: baseForm,
            baseLang: baseLang,
            rootWordID: rootWordID));

        editWordDB = await db.getWordById(idLocal);
      }
    }

    if (editWordDB == null) {
      Exception("can't found word in db $id uuid:$uuid name $name ");
    } else {
      id = editWordDB.id;
      var toUpdate = editWordDB.copyWith(
          uuid: uuid,
          name: name,
          important: important,
          description: quicktranslate,
          baseForm: baseForm,
          baseLang: baseLang,
          rootWordID: rootWordID,
          kindOfWord: Value(kindOfWord));

      if (mean.isNotEmpty) {
        means.firstWhere(
          (element) => element.name == mean,
          orElse: () {
            var newElement =
                ReordableElement(id: 0, name: mean, translate: "", orderId: 1, uuid: "");
            means.insert(0, newElement);
            return newElement;
          },
        );
      }

      await db.updateWord(toUpdate);
      await saveMeansToBase(means, toUpdate);
      await saveSynonymsToBase(synonyms, toUpdate);
      appProvider.saveWordToSession(toUpdate, currentSession);
      await saveExamplesToBase(examples, toUpdate);
      

      // appProvider.addExamplesToBase(examples.map((e) => e.name,), editWord)
    }
    return this;

  }

  saveExamplesToBase(List<ReordableElement> listToWrite, Word editWord,
      {bool rewrite = false}) async {
    //await db.deleteExamplesByWord(editWord);
    for (var element in listToWrite) {
      if (element.uuid.isNotEmpty) {
        var foundRow = await db.getExampleByIdOrUuid(0, uuid: element.uuid);
        if (foundRow == null) {
          var newId = await db
              .into(db.examples)
              .insert(ExamplesCompanion.insert(baseWord: editWord.id, name: element.name));
          foundRow = await db.getExampleByIdOrUuid(
            newId,
          );
        }
        if (foundRow != null) {
          var toUpdate = foundRow.copyWith(
              baseWord: editWord.id, exampleOrder: element.orderId, name: element.name, uuid: uuid);
          db.update(db.examples).replace(toUpdate);
        }
      }
      await db
          .into(db.examples)
          .insert(ExamplesCompanion.insert(baseWord: editWord.id, name: element.name));

      if (element.translate.isEmpty) {
        var translated = await db.getTranslateString(element.translate,
            appProvider.translator.baseLang!.id, appProvider.translator.targetLanguage!.id);
        if (translated.isEmpty) {
          await addToTranslate(element);
        }
      } else {
        var list = await db.getTranslatedWord(element.name, appProvider.translator.baseLang!.id,
            appProvider.translator.targetLanguage!.id);
        if (list.isNotEmpty) {
          if (list[0].translatedName != element.translate) {
            var toUpdate = list[0].copyWith(translatedName: element.translate);
            await db.update(db.translatedWords).replace(toUpdate);
          }
        } else {
          await addToTranslate(element);
        }
      }
    }

    appProvider.updateAll();
  }

  saveMeansToBase(List<ReordableElement> listToWrite, Word editWord, {bool rewrite = false}) async {
    //await db.deleteExamplesByWord(editWord);
    for (var element in listToWrite) {
      var foundRow = await db.getMeanByIdOrUuid(0, uuid: element.uuid);
      await insertUpdateMeans(foundRow, editWord, element);

      await saveTranslate(element);
    }

    appProvider.updateAll();
  }

  saveSynonymsToBase(List<ReordableElement> listToWrite, Word editWord,
      {bool rewrite = false}) async {
    //await db.deleteExamplesByWord(editWord);
    for (var element in listToWrite) {
      var foundRow = await db.getSynonymById(0, uuid: element.uuid);
      await insertUpdateSynonyms(foundRow, editWord, element);

      await saveTranslate(element);
    }

    appProvider.updateAll();
  }

  Future<void> saveTranslate(ReordableElement element) async {
    if (element.translate.isEmpty) {
      var translated = await db.getTranslateString(element.translate,
          appProvider.translator.baseLang!.id, appProvider.translator.targetLanguage!.id);
      if (translated.isEmpty) {
        await addToTranslate(element);
      }
    } else {
      var list = await db.getTranslatedWord(element.name, appProvider.translator.baseLang!.id,
          appProvider.translator.targetLanguage!.id);
      if (list.isNotEmpty) {
        if (list[0].translatedName != element.translate) {
          var toUpdate = list[0].copyWith(translatedName: element.translate);
          await db.update(db.translatedWords).replace(toUpdate);
        }
      } else {
        await addToTranslate(element);
      }
    }
  }

  Future<void> insertUpdateMeans(Mean? foundRow, Word editWord, ReordableElement element) async {
    if (foundRow == null) {
      var newId = await db
          .into(db.means)
          .insert(MeansCompanion.insert(baseWord: editWord.id, name: element.name));
      foundRow = await db.getMeanByIdOrUuid(
        newId,
      );
    }
    if (foundRow != null) {
      var toUpdate = foundRow.copyWith(
          baseWord: editWord.id,
          meansOrder: element.orderId,
          name: element.name,
        uuid: element.uuid,
      );
      //foundRow.copyWith(
      //  baseWord: editWord.id, exampleOrder: element.orderId, name: element.name, uuid: uuid);
      await db.update(db.means).replace(toUpdate);
    }
  }

  Future<void> insertUpdateSynonyms(
      Synonym? foundRow, Word editWord, ReordableElement element) async {
    if (foundRow == null) {
      var newId = await db.into(db.synonyms).insert(SynonymsCompanion.insert(
          baseWord: editWord.id,
          synonymWord: 0,
          name: element.name,
          baseLang: baseLang,
          translatedName: ""));
      //.insert(MeansCompanion.insert(baseWord: editWord.id, name: element.name));
      foundRow = await db.getSynonymById(
        newId,
      );
    }
    if (foundRow != null) {
      var toUpdate = foundRow.copyWith(name: element.name, uuid: element.uuid);
      await db.update(db.synonyms).replace(toUpdate);
    }
  }


  Future<void> addToTranslate(ReordableElement element) async {
    await db.into(db.translatedWords).insert(TranslatedWordsCompanion.insert(
        baseLang: appProvider.translator.baseLang!.id,
        targetLang: appProvider.translator.targetLanguage!.id,
        name: element.name,
        translatedName: element.translate));
  }


  static WordMvc fromJson(Map<String, dynamic> json, AppDataProvider appProvider) {
    var db = appProvider.db;
    var result = WordMvc(db, appProvider, -99, '', '');
    result.id = json["id"];
    result.mean = json["mean"];
    result.name = json["name"];
    result.currentSession = json.containsKey("currentSession") ? json["currentSession"] : "";

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
    if (json.containsKey("synonyms")) {
      for (var element in json["synonyms"]) {
        result.synonyms.add(ReordableElement.fromJson(element));
      }
    }

    if (json.containsKey("examples")) {
      for (var element in json["synonyms"]) {
        result.examples.add(ReordableElement.fromJson(element));
      }
    }
    if (json.containsKey("means")) {
      for (var element in json["synonyms"]) {
        result.means.add(ReordableElement.fromJson(element));
      }
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      
      'name': name,
      'mean': mean,
      'kindOfWord': kindOfWord ?? "",
      'uuid': uuid,
      'currentSession': currentSession,
      'quicktranslate': quicktranslate,
      'artikel': artikel,
      'important': important,
      'synonyms': synonyms.map((e) => e.toJson()).toList(),
      'examples': examples.map((e) => e.toJson()).toList(),
      'means': means.map((e) => e.toJson()).toList()
    };
  }
}
