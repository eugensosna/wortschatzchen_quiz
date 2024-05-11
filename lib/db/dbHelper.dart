import 'package:drift/src/dsl/dsl.dart';
import 'package:drift/src/runtime/data_class.dart';

import 'package:drift/src/runtime/query_builder/query_builder.dart';
import 'package:wortschatzchen_quiz/models/LeipzigWord.dart';

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

  Future<Language?> getLangById(int id) {
    return (select(languages)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<Word?> getWordByName(String name) async {
    return (select(words)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  Future<Word?> getWordById(int id) async {
    return (select(words)..where((tbl) => tbl.id.equals(id))).getSingle();
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
  
  Future<TranslatedWords?> getTranslatedWords(String inputText, int ) async {
    return (select(translatedWords)..where((tbl) => tbl.name.equals(inputText)).get
  }
      
}
