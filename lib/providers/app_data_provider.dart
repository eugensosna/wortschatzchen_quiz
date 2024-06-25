import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';

class AppDataProvider extends ChangeNotifier {
  final DbHelper _db;
  final Talker _talker = Talker();
  DbHelper get db => _db;
  Talker get talker => _talker;
  late LeipzigTranslator translator;
  List<SessionsGroupedByName> _sessions = [];
  List<SessionsGroupedByName> get sessionsByName => _sessions;

  AppDataProvider(this._db) {
    translator = LeipzigTranslator(db: _db);
    translator.updateLanguagesData();


    //watchers 
    db.getGroupedSessionsByNameStream().listen((sessions){
      _sessions = sessions;
      notifyListeners();
    })
  }

  Future<String> translate(String input) async {
    return await translator.translate(input);
  }

  addMeansToBase(List<String> means, Word editWord) async {
    // if (editWord.mean.isEmpty && means.isNotEmpty) {
    //   var toUpdate = editWord.copyWith(mean: means[0]);
    //   db.updateWord(toUpdate);
    //   editWord = toUpdate;
    // }
    var listOfBaseMeans = await db.getMeansByWord(editWord.id);
    // first filter list of Reordable element in list<Reordable> what in base it
    // List<Reordable> convert to list<String> to check and remove from mens
    // result means insert in the base
    var toSkip = listOfBaseMeans
        .where((e) => means.contains(e.name))
        .map((toElement) => toElement.name)
        .toList();
    means.removeWhere((e) => toSkip.contains(e));

    for (var item in means) {
      await db
          .into(db.means)
          .insert(MeansCompanion.insert(baseWord: editWord.id, name: item));
    }
    listOfBaseMeans = await db.getMeansByWord(editWord.id);
    if (editWord.mean.isEmpty && listOfBaseMeans.isNotEmpty) {
      var toUpdate = editWord.copyWith(mean: means[0]);
      db.updateWord(toUpdate);
      editWord = toUpdate;
    }

    ChangeNotifier();
  }
}
