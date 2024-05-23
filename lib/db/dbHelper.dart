import 'package:drift/src/runtime/query_builder/query_builder.dart';

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

  Future<List<Synonym>> getSynonymsByWord(int wordId) {
    return (select(synonyms)..where((tbl) => tbl.baseWord.equals(wordId)))
        .get();
  }

  Future<List<Example>> getExamplesByWord(int wordId) {
    return (select(examples)..where((tbl) => tbl.baseWord.equals(wordId))).get();
  }

  Future<Example?> getExampleByNameAndWord(String name, int wordId) async {
    return (select(examples)
          ..where((tbl) => Expression.and([tbl.name.equals(name), tbl.baseWord.equals(wordId)])))
        .getSingleOrNull();
  }


  Future<Language?> getLangById(int id) {
    return (select(languages)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<Word?> getWordByName(String name) async {
    return (select(words)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
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
        .getSingle();
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
  Future<List<String>> getGroupedSessionsByName() async {
    List<String> result = [];
    var query = select(sessions);
    query
        .join([innerJoin(sessions, sessions.id.equalsExp(sessions.id), useColumns: false)]).groupBy(
            [sessions.typesession]);
    final forresult = await query.get();
    for (var item in forresult) {
      result.add(item.typesession);
      //print(item);
    }
    return result;
  }

      
}
