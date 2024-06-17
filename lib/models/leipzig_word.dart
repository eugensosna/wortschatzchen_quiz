import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:dio/dio.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

import '../api/leipzig_parse.dart';

class LeipzigWord {
  final Talker talker;
  String name;
  List<LeipzigSynonym> synonyms = [];
  List<MapTextUrls> examples = [];
  List<String> definitions = []; // means
  String kindOfWort = "";
  String baseWord = "";
  String baseWordFor = "";
  List<String> baseWordsFor = [];
  String rawHTML = "";
  String rawHTMLOpen = "";
  String rawHTMLExamples = "";
  String url = "";
  String article = "";
  DbHelper db;

  LeipzigTranslator translator = LeipzigTranslator(db: DbHelper());

  LeipzigWord(this.name, this.db, this.talker);

  Future<String> translateNeededWords() async {
    talker.info("start translateNeededWords");
    var listTranslatedWords = await db.getStringsToTranslate();
    for (var item in listTranslatedWords) {
      if (item.translatedName.isEmpty) {
        var translatedString =
            await translator.translate(item.name, addtoBase: false);
        var toWrite = item.copyWith(translatedName: translatedString);
        db.update(db.translatedWords).replace(toWrite);
      }
    }
    talker.info("end translateNeededWords");
    return "ok";
  }

  Future<List<AutocompleteDataHelper>> getAutocompleteLocal(
      String partOfWord) async {
    var result = <AutocompleteDataHelper>[];
    var words = await db.getWordsByNameLike(partOfWord);
    result = words
        .map((e) =>
            AutocompleteDataHelper(isIntern: true, name: e.name, uuid: e.uuid))
        .toList();

    return result;
  }

  Future<List<AutocompleteDataHelper>> getAutocomplete(
      String partOfWord) async {
    var result = <AutocompleteDataHelper>[];

    final dio = Dio();
    String url =
        "https://api.wortschatz-leipzig.de/ws/words/deu_news_2012_3M/prefixword/${Uri.encodeFull(partOfWord)}?minFreq=1&limit=10";

    try {
      final response = await dio.get(Uri.parse(url).toString());

      //print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var listRawData = response.data as List;
        // print(response.data);

        // var listRawData = json.decode(response.data);
        for (var item in listRawData) {
          var elem = LeipzigApiAutoComplit.fromJson(item);
          result.add(AutocompleteDataHelper(
              name: elem.word!, isIntern: false, uuid: elem.id.toString()));
        }
        // var externalData =
        // LeipzigApiAutoComplit.fromJson(json.decode(response.data));
      }
    } catch (e) {
      talker.error("autocomplite for $partOfWord Url $url");
    }

    return result;
  }

  Future<List<AutocompleteDataHelper>> getAutocompleteVerbForm(
      String partOfWord) async {
    var result = <AutocompleteDataHelper>[];

    final dio = Dio();
    String url =
        "https://www.verbformen.de/suche/i/?w=${Uri.encodeFull(partOfWord)}";
    try {
      final response = await dio.get(Uri.parse(url).toString());

      //print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var listRawData = response.data as List;
        // print(response.data);

        // var listRawData = json.decode(response.data);
        for (var (item as List) in listRawData) {
          if (item.length > 1) {
            var autocompleteName = item.elementAtOrNull(0);
            var description = item.elementAtOrNull(1);

            if (autocompleteName != null) {
              result.add(AutocompleteDataHelper(
                  name: autocompleteName,
                  isIntern: false,
                  uuid: description ?? ""));
            }
          }
        }
        // var externalData =
        // LeipzigApiAutoComplit.fromJson(json.decode(response.data));
      }
    } catch (e) {
      talker.error("autocomplite $partOfWord url $url");
    }

    return result;
  }

  Dio getDio() {
    final dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
          printResponseData: false,
        ),
      ),
    );
    return dio;
  }

  Future<LeipzigWord> parseDataLeipzigWord(LeipzigWord word) async {
    talker.info("start html parse ");
    if (word.rawHTML.isNotEmpty) {
      var temp = await parseHtml(word.rawHTML, word);
    }
    if (word.rawHTMLOpen.isNotEmpty) {
      var listdefOpenThesaurus = await parseHtmlOpenthesaurus(word.rawHTMLOpen);
      word.definitions.addAll(listdefOpenThesaurus);
    }
    if (word.rawHTMLExamples.isNotEmpty) {
      var listExamplesLoc = await parseHtmlExamples(word.rawHTMLExamples);
      if (listExamplesLoc.isNotEmpty) {
        word.examples.clear();
        for (var value in listExamplesLoc.values) {
          for (var item in value) {
            word.examples.add(MapTextUrls(value: item));
          }
        }
      }
    }
    talker.info("return html parse ");

    return word;
  }

  Future<LeipzigWord> parseRawHtmlData(String name, Word editWord) async {
    var timeStart = DateTime.now().microsecond;

    if (rawHTML.isEmpty) {
      talker.info("1. parseRawHtmlData start ");
      getFromInternet(name).then((tempWort) async {
        rawHTML = tempWort.rawHTML;
        rawHTML = tempWort.rawHTML;
        rawHTMLOpen = tempWort.rawHTMLOpen;
        rawHTMLExamples = tempWort.rawHTMLExamples;

        var tempWortForBase = await parseDataLeipzigWord(tempWort);
        name = tempWortForBase.name;
        article = tempWortForBase.article;
        baseWord = tempWortForBase.baseWord;
        kindOfWort = tempWortForBase.kindOfWort;
        url = tempWortForBase.url;
        examples = tempWortForBase.examples;
        definitions = tempWortForBase.definitions;
        synonyms = tempWortForBase.synonyms;
        updateDataDB(tempWort, db, editWord).then((onValue) {
          talker.info("1. parseRawHtmlData end ");
        });
      });
    }

    var tempWort = await getFromInternet(name);
    rawHTML = tempWort.rawHTML;
    rawHTML = tempWort.rawHTML;
    rawHTMLOpen = tempWort.rawHTMLOpen;
    rawHTMLExamples = tempWort.rawHTMLExamples;

    var tempWortForBase = await parseDataLeipzigWord(tempWort);
    name = tempWortForBase.name;
    article = tempWortForBase.article;
    baseWord = tempWortForBase.baseWord;
    kindOfWort = tempWortForBase.kindOfWort;
    url = tempWortForBase.url;
    examples = tempWortForBase.examples;
    definitions = tempWortForBase.definitions;
    synonyms = tempWortForBase.synonyms;

    // if (tempWortForBase.baseWord.isNotEmpty && tempWortForBase.baseWord != tempWortForBase.name) {
    //   name = tempWortForBase.baseWord;
    //   timeStart = DateTime.now().microsecond;

    //   var tempWort = await getFromInternet(baseWord);
    //   return await parseRawHtmlData(baseWord);

    //   result.rawHTML = wordFromBaseWord.data.toString();
    //   wortObj = await parseHtml(wordFromBaseWord.data.toString(), this);
    //   talker.info(
    //       " start get+parse for base $baseWord leipzig data ${DateTime.now().second - timeStart}");
    // }
    // }

    return this;
  }

  Future<LeipzigWord> getLeipzigBaseFromInternet() async {
    LeipzigWord result = LeipzigWord(name, db, talker);
    var dio = Dio();

    try {
      Response response = await getLeipzigHtml(name, dio);
      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        talker.info("get leipzig base data ");
        result.rawHTML = response.data.toString();
        result.url = getUrlForLeipzigCorporaWord(name);
      }
    } catch (e) {
      talker.error("getFromInternet Lepzig data $name", e);
    }

    return result;
  }

  Future<LeipzigWord> getOpenthesaurusFromInternet() async {
    LeipzigWord result = LeipzigWord(name, db, talker);
    var dio = Dio();

    try {
      var responseOpen = await getOpenthesaurus(name, dio);
      result.rawHTMLOpen = responseOpen;
    } catch (e) {
      talker.error("getFromInternet Openthesaurus data $name", e);
    }

    return result;
  }

  Future<LeipzigWord> getFromInternet(String name) async {
    LeipzigWord result = LeipzigWord(name, db, talker);

    talker.info("start getFromInternet $name");
    var timeStart = DateTime.now().microsecond;

    var dio = getDio();

    try {
      Response response = await getLeipzigHtml(name, dio);
      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        talker.info(
            "get leipzig data $name ${DateTime.now().microsecond - timeStart}");
        timeStart = DateTime.now().microsecond;
        result.rawHTML = response.data.toString();
        result.url = getUrlForLeipzigCorporaWord(name);
      }
    } catch (e) {
      talker.error("getFromInternet Lepzig data $name", e);
    }
    try {
      //result.examples = wortObj.examples;
      // var nameToFind =
      //     baseWord.isNotEmpty && baseWord != name ? baseWord : name;

      var responseOpen = await getOpenthesaurus(name, dio);
      result.rawHTMLOpen = responseOpen;
      result.rawHTMLExamples = await getLeipzigExamples(name, dio);

      talker.info("end getFromInternet $name");
    } catch (e) {
      talker.error("getFromInternet openthesaurus $name", e);
    }

    try {
      result.rawHTMLExamples = await getLeipzigExamples(name, dio);
    } catch (e) {
      talker.error("getFromInternet examples $name", e);
    }
    return result;
  }

  Future<Word?> addWordUpdateShort(String name, String description,
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
    Word? word;
    var leipzigTranslator = LeipzigTranslator(db: db);
    await leipzigTranslator.updateLanguagesData();
    // leipzigTranslator.baseLang = baseLang ??
    //     await db.getLangByShortName(leipzigTranslator.inputLanguage);

    //var word = await db.getWordByName(name);
    int id = await db.into(db.words).insert(WordsCompanion.insert(
          name: name,
          description: "",
          mean: "",
          baseForm: "",
          important: "",
          rootWordID: editWord.id,
          baseLang:
              editWord.id <= 0 ? leipzigTranslator.baseLang!.id : editWord.id,
        ));
    await addToSession(id);

    word = await db.getWordById(id);

    if (word != null && word.description.isEmpty) {
      var translatedName = await leipzigTranslator.translate(name);
      if (translatedName.isNotEmpty) {
        word = word.copyWith(description: translatedName);
        db.update(db.words).replace(word);
      }
    }
    return word;
  }

  Future<bool> saveRelationsDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    var wordToUpdate = editWord.copyWith();

    if (word.synonyms.isNotEmpty) {
      await db.deleteSynonymsByWord(editWord);
    }
    await db.updateWord(wordToUpdate);

    if (word.definitions.isNotEmpty) {
      var mean = word.definitions[0];
      if (wordToUpdate.mean.isEmpty) {
        wordToUpdate = wordToUpdate.copyWith(mean: mean);
      }
      await db.deleteMeansByWord(editWord);
      for (var item in word.definitions) {
        // var mean = await db.getMeanByNameAndWord(item, editWord.id);
        // if (mean != null) {
        // await translator.translate(item);
        db
            .into(db.means)
            .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
        translator.addToBase(item, "");
        // translator.translate(item).then((onValue){
        // talker.log("translated string for $item is $onValue");
        // });
        // }
      }
    }
    if (word.examples.isNotEmpty) {
      for (var item in word.examples) {
        var example =
            await db.getExampleByNameAndWord(item.value!, editWord.id);
        if (example != null) {
          continue;
        }
        translator.addToBase(item.value!, "");

        // translator.translate(item.value!).then((onValue){
        // talker.log("translated string for $item is $onValue");
        // });
        await db.into(db.examples).insert(
            ExamplesCompanion.insert(baseWord: editWord.id, name: item.value!));
      }
    }
    for (var item in word.synonyms) {
      Word? elemWordSynonym = await db.getWordByName(item.name);
      var translatedName =
          elemWordSynonym == null ? "" : elemWordSynonym.description;
      translator.addToBase(item.name, "");

      // translator.translate(item.name).then((onValue){
      //   talker.log("translated string for ${item.name} is $onValue");
      //   });

      await db.into(db.synonyms).insert(SynonymsCompanion.insert(
          name: item.name,
          baseWord: editWord.id,
          synonymWord: elemWordSynonym == null ? 0 : elemWordSynonym.id,
          baseLang: editWord.baseLang,
          translatedName: translatedName));
    }

    return true;
  }

  Future<bool> saveBaseDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    talker.info("start updateDataDB $name");
    translator = LeipzigTranslator(db: db);
    await translator.updateLanguagesData();

    var wordToUpdate = editWord.copyWith();
    translator = LeipzigTranslator(db: db);
    await translator.updateLanguagesData();
    if (editWord.baseForm.isEmpty && word.baseWord.isNotEmpty) {
      wordToUpdate = wordToUpdate.copyWith(baseForm: word.baseWord);
    }
    if (word.article.trim().isNotEmpty) {
      wordToUpdate = wordToUpdate.copyWith(important: word.article.trim());
    }
    await db.updateWord(wordToUpdate);
    return true;
  }

  Future<bool> updateDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    talker.info("start updateDataDB $name");
    await saveBaseDataDB(word, db, editWord);
    await saveRelationsDataDB(word, db, editWord);

    // if (word.article.isNotEmpty && wordToUpdate.baseForm.isEmpty) {
    //   wordToUpdate =
    //       wordToUpdate.copyWith(baseForm: "${word.article}  ${word.baseWord}");
    //   await db.updateWord(wordToUpdate);
    // }

    var leipzigEntry = await db.getLeipzigDataByWord(editWord);
    if (leipzigEntry != null) {
      var updatedEntry = leipzigEntry.copyWith(
          url: url,
          html: rawHTML,
          article: article,
          KindOfWort: kindOfWort,
          wordOfBase: baseWord);
      await db.updateLeipzigData(updatedEntry);
    } else {
      await db.into(db.leipzigDataFromIntranet).insert(
          LeipzigDataFromIntranetCompanion.insert(
              baseWord: editWord.id,
              url: url,
              html: rawHTML,
              article: article,
              KindOfWort: kindOfWort,
              wordOfBase: baseWord));
    }

    talker.info("end  updateDateDB $name");
    translateNeededWords().then((onValue) => null);
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
        targetLanguage ?? await db.getLangByShortName(outputLanguage);

    int id = await db.into(db.translatedWords).insert(
        TranslatedWordsCompanion.insert(
            baseLang: baseLang == null ? baseLangLocal!.id : baseLang!.id,
            targetLang: targetLanguage == null
                ? targetLanguageLocal!.id
                : targetLanguage!.id,
            name: input,
            translatedName: outputText));
    return id;
  }

  Future<String> translate(String inputText, {bool addtoBase = true}) async {
    String result = "";
    const int countMillisecondsForGoogle = 270;

    var timeStart = DateTime.now().millisecond;
    Language? baseLangLocal = await db.getLangByShortName(inputLanguage);
    Language? targetLanguageLocal = await db.getLangByShortName(outputLanguage);
    if (baseLangLocal != null &&
        targetLanguageLocal != null &&
        (baseLang == null || targetLanguage == null)) {
      baseLang = baseLangLocal;
      targetLanguage = targetLanguageLocal;
    }
    // final alreadyTranslated = await db.getTranslatedWord(
    //     inputText, baseLangLocal!.id, targetLanguageLocal!.id);
    // if (alreadyTranslated != null) {
    //   result = alreadyTranslated.translatedName;
    // } else {
    if ((DateTime.now().millisecond - timeStart) > countMillisecondsForGoogle) {
      await Future.delayed(
          const Duration(milliseconds: countMillisecondsForGoogle));
    }

    try {
      final translated = await translator.translate(inputText,
          from: inputLanguage, to: outputLanguage);
      result = translated.text;

      if (addtoBase) {
        addToBase(inputText, result).then((value) => null);
      }
    } catch (e) {
      debugPrint("$e");
    }
    // }
    return result;
  }

  updateLanguagesData() async {
    Language? baseLangLocal = await db.getLangByShortName(inputLanguage);
    Language? targetLanguageLocal = await db.getLangByShortName(outputLanguage);
    if (baseLangLocal != null && targetLanguageLocal != null) {
      baseLang = baseLangLocal;
      targetLanguage = targetLanguageLocal;
    }
  }

  LeipzigTranslator(
      {this.inputLanguage = "de",
      this.outputLanguage = "uk",
      required this.db});
}

class LeipzigSynonym {
  String name;
  String translate;
  String leipzigHref = "";
  LeipzigSynonym(this.name, this.translate, this.leipzigHref);
  Map<String, dynamic> toMap() =>
      {"name": name, "translate": translate, "href": leipzigHref};
}

class MapTextUrls {
  String? value;
  String? href;
  MapTextUrls({this.value = "", this.href = ""});
}

class LeipzigApiAutoComplit {
  int? id;
  String? word;
  int? freq;

  LeipzigApiAutoComplit({this.id, this.word, this.freq});

  LeipzigApiAutoComplit.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    word = json['word'];
    freq = json['freq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['word'] = word;
    data['freq'] = freq;
    return data;
  }
}

class AutocompleteDataHelper {
  String name;
  final bool isIntern;
  final String uuid;

  AutocompleteDataHelper(
      {required this.name, required this.isIntern, required this.uuid});

  @override
  String toString() {
    return isIntern ? " $name" : "+ $name";
  }
}
