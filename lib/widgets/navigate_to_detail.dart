import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

void navigateToDetail(BuildContext context, Word? wordToEdit, String? title,
    {String name = "", Function? onCallBack}) async {
  final db = Provider.of<AppDataProvider>(context, listen: false).db;
  final talker = Provider.of<AppDataProvider>(context, listen: false).talker;
  var wordLocal = wordToEdit ??
      Word(
          id: -99,
          uuid: "",
          name: name,
          description: "",
          important: "",
          mean: "",
          baseForm: "",
          baseLang: 0,
          rootWordID: 0);

  final Word result =
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return WordsDetail(wordLocal, title ?? "", db, talker: talker);
  }));
  if (onCallBack != null) {
    onCallBack();
  }
}
