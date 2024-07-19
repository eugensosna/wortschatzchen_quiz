import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class Deck {
  final id;
  final String deckTitle;
  List<QuizCard> cards = [];

  Deck({required this.id, required this.deckTitle, required this.cards});


  static Deck fromJson(Map<String, dynamic> json) {
    return Deck(
        id: json['id'],
        deckTitle: json['deckTitle'],
        cards: json['cards'].map((e) => QuizCard.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'deckTitle': deckTitle,
      'cards': cards
          .map(
            (e) => e.toJson(),
          )
          .toList()
    };
  }

  void save(AppDataProvider provider) {}
}
