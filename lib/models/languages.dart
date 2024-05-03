import 'package:drift/drift.dart';

part 'languages.d.dart';

class Languages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortName => text()();
  TextColumn get uuid => text()();
}
