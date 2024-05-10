import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';
import 'package:sqlite3/sqlite3.dart';

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
  TextColumn get description => text()();

  TextColumn get mean => text()();
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

class LeipzigData extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get baseWord => integer().references(Words, #id)();

  TextColumn get url => text()();
  TextColumn get html => text()();
  TextColumn get article => text()();
  TextColumn get KindOfWort => text()();
  TextColumn get wordOfBase => text()();
}

@DriftDatabase(
    tables: [Languages, Words, Synonyms, TranslatedWords, LeipzigData])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;
  @override
  // TODO: implement migration
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
      // m.database
      //     .into(m.database.languages)
      //     .insert(LanguagesCompanion.insert(name: "German", shortName: "de"));

      // database
      //     .into(database.languages)
      //     .insert(LanguagesCompanion.insert(name: "Ukranian", shortName: "uk"));
      },
      onUpgrade: (m, from, to) async {
        if (from < 3 && to == 3) {
          // await m.create(leipzigData);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          (await into(languages).insert(
              LanguagesCompanion.insert(name: "German", shortName: "de")));
          (await into(languages).insert(
              LanguagesCompanion.insert(name: "Ukrainian", shortName: "uk")));
        }
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
