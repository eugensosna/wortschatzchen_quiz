import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

import '../api/leipzig_parse.dart';

class LeipzigWord {
  String name;
  List<leipzSynonym> Synonym = [];
  List<MapTextUrls> Examples = [];
  List<String> Definitions = []; // means
  String KindOfWort = "";
  String BaseWord = "";
  String BaseWordFor = "";
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
        if (BaseWord.isNotEmpty && BaseWord != name) {
          var wordFromBaseWord = await getLeipzigHtml(BaseWord);
          parseHtml(wordFromBaseWord.data.toString(), this);
        }
        url = response.realUri.toString();
      } else {
        return false;
      }

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
      // TODO
    }
  }

  Future<Word?> addWodrUpdateshort(String name, String description,
      Word editWord, Language? baseLang) async {
    var word = await db.getWordByName(name);
    if (word == null) {
      int id = await db.into(db.words).insert(WordsCompanion.insert(
            name: name,
            description: description,
            mean: "",
            baseForm: "",
            important: "",
            rootWordID: editWord.id,
            baseLang: editWord.id <= 0
                ? (baseLang != null ? baseLang.id : 0)
                : editWord.id,
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
    // final DateTime now = DateTime.now();
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = getDefaultSessionName();

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
            important: "",
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
    if (editWord.baseForm.isEmpty) {
      wordToUpdate = wordToUpdate.copyWith(baseForm: word.BaseWord);
    }

    if (word.Artikel.isNotEmpty && wordToUpdate.baseForm.isEmpty) {
      wordToUpdate =
          wordToUpdate.copyWith(baseForm: "${word.Artikel}  ${word.BaseWord}");
      await db.updateWord(wordToUpdate);
    }
    if (word.Artikel.trim().isNotEmpty) {
      wordToUpdate = wordToUpdate.copyWith(important: word.Artikel.trim());
    }
    if (word.Definitions.isNotEmpty && wordToUpdate.mean.isEmpty) {
      var mean = word.Definitions.toString();
      wordToUpdate = wordToUpdate.copyWith(mean: mean);
      for (var item in word.Definitions) {
        await translator.translate(item);
        await db
            .into(db.means)
            .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
      }
    }
    if (Examples.isNotEmpty) {
      var listExamples = await db.getExamplesByWord(editWord.id);
      for (var item in word.Examples) {
        await translator.translate(item.Value!);
        var example =
            await db.getExampleByNameAndWord(item.Value!, editWord.id);
        if (example != null) {
          continue;
        }

        await db.into(db.examples).insert(
            ExamplesCompanion.insert(baseWord: editWord.id, name: item.Value!));
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
    await db.updateWord(wordToUpdate);

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
    var targetLanguageLocal =
        this.targetLanguage ?? await db.getLangByShortName(outputLanguage);

    int id = await db.into(db.translatedWords).insert(
        TranslatedWordsCompanion.insert(
            baseLang: baseLang == null ? baseLangLocal!.id : 0,
            targetLang: targetLanguage == null ? targetLanguageLocal!.id : 0,
            name: input,
            translatedName: outputText));
    return id;
  }

  Future<String> translate(String inputText) async {
    String result = "";

    var timeStart = DateTime.now().millisecond;
    Language? baseLangLocal = await db.getLangByShortName(inputLanguage);
    Language? targetLanguageLocal = await db.getLangByShortName(outputLanguage);
    if (baseLangLocal != null &&
        targetLanguage != null &&
        (baseLang == null || targetLanguage == null)) {
      baseLang = baseLangLocal!;
      targetLanguage = targetLanguageLocal!;
    }
    final shonTranslated =
        await db.getTranslatedWord(inputText, baseLang!.id, targetLanguage!.id);
    if (shonTranslated != null) {
      result = shonTranslated.translatedName;
    } else {
      await Future.delayed(const Duration(milliseconds: 270));

      print((DateTime.now().millisecond - timeStart) / 1000);
      try {
        final translated = await translator.translate(inputText,
            from: inputLanguage, to: outputLanguage);
        result = translated.text;

        addToBase(inputText, result).then((value) => null);
      } catch (e) {
        debugPrint("$e");
      }
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
