import 'package:wortschatzchen_quiz/db/db.dart';

class QuizCard {
  final int id;
  final String question;
  final String answer;
  final String example;
  String translatedQuestions;
  String translatedAnswer;
  String translatedExample;
  Word? word;
  QuizCard(
      {required this.question,
      required this.answer,
      required this.id,
      required this.example,
      this.translatedQuestions = "",
      this.translatedAnswer = "",
      this.translatedExample = "",
      this.word});
}
