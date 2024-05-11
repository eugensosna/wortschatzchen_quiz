import 'package:drift/src/dsl/dsl.dart';
import 'package:drift/src/runtime/query_builder/query_builder.dart';
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
  Translator translator = Translator(db: DbHelper());

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
    translator = Translator(db: db);
    if (word.Synonym.isNotEmpty) {
      await db.deleteSynonymsByWord(editWord);
    }
    for (var item in word.Synonym) {
      Word? elemWordSynonym = await db.getWordByName(item.name);

      await db.into(db.synonyms).insert(SynonymsCompanion.insert(
          name: item.name,
          baseWord: editWord.id,
          synonymWord: elemWordSynonym == null ? 0 : elemWordSynonym.id,
          baseLang: editWord.baseLang,
          translatedName: elemWordSynonym == null
              ? await translator.translate(item.name)
              : elemWordSynonym.description));
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

class Translator {
  String inputLanguage = "de";
  String outputLanguage = "uk";
  DbHelper db;
  final translator = GoogleTranslator();

  Future<int> addToBase(String input, String outputText) async {
    var baseLang = await db.getLangByShortName(inputLanguage);
    var targetLanguage = await db.getLangByShortName(outputLanguage);

    int id = await db.into(db.translatedWords).insert(
        TranslatedWordsCompanion.insert(
            baseLang: baseLang != null ? baseLang.id : 0,
            targetLang: targetLanguage != null ? targetLanguage.id : 0,
            name: input,
            translatedName: outputText));
    return id;
  }

  Future<String> translate(String inputText) async {
    final translated = await translator.translate(inputText,
        from: inputLanguage, to: outputLanguage);

    addToBase(inputText, translated.text).then((value) => null);
    return translated.text;
  }

  Translator(
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
