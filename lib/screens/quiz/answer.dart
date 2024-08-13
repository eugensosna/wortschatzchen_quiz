import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class Answer extends ChangeNotifier {
  QuizCard card;
  final AppDataProvider provider;
  final Deck quiz_group;

  UserAnswer userAnswer = UserAnswer.undecided;
  UserActions userAction = UserActions.undecided;

  Answer(this.provider, this.quiz_group, this.card);

  void correct() async {
    if (userAnswer == UserAnswer.undecided ||
        userAnswer == UserAnswer.incorrect) {
      userAnswer = UserAnswer.correct;
      card.archive = true;
      await card.save(provider, quiz_group);

      notifyListeners();
    }
  }

  void incorrect() {
    if (userAnswer == UserAnswer.undecided) {
      userAnswer = UserAnswer.incorrect;
      notifyListeners();
    }
  }

  void reset() {
    if (userAnswer != UserAnswer.undecided) {
      userAnswer = UserAnswer.undecided;
      notifyListeners();
    }
  }
}

enum UserAnswer { undecided, correct, incorrect, goBack }

enum UserActions { left, right, upper, down, undecided }
