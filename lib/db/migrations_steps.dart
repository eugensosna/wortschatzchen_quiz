import 'package:drift/drift.dart';
import 'package:wortschatzchen_quiz/db/db_migration.dart';

class MigrationsSteps {
  static from21To22(Migrator m, Schema22 schema) async {
    await m.createTable(schema.kindsOfWords);

    await m.addColumn(schema.words, schema.words.kindOfWord);
    await m.addColumn(schema.words, schema.words.kindOfWordRef);
  }
}
