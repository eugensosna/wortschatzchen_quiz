import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class AppDataProvider extends ChangeNotifier {
  final DbHelper _db;
  final Talker _talker = Talker();
  DbHelper get db => _db;
  Talker get talker => _talker;
  late LeipzigTranslator translator;
  List<SessionsGroupedByName> _sessions = [];
  List<SessionsGroupedByName> get sessionsByName => _sessions;
  String currentSession = "";
  List<Word> sessionByFilter = [];
  List<Deck> _decks = [];

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

  void updateSessionByFilter({String current = ""}) async {
    String filter = current.isEmpty ? currentSession : current;
    sessionByFilter = await db.getWordsBySession(filter);
    if (current.isNotEmpty) {
      currentSession = current;
    }
    notifyListeners();
  }

  void updateSessions() async {
    _sessions = await db.getGroupedSessionsByName();
    notifyListeners();
  }

  void updateDecks() async {
    _decks = await db.getQuestions();
  }

  void updateAll() async {
    updateSessions();
    updateSessionByFilter();
    updateDecks();
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
    listOfBaseMeans = await db.getMeansByWord(editWord.id);
    if (editWord.mean.isEmpty && listOfBaseMeans.isNotEmpty) {
      var toUpdate = editWord.copyWith(mean: means[0]);
      db.updateWord(toUpdate);
      editWord = toUpdate;
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

  Future<Deck> addQuizQuestion(String question, String answer, Deck deck,
      {String example = ""}) async {
    var deckDB = await (db.select(db.quizGroup)
          ..where((tbl) => tbl.name.equals(deck.deckTitle)))
        .getSingleOrNull();
    if (deckDB != null) {
      var newId = await db.into(db.question).insert(QuestionCompanion.insert(
          name: question,
          answer: answer,
          example: example,
          refQuizGroup: deckDB.id));
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
