// import 'dart:js_interop_unsafe';

import 'package:drift/drift.dart' as driftBase;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart' as Db;
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
// import 'package:wortschatzchen_quiz/quiz/mock/mock_decks.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/add_card_view.dart';
import 'package:wortschatzchen_quiz/screens/quiz/question_list_view.dart';
import 'package:wortschatzchen_quiz/screens/quiz/quiz_view.dart';
import 'package:wortschatzchen_quiz/screens/session_word_list.dart';
import 'package:wortschatzchen_quiz/widgets/drop_down_sessions_list.dart';

class DeckEntryView extends StatelessWidget {
  Deck deck;
  DeckEntryView(this.deck, {super.key}) {
    // TODO: implement DeckEntryView
  }
  List<SessionHeader> listSessions = [];
  String currentSessionName = "";

  @override
  Widget build(BuildContext context) {
    var list =
        Provider.of<AppDataProvider>(context, listen: false).sessionsByName;
    if (list.isEmpty) {
      Provider.of<AppDataProvider>(context, listen: false).updateSessions();
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // List<Deck> decks = MockDecks.fetchDecks();
              Navigator.pop(context);
            },
          ),
          // backgroundColor: Colors.black,
          title: Text(deck.deckTitle),
        ),
        body: Consumer<AppDataProvider>(
          builder: (context, value, child) {
            listSessions = value.sessionsByName
                .map(
                  (e) => SessionHeader(
                      typesession: e.typesession, description: e.typesession),
                )
                .toList();
            currentSessionName =
                listSessions.isNotEmpty ? listSessions[0].typesession : "";
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 100.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        deck.deckTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 60.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 100.0),
                        child: Text(
                          "${deck.cards.length} cards",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCardView(
                                        deck: deck,
                                      )),
                            );
                          },
                          // color: Colors.white,
                          // textColor: Colors.black,
                          // padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                          // shape: OutlineInputBorder(
                          //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          //     borderSide: BorderSide(
                          //       color: Colors.black,
                          //       width: 2.0,
                          //     )),
                          child: const Text(
                            "Add Question",
                            style: TextStyle(
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionListView(
                                        questions: deck.cards,
                                        deck: deck,
                                      )),
                            );
                          },
                          child: const Text(
                            "View Questions",
                            style: TextStyle(
                              fontSize: 35.0,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizView(
                                      deck: deck,
                                    )),
                          );
                        },
                        // style: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        // ),
                        child: const Text(
                          "Start Quiz",
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black))),
                        child: ElevatedButton(
                            onPressed: () async {
                              fillQuestions(context, currentSessionName, "name",
                                  "description");
                            },
                            child: const Text("Generate to lern")),
                      ),
                      DropDownMenuForSessions(
                        sessions: listSessions,
                        defaultValue: listSessions.isNotEmpty
                            ? listSessions[0].typesession
                            : "",
                        callBackOnChose: onChangeSession,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            fillQuestions(
                                context, currentSessionName, "mean", "name");
                          },
                          child: const Text("Generate to test"))
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void onChangedSession(String value) {}

  onChangeSession(String value) {
    currentSessionName = value;
  }

  void fillQuestions(BuildContext context, String currentSessionName,
      String questionField, String answerField) async {
    String question;
    var db = await Provider.of<AppDataProvider>(context, listen: false).db;
    var words = await Provider.of<AppDataProvider>(context, listen: false)
        .updateSessionByFilter(current: currentSessionName);
    for (var item in words) {
      question = getValueByFieldName(questionField, item).toString();
      var questiondb =
          await db.getQuestionByName(question, deck.id, wordId: item.id);
      if (questiondb != null) {
        continue;
      }

      String answer = getValueByFieldName(answerField, item).toString();
      if (question.isNotEmpty && answer.isNotEmpty) {
        deck = await Provider.of<AppDataProvider>(context, listen: false)
            .addQuizQuestion(question, answer, deck, wordID: item.id);
      }
    }
  }

  dynamic getValueByFieldName(String fieldName, Db.Word item) {
    dynamic result = "";
    var mapItem = item.toColumns(false);
    result = mapItem[fieldName];
    switch (fieldName) {
      case "mean":
        result = item.mean;
        break;
      case "important":
        result = item.important;
        break;
      case "description":
        result = item.description;
        break;
      default:
        result = item.name;
    }
    return result;
  }
}
