import 'dart:io';

import 'package:dio/io.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';
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
  bool applyRecursionBaseForm = true;
  DbHelper db;
  bool serviceMode = false;

  late LeipzigTranslator translator;

  LeipzigWord(
    this.name,
    this.db,
    this.talker,
  ) {
    translator = LeipzigTranslator(db: db);
  }

  void translateNeededWords() async {
    talker.info("start translateNeededWords");
    var listTranslatedWords = await db.getStringsToTranslate();
    for (var item in listTranslatedWords) {
      var updatedItem = await db.getTranslatedWordById(item.id);
      if (updatedItem != null && updatedItem.translatedName.isEmpty) {
        if (item.translatedName.isEmpty) {
          try {
            var translatedString =
                await translator.translate(item.name, addtoBase: false);

            var toWrite = item.copyWith(translatedName: translatedString);
            db.update(db.translatedWords).replace(toWrite);
          } catch (e) {
            talker.error("translateNeededWords getby Google", e);
          }
          await Future.delayed(const Duration(seconds: 5));
        }
      }
    }

    talker.info("end translateNeededWords", talker);
    // return "ok";
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
          var elem = LeipzigApiAutoComplite.fromJson(item);
          result.add(AutocompleteDataHelper(
              name: elem.word!, isIntern: false, uuid: elem.id.toString()));
        }
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
            item.elementAtOrNull(1);

            if (autocompleteName != null) {
              result.add(AutocompleteDataHelper(
                  name: autocompleteName, isIntern: false, uuid: Uuid().v4()));
            }
          }
        }
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
      var listExamplesLoc = parseHtmlExamples(word.rawHTMLExamples);
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

  Future<LeipzigWord> parseDataExamplesWord(
      LeipzigWord word, Word editWord) async {
    talker.info("start html parse ");
    if (word.rawHTMLExamples.isNotEmpty) {
      var listExamplesLoc = parseHtmlExamples(word.rawHTMLExamples);
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

  Future<LeipzigWord> getParseAllData(LeipzigWord wort, Word editWord) async {
    talker.info("start then getLeipzigBaseFromInternet");
    wort = await getLeipzigBaseFromInternet(wort);
    wort = await wort.parseDataLeipzigWord(wort);
    await wort.saveBaseDataDB(wort, db, editWord);
    talker.info("end then getLeipzigBaseFromInternet");

    talker.info("start getOpenthesaurusFromInternet");

    wort = await wort.getOpenthesaurusFromInternet();
    wort = await wort.parseOpenthesaurus(wort);
    await wort.saveRelationsDataDB(wort, db, editWord);
    talker.info("end getOpenthesaurusFromInternet");

    talker.info("start then getLeipzigExamplesFromInternet");

    wort = await wort.parseDataExamplesWord(wort, editWord);

    await wort.saveRelationsDataDB(wort, db, editWord);
    talker.info("end then getLeipzigExamplesFromInternet");

    return wort;
  }

  Future<LeipzigWord> getParseAllDataSpeed(
      LeipzigWord wort, Word editWord, Function onProgress) async {
    talker.info("start sync getLeipzigBaseFromInternet");
    wort.getLeipzigBaseFromInternet(wort).then((onValue) async {
      var wortL = await wort.parseDataLeipzigWord(onValue);
      await wortL.saveBaseDataDB(wortL, db, editWord);
      talker.info("end then getLeipzigBaseFromInternet");
      onProgress(0.5);
    });

    talker.info("start getOpenthesaurusFromInternet");
    onProgress(0.7);
    wort = await wort.getOpenthesaurusFromInternet();
    wort = await wort.parseOpenthesaurus(wort);
    onProgress(0.8);
    await wort.saveRelationsDataDB(wort, db, editWord);
    talker.info("end getOpenthesaurusFromInternet");

    talker.info("start then getLeipzigExamplesFromInternet");
    onProgress(0.8);
    wort.getLeipzigExamplesFromInternet().then((onValue) {
      onValue.parseDataExamplesWord(onValue, editWord).then((onValue) async {
        await onValue.saveRelationsDataDB(onValue, db, editWord);
        onProgress(0.95);
        talker.info("end then getLeipzigExamplesFromInternet");
      });
    });

    return wort;
  }

  Future<LeipzigWord> parseOpenthesaurus(LeipzigWord wort) async {
    if (wort.rawHTMLOpen.isNotEmpty) {
      var tempDefinitions = await parseHtmlOpenthesaurus(wort.rawHTMLOpen);
      tempDefinitions.addAll(wort.definitions);
      wort.definitions = tempDefinitions;
    }
    return wort;
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
        talker.info("2. parseRawHtmlData parseDataLeipzigWord ");

        name = tempWortForBase.name;
        article = tempWortForBase.article;
        baseWord = tempWortForBase.baseWord;
        kindOfWort = tempWortForBase.kindOfWort;
        url = tempWortForBase.url;
        examples = tempWortForBase.examples;
        definitions = tempWortForBase.definitions;
        synonyms = tempWortForBase.synonyms;
        parseDataLeipzigWord(tempWortForBase).then(
          (value) {
            talker.info("3. parseRawHtmlData parseDataLeipzigWord ");

            updateDataDB(tempWort, db, editWord).then((onValue) {
              talker.info("1. parseRawHtmlData END updateDataDB ");
            });
          },
        );
        parseOpenthesaurus(tempWortForBase).then((onValue) {
          updateDataDB(onValue, db, editWord);
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

  Future<LeipzigWord> getLeipzigBaseFromInternet(LeipzigWord wort) async {
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

  Future<LeipzigWord> getLeipzigExamplesFromInternet() async {
    LeipzigWord result = LeipzigWord(name, db, talker);
    var dio = Dio();

    try {
      String response = await getLeipzigExamples(name, dio);
      if (response.isNotEmpty) {
        //talker.info("get leipzig base data ");
        result.rawHTMLExamples = response;
        //result.url = getUrlForLeipzigCorporaWord(name);
      }
    } catch (e) {
      talker.error("getFromInternet Examples data $name", e);
    }

    return result;
  }

  Future<LeipzigWord> getOpenthesaurusFromInternet() async {
    LeipzigWord result = LeipzigWord(name, db, talker);
    var dio = Dio();

    try {
      var responseOpen = await getOpenthesaurus(name, dio);
      rawHTMLOpen = responseOpen;
    } catch (e) {
      talker.error("getFromInternet Openthesaurus data $name", e);
    }

    return this;
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
          wordToWrite = await db.updateWord(wordToWrite);
          return wordToWrite;
        }
      }
    }
    return word;
  }

  addToSession(int id) async {
    if (serviceMode) {
      return;
    }
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
    String translatedName = "";

    talker.info("add to DB $name");
    var leipzigTranslator = LeipzigTranslator(db: db);
    await leipzigTranslator.updateLanguagesData();
    translatedName = await leipzigTranslator.translate(name);
    // leipzigTranslator.baseLang = baseLang ??
    //     await db.getLangByShortName(leipzigTranslator.inputLanguage);

    //var word = await db.getWordByName(name);
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

    if (word != null && word.description.isEmpty) {
      if (translatedName.isEmpty) {
        translatedName = await leipzigTranslator.translate(name);
      }
      word = word.copyWith(description: translatedName);
      await db.updateWord(word);
      // db.update(db.words).replace(word);
    }

    return word;
  }

  Future<bool> saveExamplesDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    if (word.examples.isNotEmpty) {
      for (var item in word.examples) {
        var example =
            await db.getExampleByNameAndWord(item.value!, editWord.id);
        if (example != null) {
          continue;
        }
        var exampleText = item.value;
        if (exampleText != null) {
          await translator.translate(exampleText);

          // translator.translate(item.value!).then((onValue){
          // talker.log("translated string for $item is $onValue");
          // });
          await db.into(db.examples).insert(ExamplesCompanion.insert(
              baseWord: editWord.id, name: item.value!));
        }
        // translator.addToBase(item.value!, "");
      }
    }
    return true;
  }

  Future<bool> saveRelationsDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    editWord = await db.getWordById(editWord.id) ?? editWord;

    var wordToUpdate = editWord.copyWith();

    editWord = await db.updateWord(wordToUpdate);

    if (word.definitions.isNotEmpty) {
      var mean = word.definitions[0];
      if (wordToUpdate.mean.isEmpty || serviceMode) {
        wordToUpdate = editWord.copyWith(mean: mean);
        editWord = await db.updateWord(wordToUpdate);
      }
      await db.deleteMeansByWord(editWord);
      for (var item in word.definitions) {
        // var mean = await db.getMeanByNameAndWord(item, editWord.id);
        // if (mean != null) {
        await translator.translate(item);
        db
            .into(db.means)
            .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
        // translator.addToBase(item, "");
        // translator.translate(item).then((onValue){
        // talker.log("translated string for $item is $onValue");
        // });
        // }
      }
    }

    try {
      await saveExamplesDataDB(word, db, editWord);
    } catch (e) {
      talker.error("saveExamplesDataDB", e);
    }

    try {
      if (word.synonyms.isNotEmpty) {
        List<String> listStrings = word.synonyms.map((e) => e.name).toList();
        var listOfBase = await db.getSynonymsByWord(editWord.id);
        // first filter list of Reordable element in list<Reordable> what in base it
        // List<Reordable> convert to list<String> to check and remove from mens
        // result means insert in the base
        var toSkip = listOfBase
            .where((e) => listStrings.contains(e.name))
            .map((toElement) => toElement.name)
            .toList();
        listStrings.removeWhere((e) => toSkip.contains(e));

        for (var (index, item) in listStrings.indexed) {
          var translatedName = "";
          Word? elemWordSynonym = await db.getWordByName(item);

          if (index < 3) {
            translatedName = (elemWordSynonym != null)
                ? elemWordSynonym.description
                : await translator.translate(item);

            // translatedName = await translator.translate(item);
          } else {
            await db.into(db.translatedWords).insert(
                TranslatedWordsCompanion.insert(
                    baseLang: translator.baseLang!.id,
                    targetLang: translator.targetLanguage!.id,
                    name: item,
                    translatedName: ""));
          }
          await db.into(db.synonyms).insert(SynonymsCompanion.insert(
              name: item,
              baseWord: editWord.id,
              synonymWord: elemWordSynonym == null ? 0 : elemWordSynonym.id,
              baseLang: editWord.baseLang,
              translatedName: translatedName));
        }

        // await db.deleteSynonymsByWord(editWord);
      }
    } catch (e) {
      talker.error("saveRelationsDataDB synonyms ", e);
    }

    return true;
  }

  Future<bool> saveBaseDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    talker.info("start saveBaseDataDB $name");
    translator = LeipzigTranslator(db: db);
    editWord = await db.getWordById(editWord.id) ?? editWord;
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

    if (word.kindOfWort == "Nomen" &&
        translator.inputLanguage == "de" &&
        wordToUpdate.name.substring(0, 1).toLowerCase() ==
            wordToUpdate.name.substring(0, 1)) {
      var first = wordToUpdate.name.substring(0, 1).toUpperCase();
      var last = wordToUpdate.name.substring(1);
      var newName = "$first$last";
      wordToUpdate = wordToUpdate.copyWith(name: newName);
    }

    await db.updateWord(wordToUpdate);
    editWord = wordToUpdate.copyWith();
    if (wordToUpdate.baseForm.trim().isNotEmpty &&
        wordToUpdate.name != wordToUpdate.baseForm &&
        applyRecursionBaseForm) {
      var baseFormWord = await db.getWordByName(wordToUpdate.baseForm);
      baseFormWord = baseFormWord ??
          await addNewWord(
              wordToUpdate.baseForm,
              Word(
                  id: -99,
                  uuid: "",
                  name: wordToUpdate.baseForm,
                  important: "",
                  description: "",
                  mean: "",
                  baseForm: "",
                  baseLang: translator.baseLang!.id,
                  rootWordID: 0),
              translator.baseLang);

      if (baseFormWord != null) {
        var toUpdate = wordToUpdate.copyWith(
            rootWordID: baseFormWord.id, baseForm: word.baseWord);
        editWord = await db.updateWord(toUpdate);
        editWord = toUpdate;
      } else {
        var leipzigRecursWord = LeipzigWord(editWord.baseForm, db, talker);

        leipzigRecursWord.applyRecursionBaseForm = false;

        var baseFormWord = await leipzigRecursWord.addWordUpdateShort(
            editWord.baseForm, "", editWord, translator.baseLang);

        talker.info(
            "start parseRawHtmlData for BaseForm ${baseFormWord!.name} from $name");
        leipzigRecursWord.parseRawHtmlData(name, baseFormWord).then((onValue) {
          talker.info(
              "end parseRawHtmlData for BaseForm ${baseFormWord!.name} from $name");
        });
      }
      // parseRawHtmlData(onValue.name, toUpdate);
    }
    try {
      await saveRelationsDataDB(word, db, editWord);
    } catch (e) {}
    return true;
  }

  Future<bool> updateDataDB(
      LeipzigWord word, DbHelper db, Word editWord) async {
    talker.info("start updateDataDB $name");
    editWord = await db.getWordById(editWord.id) ?? editWord;

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
      await db
          .into(db.leipzigDataFromIntranet)
          .insert(LeipzigDataFromIntranetCompanion.insert(
            baseWord: editWord.id,
            url: url,
            html: rawHTML,
            article: article,
            KindOfWort: kindOfWort,
            wordOfBase: baseWord,
          ));
    }

    talker.info("end  updateDateDB $name");
    // translateNeededWords();
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
  final lt = SimplyTranslator(EngineType.libre);

  Future<int> addToBase(String input, String outputText) async {
    Language? baseLangLocal =
        (baseLang ?? await db.getLangByShortName(inputLanguage));
    var targetLanguageLocal =
        targetLanguage ?? await db.getLangByShortName(outputLanguage);
    var translated = await db.getTranslatedWord(
        input, baseLangLocal!.id, targetLanguageLocal!.id);
    if (translated.isNotEmpty) {
      if (outputText.isNotEmpty && translated[0].translatedName != outputText) {
        var toUpdate = translated[0].copyWith(translatedName: outputText);
        await db.update(db.translatedWords).replace(toUpdate);
      }
      return translated[0].id;
    } else {
      int id = await db.into(db.translatedWords).insert(
          TranslatedWordsCompanion.insert(
              baseLang: baseLang == null ? baseLangLocal.id : baseLang!.id,
              targetLang: targetLanguage == null
                  ? targetLanguageLocal.id
                  : targetLanguage!.id,
              name: input,
              translatedName: outputText));
      return id;
    }
  }

  Future<String> translate(String inputText, {bool addtoBase = true}) async {
    var result = "";
    const int countMillisecondsForGoogle = 270;

    var timeStart = DateTime.now().millisecond;
    Language? baseLangLocal =
        baseLang ?? await db.getLangByShortName(inputLanguage);
    Language? targetLanguageLocal =
        targetLanguage ?? await db.getLangByShortName(outputLanguage);
    if (baseLangLocal != null &&
        targetLanguageLocal != null &&
        (baseLang == null || targetLanguage == null)) {
      baseLang = baseLangLocal;
      targetLanguage = targetLanguageLocal;
    }
    // if ((DateTime.now().millisecond - timeStart) > countMillisecondsForGoogle) {
    //   await Future.delayed(
    //       const Duration(milliseconds: countMillisecondsForGoogle));
    // }

    try {
      final translated = await translator.translate(inputText,
          from: inputLanguage, to: outputLanguage);
      result = translated.text;
    } catch (e) {
      try {
        final translated = await lt.translateSimply(inputText,
            from: inputLanguage, to: outputLanguage);
        result = encodeToHumanText(translated.translations.text.toString());
      } catch (e) {
        result = "";
      }
    }
    if (addtoBase) {
      await addToBase(inputText, result);
    }

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

class LeipzigApiAutoComplite {
  int? id;
  String? word;
  int? freq;

  LeipzigApiAutoComplite({this.id, this.word, this.freq});

  LeipzigApiAutoComplite.fromJson(Map<dynamic, dynamic> json) {
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
  String unviewUnicode = "	";

  AutocompleteDataHelper(
      {required this.name, required this.isIntern, required this.uuid});

  @override
  String toString() {
    return isIntern ? " $name $unviewUnicode" : "+ $name $unviewUnicode";
  }
}
