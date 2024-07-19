import 'dart:convert';

import 'package:wortschatzchen_quiz/db/db.dart';

class AutoCompliteHelper {
  final String name;
  final bool isIntern;
  final String uuid;

  AutoCompliteHelper(
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
  int orderId;
  String uuid;

  ReordableElement(
      {required this.id,
      required this.name,
      required this.translate,
      required this.orderId,
      required this.uuid});
  static ReordableElement fromJson(Map<String, dynamic> data) {
    var result = ReordableElement(
        id: data["id"],
        name: data["name"],
        translate: data["translate"],
        orderId: data["orderid"],
        uuid: data["uuid"]);
    return result;
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name.toString(),
      'translate': translate,
      'orderid': orderId,
      'uuid': uuid
    };
  }
}

class AzWords {
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

  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}
