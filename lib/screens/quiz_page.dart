import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/Questions.dart';
import 'package:wortschatzchen_quiz/quiz/mock/mock_decks.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/deck_view.dart';

class QuizPage extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const QuizPage({super.key, required this.db, required this.talker});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];
  final pageController = PageController();
  final List<Deck> decks = MockDecks.fetchDecks();


  @override
  void initState() {
    super.initState();
    _questions = sample_data
        .map(
          (question) => Question(
              id: question['id'],
              question: question['question'],
              options: question['options'],
              answer: question['answer_index']),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Decks"),
                Tab(
                  text: "New Deck",
                )
              ],
            ),
            title: Text("Quiz Cards"),
          ),
          body: TabBarView(children: <Widget>[
            DeckView(decks),
            Container(),
          ]),
        ));
    /*return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  
                  
                  itemBuilder: (context, index) {
                    var item = _questions.elementAt(index);
                    return Center(
                      child: Text(
                        item.question,
                      ),
                    );
                  },
                  controller: pageController,
                  itemCount: _questions.length,
                ),
              ),
              
            ]),
      ),
    );*/
  }
}
