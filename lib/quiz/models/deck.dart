import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class Deck {
  final String deckTitle;
  List<QuizCard> cards = [];

  Deck({required this.deckTitle, required this.cards});
}
