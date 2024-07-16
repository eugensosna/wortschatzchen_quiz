import 'package:drift/drift.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

import 'db.dart';

class SynonymsEntry {
  Word word;
  List<SynonymsCompanion> synonymsItems;
  SynonymsEntry(this.word, this.synonymsItems);
}

class DbHelper extends AppDatabase {
  @override
  String pathToFile = "";

  DbHelper({this.pathToFile = ""}) : super(pathToFile: pathToFile);

  Future<Language?> getLangByShortName(String name) async {
    return (select(languages)
          ..where((tbl) => tbl.shortName.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<ReordableElement>> getSynonymsByWord(int wordId) async {
    List<ReordableElement> result = [];
    // final list = await (select(synonyms)
    //       ..where((tbl) => tbl.baseWord.equals(wordId))
    //       ..orderBy([(u) => OrderingTerm(expression: u.id)]))
    //     .get();
    // list.map(
    //   (e) => result.add(ReordableElement.map(e.toColumns(false))),
    // );
    // return result;

    var customQuery = customSelect('''
        select synonyms.id as id,Max(synonyms.uuid) as uuid, Max( translated_words.translated_name) as translate, max(words.description) as word_translate,  Max(synonyms.name) as name, max(synonyms.id) as orderid from synonyms


        left JOIN translated_words
        on  translated_words.name = synonyms.name
        left JOIN words
		on synonyms.name = words.name
        
        WHERE synonyms.base_word = ?
        GROUP BY synonyms.id 
        order by orderid''',
        readsFrom: {sessions}, variables: [Variable.withInt(wordId)]);
    var listExamples = await customQuery.get();
    for (var item in listExamples) {
      var element = ReordableElement.map(item.data);
      if (item.data["word_translate"] != null) {
        element.translate = item.data["word_translate"];
      }
      result.add(element);
    }
    //print(item.data.toString());

    return result;
  }

  Future<List<ReordableElement>> getExamplesByWord(int wordId) async {
    List<ReordableElement> result = [];

    // final listExamples = await (select(examples)
    //       ..where((tbl) => tbl.baseWord.equals(wordId))
    //       ..orderBy([(u) => OrderingTerm(expression: u.exampleOrder)]))
    //     .get();

    // List<SessionsGroupedByName> result = [];
    var customQuery = customSelect('''
        select examples.id,Max(examples.uuid) as uuid, Max(translated_words.translated_name) as translate, Max(examples.name) as name, Max(examples.example_order) as orderid from examples

        left JOIN translated_words
        on  translated_words.name = examples.name
        WHERE examples.base_word = ?
        Group By examples.id
        order by orderid''',
        readsFrom: {sessions}, variables: [Variable.withInt(wordId)]);
    var listExamples = await customQuery.get();
    for (var item in listExamples) {
      var element = ReordableElement.map(item.data);
      result.add(element);
    }
    //print(item.data.toString());

    return result;
  }

  Future<List<ReordableElement>> getMeansByWord(int wordId) async {
    List<ReordableElement> result = [];

    // final listExamples = await (select(examples)
    //       ..where((tbl) => tbl.baseWord.equals(wordId))
    //       ..orderBy([(u) => OrderingTerm(expression: u.exampleOrder)]))
    //     .get();

    // List<SessionsGroupedByName> result = [];
    var customQuery = customSelect('''
        select means.id,Max(means.uuid) as uuid, Max(translated_words.translated_name) as translate, Max(means.name) as name, Max(means.means_order) as orderid from means

        left JOIN translated_words
        on  translated_words.name = means.name
        WHERE means.base_word = ?
        Group By means.id
        order by orderid''',
        readsFrom: {means}, variables: [Variable.withInt(wordId)]);
    var listExamples = await customQuery.get();
    for (var item in listExamples) {
      var element = ReordableElement.map(item.data);
      result.add(element);
    }
    //print(item.data.toString());

    return result;
  }

  Future<Mean?> getMeanByNameAndWord(String name, int wordId) async {
    return (select(means)
          ..where((tbl) => Expression.and(
              [tbl.name.equals(name), tbl.baseWord.equals(wordId)]))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Example?> getExampleByNameAndWord(String name, int wordId) async {
    return (select(examples)
          ..where((tbl) => Expression.and(
              [tbl.name.equals(name), tbl.baseWord.equals(wordId)]))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Example?> getExampleByIdOrUuid(int id, {String uuid = ""}) async {
    var selectRowBy = (select(examples)
      ..where((tbl) => Expression.and([tbl.id.equals(id)]))
      ..limit(1));
    if (uuid.isNotEmpty) {
      selectRowBy = (select(examples)
        ..where((tbl) => Expression.and([tbl.uuid.equals(uuid)]))
        ..limit(1));
    }
    return selectRowBy.getSingleOrNull();
  }

  Future<Mean?> getMeanByIdOrUuid(int id, {String uuid = ""}) async {
    var selectRowBy = (select(means)
      ..where((tbl) => Expression.and([tbl.id.equals(id)]))
      ..limit(1));
    if (uuid.isNotEmpty) {
      selectRowBy = (select(means)
        ..where((tbl) => Expression.and([tbl.uuid.equals(uuid)]))
        ..limit(1));
    }
    return selectRowBy.getSingleOrNull();
  }

  Future<Language?> getLangById(int id) {
    return (select(languages)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<translatedwords?> getTranslatedWordById(int id) {
    return (select(translatedWords)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Word?> getWordByName(String name) async {
    return (select(words)
          ..where((tbl) => tbl.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<QuestionData?> getQuestionByName(String name, int quizID,
      {int wordId = 0}) async {
    return (select(question)
          ..where((tbl) => Expression.and([
                tbl.name.equals(name),
                tbl.refQuizGroup.equals(quizID),
                wordId > 0
                    ? tbl.refWord.equals(wordId)
                    : tbl.refWord.isBiggerThanValue(wordId)
              ]))
          ..limit(1))
        .getSingleOrNull();
  }


  Future<List<Word>> getWordsByNameLike(String name) async {
    return (select(words)..where((tbl) => tbl.name.contains(name))).get();
  }

  Future<Word?> getWordById(int id) async {
    return (select(words)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<QuestionData?> getQuestionById(int id) async {
    return (select(question)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> deleteWord(Word item) async {
    await (delete(synonyms)..where((tbl) => tbl.baseWord.equals(item.id))).go();
    await (delete(examples)..where((tbl) => tbl.baseWord.equals(item.id))).go();
    await (delete(leipzigDataFromIntranet)
          ..where((tbl) => tbl.baseWord.equals(item.id)))
        .go();
    await (delete(leipzigDataFromIntranet)
          ..where((tbl) => tbl.baseWord.equals(item.id)))
        .go();
    await (delete(means)..where((tbl) => tbl.baseWord.equals(item.id))).go();

    await customStatement('PRAGMA foreign_keys = OFF');

    (delete(words)..where((tbl) => tbl.id.equals(item.id))).go();
    return 0;
  }

  Future<int> deleteQuestionGroup(int id) async {
    await (delete(question)..where((tbl) => tbl.refQuizGroup.equals(id))).go();

    await customStatement('PRAGMA foreign_keys = OFF');

    (delete(quizGroup)..where((tbl) => tbl.id.equals(id))).go();
    return 0;
  }

  Future deleteSession(Session item) async {
    return (delete(sessions)..where((tbl) => tbl.id.equals(item.id))).go();
  }

  void deleteQuestion(QuestionData? item) async {
    if (item != null) {
      (delete(question)..where((tbl) => tbl.id.equals(item.id))).go();
    }
    return;
  }

  Future deleteSynonymsByWord(Word item) async {
    return (delete(synonyms)..where((tbl) => tbl.baseWord.equals(item.id)))
        .go();
  }

  Future deleteMeansByWord(Word item) async {
    return (delete(means)..where((tbl) => tbl.baseWord.equals(item.id))).go();
  }

  Future deleteExamplesByWord(Word item) async {
    return (delete(examples)..where((tbl) => tbl.baseWord.equals(item.id)))
        .go();
  }

  Future<List<Word>> getOrdersWordList() {
    return (select(words)
          ..orderBy([
            (tbl) => OrderingTerm(expression: (tbl.name)),
            // ((tbl) => OrderingTerm(expression: tbl.id))
          ]))
        .get();
  }

  Future<List<translatedwords>> getStringsToTranslate() async {
    return (select(translatedWords)
          ..where((tbl) => tbl.translatedName.equals("")))
        .get();
  }

  Future<List<Word>> getChildrenWordList(Word item) {
    return (select(words)..where((tbl) => tbl.rootWordID.equals(item.id)))
        .get();
  }

  Future<Word> updateWord(Word item, {bool skipComtrol = false}) async {
    int? versionToWrite = item.version ?? 0;
    if (!skipComtrol) {
      var oldItem = await getWordById(item.id);
      if (oldItem != null) {
        var oldVersion = oldItem.version ?? 0;
        var newVersion = item.version ?? 0;
        if (oldVersion > newVersion) {
          throw "version mismatch for word ${item.id}, old $oldVersion <>new $newVersion";
        }
      }
    }
    versionToWrite += 1;
    var toUpdate = item.copyWith(version: Value<int?>(versionToWrite));
    await update(words).replace(toUpdate);
    return toUpdate;
  }

  Future<bool> updateExample(Example item) async {
    return update(examples).replace(item);
  }

  Future<bool> updateLeipzigData(LeipzigDataFromIntranetData item) async {
    return update(leipzigDataFromIntranet).replace(item);
  }

  Future<LeipzigDataFromIntranetData?> getLeipzigDataByWord(Word item) async {
    return (select(leipzigDataFromIntranet)
          ..where((tbl) => tbl.baseWord.equals(item.id)))
        .getSingleOrNull();
  }

  Future<List<translatedwords>> getTranslatedWord(
      String inputText, int baseLangID, int targetLangID) async {
    return (select(translatedWords)
          ..where((tbl) => Expression.and([
                tbl.name.equals(inputText),
                tbl.baseLang.equals(baseLangID),
                tbl.targetLang.equals(targetLangID)
              ])))
        .get();
  }

  Future<Synonym?> getSynonymEntry(String inputText, Word basedWord) async {
    return (select(synonyms)
          ..where((tbl) => Expression.and([
                tbl.name.equals(inputText),
                tbl.baseWord.equals(basedWord.id),
              ])))
        .getSingleOrNull();
  }

  Future<List<Session>> getSessionEntryByTypeSession(String typesession) async {
    return (select(sessions)
          ..where((tbl) => Expression.and([
                tbl.typesession.equals(typesession),
                // tbl.baseWord.equals(basedWord.id),
              ])))
        .get();
  }

  Future<Session?> getSessionEntryByWord(Word item) async {
    return (select(sessions)
          ..where((tbl) => Expression.and([
                tbl.baseWord.equals(item.id),
                // tbl.baseWord.equals(basedWord.id),
              ])))
        .getSingleOrNull();
  }

  Future<bool> updateSynonym(Synonym item) async {
    return update(synonyms).replace(item);
  }

  Future<List<SessionsGroupedByName>> getGroupedSessionsByName() async {
    List<SessionsGroupedByName> result = [];
    var customQuery = customSelect(
        ''' SELECT max(s.id), Count(*) as count, s.typesession FROM sessions as s group by s.typesession 
        Order by  s.typesession DESC''',
        readsFrom: {sessions});
    var cResult = await customQuery.get();
    for (var item in cResult) {
      //print(item.data.toString());
      result.add(SessionsGroupedByName(
          typesession: item.data["typesession"], count: item.data["count"]));
    }

    return result;
  }

  Future<List<Word>> getWordsBySession(String typesession) async {
    List<Word> result = [];
    var customQuery = customSelect(
        '''SELECT sessions.id as sessionsid, sessions.typesession, words.*   from sessions 
LEFT join  words
on sessions.base_word=words.id
WHERE sessions.typesession=?
and words.id not null
ORDER by words.name  ; ''',
        readsFrom: {words}, variables: [Variable.withString(typesession)]);

    var cResult = await customQuery.get();
    for (var item in cResult) {
      //print(item.data.toString());
      try {
        result.add(words.map(item.data));
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Stream<List<Session>> getGroupedSessionsByNameStream() =>
      select(sessions).watch();

  Future<List<Deck>> getQuestions() async {
    List<Deck> result = [];
    var quizGroupLoc = await (select(quizGroup)
          ..orderBy([
            (tbl) => OrderingTerm(expression: (tbl.name)),
            // ((tbl) => OrderingTerm(expression: tbl.id))
          ]))
        .get();
    for (var itemGroup in quizGroupLoc) {
      var questions = await (select(question)
            ..where((tbl) => tbl.refQuizGroup.equals(itemGroup.id))
            ..orderBy([
              (tbl) => OrderingTerm(expression: (tbl.id)),
              // ((tbl) => OrderingTerm(expression: tbl.id))
            ]))
          .get();
      List<QuizCard> cards = [];
      for (var itemQuestion in questions) {
        cards.add(QuizCard(
            question: itemQuestion.name,
            answer: itemQuestion.answer,
            example: itemQuestion.example,
            id: itemQuestion.id));
      }
      result
          .add(Deck(deckTitle: itemGroup.name, cards: cards, id: itemGroup.id));
    }
    return result;
  }

  Future<QuestionData?> addQuestion(
      String name, String answer, String example, int refQuizGroup,
      {int refWord = 0}) async {
    var id = await into(question).insert(QuestionCompanion.insert(
        name: name,
        answer: answer,
        example: example,
        refQuizGroup: refQuizGroup));
    var result = await (select(question)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (refWord > 0) {
      var toUpdate = result?.copyWith(refWord: refWord);
      update(question).replace(toUpdate!);
      result = toUpdate;
    }
    return result;
  }

  Future<Deck?> getQuizById(int id, int baseLangID, int targetLangID) async {
    Deck result;
    var quizGroupLoc = await (select(quizGroup)
          ..where((tbl) => tbl.id.equals(id))
          ..orderBy([
            (tbl) => OrderingTerm(expression: (tbl.name)),
            // ((tbl) => OrderingTerm(expression: tbl.id))
          ]))
        .getSingleOrNull();
    if (quizGroupLoc != null) {
      var questions = await (select(question)
            ..where((tbl) => tbl.refQuizGroup.equals(quizGroupLoc.id))
            ..orderBy([
              (tbl) => OrderingTerm(expression: (tbl.id)),
              // ((tbl) => OrderingTerm(expression: tbl.id))
            ]))
          .get();
      List<QuizCard> cards = [];
      for (var itemQuestion in questions) {
        var questionTranslate = await getTranslateString(
            itemQuestion.name, baseLangID, targetLangID);
        var answerTranslate = await getTranslateString(
            itemQuestion.answer, baseLangID, targetLangID);
        var exampleTranslate = await getTranslateString(
            itemQuestion.example, baseLangID, targetLangID);
        var word = await getWordById(itemQuestion.refWord);

        cards.add(QuizCard(
            question: itemQuestion.name,
            answer: itemQuestion.answer,
            example: itemQuestion.example,
            id: itemQuestion.id,
            translatedAnswer: answerTranslate,
            translatedQuestions: questionTranslate,
            translatedExample: exampleTranslate,
            word: word));
      }
      result =
          Deck(id: quizGroupLoc.id, deckTitle: quizGroupLoc.name, cards: cards);

      return result;
    } else {
      return null;
    }
  }

  Future<String> getTranslateString(
      String input, int baseLangID, int targetLangID) async {
    String result = "";
    if (input.isEmpty) {
      return result;
    }
    var listTranslated =
        await getTranslatedWord(input, baseLangID, targetLangID);
    for (var item in listTranslated) {
      if (item.translatedName.isNotEmpty) {
        result = item.translatedName;
        break;
      }
    }
    var word = await getWordByName(input);
    if (word != null) {
      result = word.description;
    }

    return result;
  }
}

class SessionsGroupedByName {
  final String typesession;
  final int count;

  SessionsGroupedByName({required this.typesession, required this.count});

  //SessionsGroupedBysName({required this.typesession});
}
