import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/Questions.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/add_quiz_group.dart';
import 'package:wortschatzchen_quiz/screens/quiz/deck_view.dart';

class QuizPage extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const QuizPage({super.key, required this.db, required this.talker});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final pageController = PageController();
  List<Deck> decks = []; //MockDecks.fetchDecks();

  @override
  void initState() {
    super.initState();
    Provider.of<AppDataProvider>(context, listen: false).updateDecks();
    if (decks.isEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.black,
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: "Decks"),
                Tab(
                  text: "New Deck",
                )
              ],
            ),
            title: const Text("Quiz Cards"),
          ),
            body: Consumer<AppDataProvider>(
              builder: (context, value, child) => TabBarView(children: <Widget>[
            DeckView(decks),
                AddQuizGroup(),
          ]),
            )));

  }
}
