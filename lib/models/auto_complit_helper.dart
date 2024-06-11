import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class AutoComplitHelper {
  final String name;
  final bool isIntern;
  final String uuid;

  AutoComplitHelper(
      {required this.name, required this.isIntern, required this.uuid});
}

class WordListHelper {
  final int id;
  final String get;

  final String name;
  final String important;

  final String description;

  final String mean;
  final String baseForm;
  final int baseLang;
  final int rootWordID;

  WordListHelper(
      {required this.id,
      required this.get,
      required this.name,
      required this.important,
      required this.description,
      required this.mean,
      required this.baseForm,
      required this.baseLang,
      required this.rootWordID});
}

class ReordableElement {
  int id;
  String name;
  String translate;
  final int orderId;
  final String uuid;

  ReordableElement(
      {required this.id,
      required this.name,
      required this.translate,
      required this.orderId,
      required this.uuid});
  static ReordableElement map(Map<String, dynamic> data) {
    return ReordableElement(
        id: data["id"],
        name: data["name"],
        translate: data["translate"] ?? "",
        orderId: data["orderid"],
        uuid: data["uuid"]);
  }
}

class AzWords extends ISuspensionBean {
  Word word;
  String? tagIndex;

  String name;
  AzWords(this.word, this.name, this.tagIndex);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      // "id": this.word.id,
    };
  }

  @override
  String getSuspensionTag() => tagIndex!;
  @override
  String toString() => json.encode(this);
}
