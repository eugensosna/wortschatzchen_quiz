import 'package:drift/drift.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';

class QuizCard {
  int id;
  String question;
  String answer;
  String example;
  String translatedQuestions;
  String translatedAnswer;
  String translatedExample;
  Word? word;
  bool? archive;
  QuizCard(
      {required this.question,
      required this.answer,
      required this.id,
      required this.example,
      this.translatedQuestions = "",
      this.translatedAnswer = "",
      this.translatedExample = "",
      this.word,
      this.archive = false});

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
      "archive": archive ?? false
    };
  }

  static QuizCard fromJson(Map<String, dynamic> json) {
    bool isArchive = json.containsKey('archive') ? json['archive'] : false;
    
    return QuizCard(
        question: json['question'],
        answer: json['answer'],
        id: json['id'],
        example: json['example'],
        archive: isArchive);
  }
  Future<void> save(AppDataProvider provider, Deck quiz_group) async {
    var db = provider.db;
    QuestionData? row;
    row = await db.getQuestionByName(
      question,
      quiz_group.id,
    );
    if (row == null) {
      var idLocal = await db.into(db.question).insert(QuestionCompanion.insert(
          name: question,
          answer: answer,
          example: example,
          refQuizGroup: quiz_group.id,
          archive: Value(archive)));
      row = await db.getQuestionByIdOrUuid(idLocal);
      id = idLocal;
    }
    if (row != null) {
      var toUpdate = row.copyWith(
          name: question,
          answer: answer,
          example: example,
          refWord: word != null ? word!.id : 0,
          refQuizGroup: quiz_group.id,
          archive: Value(archive));
      await db.update(db.question).replace(toUpdate);
    } else {
      Exception("can't found $question id $id");
    }
  }


}
