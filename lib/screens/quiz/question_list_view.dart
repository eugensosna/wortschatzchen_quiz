import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';
import 'package:wortschatzchen_quiz/screens/quiz/add_card_view.dart';
import 'package:wortschatzchen_quiz/widgets/modal_show_questions_add.dart';

class QuestionListView extends StatefulWidget {
  final Deck deck;
  final List<QuizCard> questions;

  const QuestionListView(
      {super.key, required this.questions, required this.deck});

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              var quizUpdated =
                  await Provider.of<AppDataProvider>(context, listen: false)
                          .getQuizData(widget.deck) ??
                      widget.deck;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionsGenerator(
                            widget.deck,
                            QuizGroup: quizUpdated,
                            questionsField: "mean",
                            answerField: "name",
                          )));
            },
            style: const ButtonStyle(),
            child: const Text(
              "generate",
            ),
          ),
        ],
        title: const Text("List questions "),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _itemBuilder(context, index, widget.questions);
        },
        itemCount: widget.questions.length,
      ),
    );
  }

  Widget _itemBuilder(
      BuildContext context, int index, List<QuizCard> questions) {
    QuizCard card = questions[index];
    bool isArchive = card.archive ?? false;
    
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
      child: Dismissible(
        key: Key(card.id.toString()),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.blueGrey,
          child: const Icon(Icons.delete),
        ),
        onDismissed: (direction) {
          questions.removeAt(index);
          setState(() {});
          _delete(card, context);
        },
        child: ListTile(
          onTap: () {
            _viewQuestion(card, context);
          },
          title: Text(
            card.question,
              style: isArchive
                  ? TextStyle(fontSize: 20, decoration: TextDecoration.lineThrough)
                  : TextStyle(fontSize: 14)
            
          ),

          //  Center(
          //     child: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     card.question,
          //     style: const TextStyle(fontSize: 20),
          //   ),
          // )),
          subtitle: Text(
            card.answer,
            style: const TextStyle(fontSize: 16),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(8, 0.0, 8.0, 8.0),
          //   child: Center(
          //     child: Text(
          //       card.answer,
          //       style: TextStyle(fontSize: 16),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  void _viewQuestion(QuizCard card, BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddCardView(
                deck: widget.deck,
                quizCard: card,
                // deck: deck,
              )),
    );
    if (result != null) {
      card = result;

    }
    ;

  }

  void _delete(QuizCard card, BuildContext context) async {
    Provider.of<AppDataProvider>(context, listen: false)
        .deleteQuestion(widget.deck, card);
  }
}
