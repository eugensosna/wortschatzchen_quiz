import 'package:drift/src/dsl/dsl.dart';

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

  void getDefauiltBaseLang() {
    select(languages)
      ..where((tbl) => tbl.shortName.equals("de"))
      ..get().then((value) {
        print("object");
        print(value);
      });
  }
}
