import 'package:drift/drift.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';

import 'db.dart';

class SynonymsEntry {
  Word word;
  List<SynonymsCompanion> synonymsItems;
  SynonymsEntry(this.word, this.synonymsItems);
}

class DbHelper extends AppDatabase {
  Future<Language?> getLangByShortName(String name) async {
    return (select(languages)..where((tbl) => tbl.shortName.equals(name)))
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
        select synonyms.id as id,Max(synonyms.uuid) as uuid, Max( translated_words.translated_name) as translate, Max(synonyms.name) as name, max(synonyms.id) as orderid from synonyms


        left JOIN translated_words
        on  translated_words.name = synonyms.name
        WHERE synonyms.base_word = ?
        GROUP BY synonyms.id 
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

  Future<Mean?> getMeanByNameAndWord(String name, int wordId) async {
    return (select(means)
          ..where((tbl) => Expression.and(
              [tbl.name.equals(name), tbl.baseWord.equals(wordId)])))
        .getSingleOrNull();
  }
  Future<Example?> getExampleByNameAndWord(String name, int wordId) async {
    return (select(examples)
          ..where((tbl) => Expression.and(
              [tbl.name.equals(name), tbl.baseWord.equals(wordId)])))
        .getSingleOrNull();
  }
  Future<Example?> getExampleByIdOrUuid(int id, {String uuid = ""}) async {
    var selectRowBy =
        (select(examples)..where((tbl) => Expression.and([tbl.id.equals(id)])));
    if (uuid.isNotEmpty) {
      selectRowBy = (select(examples)
        ..where((tbl) => Expression.and([tbl.uuid.equals(uuid)])));
    }
    return selectRowBy.getSingleOrNull();
  }


  Future<Language?> getLangById(int id) {
    return (select(languages)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<Word?> getWordByName(String name) async {
    return (select(words)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }
  
  Future<List<Word>> getWordsByNameLike(String name) async {
    return (select(words)..where((tbl) => tbl.name.contains(name))).get();
  }

  Future<Word?> getWordById(int id) async {
    return (select(words)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future deleteWord(Word item) async {
    return (delete(words)..where((tbl) => tbl.id.equals(item.id))).go();
  }

  Future deleteSynonymsByWord(Word item) async {
    return (delete(synonyms)..where((tbl) => tbl.baseWord.equals(item.id)))
        .go();
  }
  Future deleteMeansByWord(Word item) async {
    return (delete(means)..where((tbl) => tbl.baseWord.equals(item.id))).go();
  }

  Future<List<Word>> getOrdersWordList() {
    return (select(words)
          ..orderBy([
            (tbl) => OrderingTerm(expression: (tbl.rootWordID)),
            ((tbl) => OrderingTerm(expression: tbl.id))
          ]))
        .get();
  }

  Future<List<Word>> getChildrenWordList(Word item) {
    return (select(words)..where((tbl) => tbl.rootWordID.equals(item.id)))
        .get();
  }

  Future<bool> updateWord(Word item) async {
    return update(words).replace(item);
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

  Future<translatedwords?> getTranslatedWord(
      String inputText, int baseLangID, int targetLangID) async {
    return (select(translatedWords)
          ..where((tbl) => Expression.and([
                tbl.name.equals(inputText),
                tbl.baseLang.equals(baseLangID),
                tbl.targetLang.equals(targetLangID)
              ])))
        .getSingleOrNull();
  }

  Future<Synonym?> getSynonymEntry(String inputText, Word basedWord) async {
    return (select(synonyms)
          ..where((tbl) => Expression.and([
                tbl.name.equals(inputText),
                tbl.baseWord.equals(basedWord.id),
              ])))
        .getSingleOrNull();
  }

  Future<bool> updateSynonym(Synonym item) async {
    return update(synonyms).replace(item);
  }

  Future<List<SessionsGroupedByName>> getGroupedSessionsByName() async {
    List<SessionsGroupedByName> result = [];
    var customQuery = customSelect(
        ' SELECT max(s.id), Count(*) as count, s.typesession FROM sessions as s group by s.typesession ',
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
ORDER by typesession DESC; ''',
        readsFrom: {words}, variables: [Variable.withString(typesession)]);
    var cResult = await customQuery.get();
    for (var item in cResult) {
      //print(item.data.toString());
      result.add(words.map(item.data));
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
