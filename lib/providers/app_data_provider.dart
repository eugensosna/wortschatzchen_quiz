
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class AppDataProvider extends ChangeNotifier {
  final DbHelper _db;
  final Talker _talker = Talker();
  DbHelper get db => _db;
  List<Word> _listWords = [];
  Talker get talker => _talker;
  late LeipzigTranslator translator;
  List<SessionsGroupedByName> _sessions = [];
  List<SessionsGroupedByName> get sessionsByName => _sessions;
  String currentSession = "";
  List<Word> _sessionByFilter = [];
  List<Deck> _decks = [];
  List<Word> get listWords => _listWords;
  List<Word> get sessionByFilter => _sessionByFilter;


  List<Deck> get decks => _decks;

  AppDataProvider(this._db) {
    translator = LeipzigTranslator(db: _db);
    translator.updateLanguagesData();

    //watchers
    db.getGroupedSessionsByNameStream().listen((sessions) async {
      _sessions = await db.getGroupedSessionsByName();
      notifyListeners();
    });
    
  }

  Future<List<Word>> updateSessionByFilter({String current = ""}) async {
    String filter = current.isEmpty ? currentSession : current;
    
    _sessionByFilter = await db.getWordsBySession(filter);
    if (current.isNotEmpty) {
      currentSession = current;
    }
    _sessionByFilter.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    notifyListeners();
    return _sessionByFilter;
  }

  Future<List<Word>> updateListWords() async {
    // widget.talker.info("start get wordList");
    _listWords = await db.getOrdersWordList();
    listWords.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    notifyListeners();

    return listWords;
  }

  void updateSessions() async {
    _sessions = await db.getGroupedSessionsByName();
    notifyListeners();
  }

  void deleteQuestion(Deck deck, QuizCard question) async {
    var toDelete = await db.getQuestionById(question.id);
    if (toDelete != null) {
      db.deleteQuestion(toDelete);
    }

    deck.cards.removeWhere((e) => e.id == question.id);
    updateDecks();
  }

  Future<Deck?> getQuizData(Deck currentDeck) async {
    var result = await db.getQuizById(
        currentDeck.id, translator.baseLang!.id, translator.targetLanguage!.id);

    notifyListeners();
    return result;
  }

  Future<List<Deck>> updateDecks() async {
    _decks = await db.getQuestions();
    notifyListeners();
    return decks;
  }

  void updateAll() async {
    updateSessions();
    updateSessionByFilter();
    updateDecks();
    updateListWords();
  }

  Future<String> translate(String input, {addtoBase = true}) async {
    return await translator.translate(input, addtoBase: addtoBase);
  }

  addMeansToBase(List<String> means, Word editWord) async {
    // if (editWord.mean.isEmpty && means.isNotEmpty) {
    //   var toUpdate = editWord.copyWith(mean: means[0]);
    //   db.updateWord(toUpdate);
    //   editWord = toUpdate;
    // }
    var listOfBaseMeans = await db.getMeansByWord(editWord.id);
    // first filter list of Reordable element in list<Reordable> what in base it
    // List<Reordable> convert to list<String> to check and remove from mens
    // result means insert in the base
    var toSkip = listOfBaseMeans
        .where((e) => means.contains(e.name))
        .map((toElement) => toElement.name)
        .toList();
    means.removeWhere((e) => toSkip.contains(e));

    for (var (index, item) in means.indexed) {
      if (index < 3) {
        await translate(item);
      } else {
        await db.into(db.translatedWords).insert(
            TranslatedWordsCompanion.insert(
                baseLang: translator.baseLang!.id,
                targetLang: translator.targetLanguage!.id,
                name: item,
                translatedName: ""));
      }
      await db
          .into(db.means)
          .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
    }
    var toUpdate = await db.getWordById(editWord.id) ?? editWord;
    listOfBaseMeans = await db.getMeansByWord(editWord.id);
    if (toUpdate.mean.isEmpty && listOfBaseMeans.isNotEmpty) {
      toUpdate = toUpdate.copyWith(mean: means[0]);
      editWord = await db.updateWord(toUpdate);
    }

    updateAll();
  }

addExamplesToBase(List<String> examples, Word editWord) async {
    // if (editWord.mean.isEmpty && means.isNotEmpty) {
    //   var toUpdate = editWord.copyWith(mean: means[0]);
    //   db.updateWord(toUpdate);
    //   editWord = toUpdate;
    // }
    var listOfBaseExamples = await db.getExamplesByWord(editWord.id);
    // first filter list of Reordable element in list<Reordable> what in base it
    // List<Reordable> convert to list<String> to check and remove from mens
    // result means insert in the base
    var toSkip = listOfBaseExamples
        .where((e) => examples.contains(e.name))
        .map((toElement) => toElement.name)
        .toList();
    examples.removeWhere((e) => toSkip.contains(e));

    for (var (index, item) in examples.indexed) {
      if (index < 3) {
        await translate(item);
      } else {
        await db.into(db.translatedWords).insert(TranslatedWordsCompanion.insert(
            baseLang: translator.baseLang!.id,
            targetLang: translator.targetLanguage!.id,
            name: item,
            translatedName: ""));
      }
      await db
          .into(db.examples)
          .insert(ExamplesCompanion.insert(baseWord: editWord.id, name: item));
    }
    updateAll();
  }

  addSynonymsToBase(List<String> itemsToAdd, Word editWord) async {
    var listOfBaseSynonyms = await db.getSynonymsByWord(editWord.id);
    // first filter list of Reordable element in list<Reordable> what in base it
    // List<Reordable> convert to list<String> to check and remove from mens
    // result means insert in the base
    var toSkip = listOfBaseSynonyms
        .where((e) => itemsToAdd.contains(e.name))
        .map((toElement) => toElement.name)
        .toList();
    itemsToAdd.removeWhere((e) => toSkip.contains(e));

    for (var (index, item) in itemsToAdd.indexed) {
      if (index < 3) {
        await translate(item);
      } else {
        await db.into(db.translatedWords).insert(TranslatedWordsCompanion.insert(
            baseLang: translator.baseLang!.id,
            targetLang: translator.targetLanguage!.id,
            name: item,
            translatedName: ""));
      }
      await db.into(db.synonyms).insert(SynonymsCompanion.insert(
          baseWord: editWord.id,
          synonymWord: 0,
          name: item,
          baseLang: editWord.baseLang,
          translatedName: ""));
    }
    updateAll();
  }


  Future<Deck> addQuizGroup(String name) async {
    var newId = await db
        .into(db.quizGroup)
        .insert(QuizGroupCompanion.insert(name: name));
    updateDecks();

    // var resultDB
    var result = _decks.firstWhere(
      (element) => element.deckTitle == name,
      orElse: () => Deck(deckTitle: name, cards: [], id: -99),
    );
    // result ??= ;
    notifyListeners();
    return result;
  }


  Future<Deck> getQuizGroup(String name) async {
    updateDecks();

    // var resultDB
    var result = _decks.firstWhere(
      (element) => element.deckTitle == name,
      orElse: () => Deck(deckTitle: name, cards: [], id: -99),
    );
    // result ??= ;
    notifyListeners();
    return result;
  }

  Future<QuizCard> updateQuestion(
      QuizCard card, String answer, Deck deck, String question,
      {String example = ""}) async {
    QuizCard toReturn =
        QuizCard(question: question, answer: answer, id: card.id, example: "");

    var questionDb = await db.getQuestionById(card.id);
    if (questionDb != null) {
      var toupdate = questionDb.copyWith(name: question, answer: answer, example: example);
      db.update(db.question).replace(toupdate);
      toReturn = QuizCard(
          question: question,
          answer: answer,
          id: card.id,
          example: toupdate.example);
      await updateDecks();
    }
    return toReturn;
  }

  Future<Deck> addQuizQuestion(String question, String answer, Deck deck,
      {String example = "", int wordID = 0}) async {
    var deckDB = await (db.select(db.quizGroup)
          ..where((tbl) => tbl.name.equals(deck.deckTitle)))
        .getSingleOrNull();
    if (deckDB != null) {
      var newId = await db.into(db.question).insert(QuestionCompanion.insert(
          name: question,
          answer: answer,
          example: example,
          refQuizGroup: deckDB.id,
          refWord: Value<int>(wordID)));
      deck.cards.add(
          QuizCard(answer: answer, question: question, example: "", id: newId));
    }

    updateDecks();

    return deck;
  }

  

  void translateNeededWords() async {
    talker.info("start translateNeededWords");
    var listTranslatedWords = await db.getStringsToTranslate();
    for (var item in listTranslatedWords) {
      var updatedItem = await db.getTranslatedWordById(item.id);
      if (updatedItem != null && updatedItem.translatedName.isEmpty) {
        if (item.translatedName.isEmpty) {
          try {
            var translatedString = await translate(item.name, addtoBase: false);

            var toWrite = item.copyWith(translatedName: translatedString);
            db.update(db.translatedWords).replace(toWrite);
          } catch (e) {
            talker.error("translateNeededWords getby Google", e);
          }
          await Future.delayed(const Duration(seconds: 5));
        }
      }
    }
  }
}
