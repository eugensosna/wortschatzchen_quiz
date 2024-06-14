// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3;

import 'package:path/path.dart' as p;

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
}

@DataClassName('translatedwords')
class TranslatedWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseLang => integer().references(Languages, #id)();
  IntColumn get targetLang => integer().references(Languages, #id)();

  TextColumn get name => text()();
  TextColumn get translatedName => text()();
}

class Synonyms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();
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
  TextColumn get htmlOpen=> text()();
  TextColumn get htmlExamples=> text()();
  
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
@TableIndex(name: "type_session", columns: {#typesession})
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();
  TextColumn get typesession => text()();
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

])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  Talker talker = Talker();


  void setTalker(Talker talker) {
    talker = talker;
  }
  @override
  int get schemaVersion => 16;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // talker.info("start migrate");
        await transaction(() async {
          await customStatement('PRAGMA foreign_keys = OFF');
          if (from < 9) {
            await customStatement('ALTER TABLE words  ADD immportant TEXT;');
            await customStatement("""update words set immportant=' ';""");

          } else {
            if (from < 11) {
              await customStatement(
                  'ALTER TABLE means   ADD COLUMN means_order INTEGER;');
              await customStatement("""update means set meansorder=0;""");

            } else {
              if (from < 12) {
                await customStatement('''
                  CREATE TABLE "examples" (
                    "id"	INTEGER NOT NULL,
                    "uuid"	TEXT NOT NULL,
                    "base_word"	INTEGER NOT NULL,
                    "name"	TEXT NOT NULL,
                    "exampleOrder"	INTEGER,
                    "goaltext" TEXT ,
                    PRIMARY KEY("id" AUTOINCREMENT),
                    FOREIGN KEY("base_word") REFERENCES "words"("id")
                  ); ''');
              }
            }



          
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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'worts.sqlite'));

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
