import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class AppDataProvider extends ChangeNotifier {
  final AppDatabase _db = AppDatabase();
  final Talker _talker = Talker();
  AppDatabase get db => _db;
  Talker get talker => _talker;
}
