import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class Deck {
  final id;
  final String deckTitle;
  List<QuizCard> cards = [];

  Deck({required this.id, required this.deckTitle, required this.cards});
}
