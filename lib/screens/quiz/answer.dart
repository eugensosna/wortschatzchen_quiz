import 'package:flutter/material.dart';

class Answer extends ChangeNotifier {
  UserAnswer userAnswer = UserAnswer.undecided;
  UserActions userAction = UserActions.undecided;

  void correct() {
    if (userAnswer == UserAnswer.undecided ||
        userAnswer == UserAnswer.incorrect) {
      userAnswer = UserAnswer.correct;
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
