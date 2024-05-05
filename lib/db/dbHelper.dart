import 'dart:js_interop';

import 'package:drift/src/dsl/dsl.dart';

import 'package:drift/src/runtime/query_builder/query_builder.dart';

import 'db.dart';

class DbHelper extends AppDatabase {
  Future<Language?> getLangByShortName(String name) async {
    return (select(languages)..where((tbl) => tbl.shortName.equals(name)))
        .getSingleOrNull();
  }

  Future<Language?> getLangById(int id) {
    return (select(languages)..where((tbl) => tbl.id.equals(id))).getSingle();
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
