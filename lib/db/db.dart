// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/internal/versioned_schema.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3;

import 'package:path/path.dart' as p;
import 'package:wortschatzchen_quiz/db/db_migration.dart';

part 'db.g.dart';

class Languages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortName => text().withLength(min: 2, max: 15)();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
}

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  TextColumn get name => text()();
  TextColumn get important => text()();

  TextColumn get description => text()();

  TextColumn get mean => text()();
  TextColumn get baseForm => text()();
  IntColumn get baseLang => integer().references(Languages, #id)();
  IntColumn get rootWordID => integer()();
  IntColumn get version => integer().nullable().clientDefault(() => 0)();
  TextColumn get kindOfWord => text().nullable()();
  IntColumn get kindOfWordRef => integer().nullable().references(KindsOfWords, #id)();
}

@DataClassName('translatedwords')
class TranslatedWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  @ReferenceName("baselangRefs")
  IntColumn get baseLang => integer().references(Languages, #id)();
  @ReferenceName("targetlangRefs")
  IntColumn get targetLang => integer().references(Languages, #id)();

  TextColumn get name => text()();
  TextColumn get translatedName => text()();
}

class Synonyms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  @ReferenceName("synonym_base_word_ref")
  IntColumn get baseWord => integer().references(Words, #id)();
  @ReferenceName("synonym_word_ref")
  IntColumn get synonymWord => integer().references(Words, #id)();
  TextColumn get name => text()();
  IntColumn get baseLang => integer().references(Languages, #id)();
  TextColumn get translatedName => text()();
}

class LeipzigDataFromIntranet extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();

  TextColumn get url => text()();
  TextColumn get html => text()();
  TextColumn get htmlOpen => text().nullable()();
  TextColumn get htmlExamples => text().nullable()();

  TextColumn get article => text()();
  // ignore: non_constant_identifier_names
  TextColumn get KindOfWort => text()();
  TextColumn get wordOfBase => text()();
}

class Means extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();
  TextColumn get name => text()();
  IntColumn get meansOrder => integer().clientDefault(() => 0)();
}

class Examples extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();
  TextColumn get name => text()();
  TextColumn get goaltext => text().clientDefault(() => " ")();
  IntColumn get exampleOrder => integer().clientDefault(() => 100)();
}

class QuizGroup extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
}

class Question extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn get answer => text()();
  TextColumn get example => text()();
  IntColumn get refWord => integer()
      .clientDefault(
        () => 0,
      )
      .references(Words, #id)();
  IntColumn get refQuizGroup => integer().references(QuizGroup, #id)();
  BoolColumn get archive => boolean().nullable()();
}

@TableIndex(name: "type_session", columns: {#typesession})
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();
  TextColumn get typesession => text()();
}
class KindsOfWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn get name => text()();
}

@DriftDatabase(tables: [
  Languages,
  Words,
  Synonyms,
  TranslatedWords,
  LeipzigDataFromIntranet,
  Means,
  Sessions,
  Examples,
  QuizGroup,
  Question,
  KindsOfWords
])
class AppDatabase extends _$AppDatabase {
  String pathToFile = "";
  AppDatabase({this.pathToFile = ""}) : super(_openConnection(pathToFile));
  Talker talker = Talker();

  Future<String> getDataFilePath() async {
    if (pathToFile.isNotEmpty) {
      return pathToFile;
    }
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'worts.sqlite'));
    pathToFile = file.path;
    return file.path;
  }

  void setTalker(Talker talker) {
    talker = talker;
  }

  @override
  int get schemaVersion => 22;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {

        await customStatement('PRAGMA foreign_keys = OFF');
        if (to <= 22 && from == 20) {
          await m.addColumn(question, question.archive);
        }
        await transaction(() => VersionedSchema.runMigrationSteps(
            migrator: m,
            from: from,
            to: to,
            steps: migrationSteps(from21To22: (Migrator m, Schema22 schema) async {
              // await m.addColumn(schema.question, schema.question.archive);
              await m.createTable(schema.kindsOfWords);

              await m.addColumn(schema.words, schema.words.kindOfWord);
              await m.addColumn(schema.words, schema.words.kindOfWordRef);
            })));

        

        if (to == 19) {
          await m.database.customStatement(
              """ ALTER TABLE "question" ADD COLUMN "ref_word" INTEGER NOT NULL DEFAULT 0""");
          // await m.addColumn(question, question.refWord);
          //await m.createTable(quizGroup);
          //await m.createTable(question);
        }
        if (to == 20) {
          // await m.database.customStatement(
          //     """ ALTER TABLE "words" ADD COLUMN "version" INTEGER NOT NULL DEFAULT 0""");
          await m.addColumn(words, words.version);
          // await m.createTable(quizGroup);
          // await m.createTable(question);
        }
        // talker.info("start migrate");
        if (to == 18) {
          await m.createTable(quizGroup);
          // await m.createTable(question);
          await m.createTable(question);
          // await m.addColumn(
          //     leipzigDataFromIntranet, leipzigDataFromIntranet.htmlExamples);
          // await m.addColumn(
          //     leipzigDataFromIntranet, leipzigDataFromIntranet.htmlOpen);
        }

        await transaction(() async {
          await customStatement('PRAGMA foreign_keys = OFF');

          if (to == 18) {
            await m.createTable(quizGroup);
            await m.createTable(question);
            await m.addColumn(
                leipzigDataFromIntranet, leipzigDataFromIntranet.htmlExamples);
            await m.addColumn(
                leipzigDataFromIntranet, leipzigDataFromIntranet.htmlOpen);
          }
          if (from <= 14) {
            await customStatement(
                'ALTER TABLE words RENAME COLUMN immportant TO important;');
          }
          if (from <= 15 && to == 16) {
//            await customStatement(
//                'ALTER TABLE examples RENAME COLUMN exampleOrder TO example_order;');
          }

          // put your migration logic here
          //await customStatement('PRAGMA foreign_keys = ON');
        });
        if (from < 3 && to == 3) {
          // await m.create(leipzigData);
        }
        if (from < 5) {
          await m.createTable(means);
          await m.addColumn(words, words.baseForm);
          // await m.create(leipzigData);
        }
        if (from < 6) {
          m.createTable(sessions);
          m.createIndex(typeSession);
        }
        if (from < 11) {
          await customStatement(
              'ALTER TABLE means   ADD COLUMN means_order INTEGER;');
          await customStatement("""update means set means_order=0;""");
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = OFF');
        // talker.info("start before open");
        if (details.wasCreated) {
          (await into(languages).insert(
              LanguagesCompanion.insert(name: "German", shortName: "de")));
          (await into(languages).insert(
              LanguagesCompanion.insert(name: "Ukrainian", shortName: "uk")));
        }

        if (details.hadUpgrade && details.versionBefore! < 10) {}
      },
    );

    // super.migration();
  }
}

LazyDatabase _openConnection(String pathToFile) {
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.

    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(pathToFile.isNotEmpty
        ? pathToFile
        : p.join(dbFolder.path, 'worts.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cacheBase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
