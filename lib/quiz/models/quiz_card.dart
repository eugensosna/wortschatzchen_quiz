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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'answer': answer,
      'example': example,
      'translatedQuestions': translatedQuestions,
      'translatedAnswer': translatedAnswer,
      'translatedExample': translatedExample,
      'wordID': word != null ? word!.uuid : "",
    };
  }

  static QuizCard fromJson(Map<String, dynamic> json) {
    return QuizCard(
        question: json['question'],
        answer: json['answer'],
        id: json['id'],
        example: json['example']);
  }


}
