import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:dio/dio.dart';

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
  LeipzigTranslator translator = LeipzigTranslator(db: DbHelper());

  LeipzigWord(this.name);

  Future<bool> getFromInternet() async {
    Response response = await getLeipzigHtml(this.name);
    if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
      parseHtml(response.data.toString(), this);
      url = response.realUri.toString();
    } else {
      return false;
    }

    return true;
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
    if (word.Definitions.isNotEmpty && editWord.mean.isEmpty) {
      var mean = word.Definitions[0];
      var meanTranslated = await translator.translate(mean);
      wordToUpdate = wordToUpdate.copyWith(mean: "$mean\n$meanTranslated");
      await db.updateWord(wordToUpdate);
      for (var item in word.Definitions) {
        var translatedMean = await translator.translate(item);
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
          synonymWord: elemWordSynonym == null ? 0 : elemWordSynonym!.id,
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
      var translatedBefor = null;
      // await db.getTranslatedWord(inputText, baseLang.id, outputLang.id);
      if (translatedBefor != null) {
        return translatedBefor.translatedName;
      }
    }
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
