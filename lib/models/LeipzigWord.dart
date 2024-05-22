import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


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
  String url = "";
  String Artikel = "";
  DbHelper db;

  LeipzigTranslator translator = LeipzigTranslator(db: DbHelper());

  LeipzigWord(this.name, this.db);

  Future<bool> getFromInternet() async {
    try {
      Response response = await getLeipzigHtml(name);
      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        parseHtml(response.data.toString(), this);
        url = response.realUri.toString();
      } else {
        return false;
      }

      return true;
    } on Exception catch (e) {
      return false;
      // TODO
    }
  }
  Future<Word?> addWodrUpdateshort(
      String name, String description, Word editWord, Language? baseLang) async {
    var word = await db.getWordByName(name);
    if (word == null) {
      int id = await db.into(db.words).insert(WordsCompanion.insert(
            name: name,
            description: description,
            mean: "",
            baseForm: "",
            immportant: "",
            rootWordID: editWord.id,
            baseLang: editWord.id <= 0 ? (baseLang != null ? baseLang.id : 0) : editWord.id,
          ));
      await addToSession(id);

      word = await db.getWordById(id);
    } else {
      if (description.isEmpty) {
        if (word.description != description) {
          var wordToWrite = word.copyWith(description: description);
          await db.updateWord(wordToWrite);
          return wordToWrite;
        }
      }
    }
    return word;
  }

  addToSession(int id) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    await db
        .into(db.sessions)
        .insert(SessionsCompanion.insert(baseWord: id, typesession: formatted));
  }

  Future<Word?> addNewWord(
      String name, Word editWord, Language? baseLang) async {
    var leipzigTranslator = LeipzigTranslator(db: db);
    leipzigTranslator.baseLang = baseLang ??
        await db.getLangByShortName(leipzigTranslator.inputLanguage);

    var word = await db.getWordByName(name);
    if (word == null) {
      var translatedName = await leipzigTranslator.translate(name);
      int id = await db.into(db.words).insert(WordsCompanion.insert(
            name: name,
            description: translatedName,
            mean: "",
            baseForm: "",
            immportant: "",
            rootWordID: editWord.id,
            baseLang:
                editWord.id <= 0 ? leipzigTranslator.baseLang!.id : editWord.id,
          ));
      await addToSession(id);

      word = await db.getWordById(id);
    }
    return word;
  }

  Future<bool> updateDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    var wordToUpdate = editWord.copyWith();
    translator = LeipzigTranslator(db: db);
    if (word.Synonym.isNotEmpty) {
      await db.deleteSynonymsByWord(editWord);
    }
    if (word.Artikel.isNotEmpty && editWord.baseForm.isEmpty) {
      wordToUpdate =
          wordToUpdate.copyWith(baseForm: "${word.Artikel}  ${word.BaseWord}");
      await db.updateWord(wordToUpdate);
    }
    if (word.Artikel.trim().isNotEmpty) {
      wordToUpdate = wordToUpdate.copyWith(immportant: word.Artikel.trim());
    }
    if (word.Definitions.isNotEmpty && editWord.mean.isEmpty) {
      var mean = word.Definitions.toString();
      wordToUpdate = wordToUpdate.copyWith(mean: mean);
      await db.updateWord(wordToUpdate);
      for (var item in word.Definitions) {
        await translator.translate(item);
        await db
            .into(db.means)
            .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
      }
    }
    for (var item in word.Synonym) {
      Word? elemWordSynonym = await db.getWordByName(item.name);
      var translatedName = elemWordSynonym == null
          ? await translator.translate(item.name)
          : elemWordSynonym.description;

      await db.into(db.synonyms).insert(SynonymsCompanion.insert(
          name: item.name,
          baseWord: editWord.id,
          synonymWord: elemWordSynonym == null ? 0 : elemWordSynonym.id,
          baseLang: editWord.baseLang,
          translatedName: translatedName));
    }

    var leipzigEntry = await db.getLeipzigDataByWord(editWord);
    if (leipzigEntry != null) {
      var updatedEntry = leipzigEntry.copyWith(
          url: url,
          html: rawHTML,
          article: Artikel,
          KindOfWort: KindOfWort,
          wordOfBase: BaseWord);
      await db.updateLeipzigData(updatedEntry);
    } else {
      await db.into(db.leipzigDataFromIntranet).insert(
          LeipzigDataFromIntranetCompanion.insert(
              baseWord: editWord.id,
              url: url,
              html: rawHTML,
              article: Artikel,
              KindOfWort: KindOfWort,
              wordOfBase: BaseWord));
    }

    return true;
  }
}

class LeipzigTranslator {
  String inputLanguage = "de";
  Language? baseLang;
  Language? targetLanguage;
  String outputLanguage = "uk";
  DbHelper db;
  final translator = GoogleTranslator();

  Future<int> addToBase(String input, String outputText) async {
    Language? baseLangLocal =
        (baseLang ?? await db.getLangByShortName(inputLanguage));
    var targetLanguage =
        this.targetLanguage ?? await db.getLangByShortName(outputLanguage);

    int id = await db.into(db.translatedWords).insert(
        TranslatedWordsCompanion.insert(
            baseLang: baseLang != null ? baseLangLocal!.id : 0,
            targetLang: targetLanguage != null ? targetLanguage.id : 0,
            name: input,
            translatedName: outputText));
    return id;
  }

  Future<String> translate(String inputText) async {
    Language? baseLang = await db.getLangByShortName(inputLanguage);
    Language? outputLang = await db.getLangByShortName(outputLanguage);
    if (baseLang != null && outputLang != null) {
      var translatedBefor;
    }
    await Future.delayed(const Duration(milliseconds: 270));
    String result = "";
    try {
      final translated = await translator.translate(inputText,
          from: inputLanguage, to: outputLanguage);
      result = translated.text;
      addToBase(inputText, result).then((value) => null);
    } catch (e) {
      debugPrint("$e");
    }
    return result;
  }

  LeipzigTranslator(
      {this.inputLanguage = "de",
      this.outputLanguage = "uk",
      required this.db});
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
