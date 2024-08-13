import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class AddCardView extends StatefulWidget {
  final Deck deck;
  final QuizCard? quizCard;
  const AddCardView({super.key, required this.deck, this.quizCard});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final questionTextController = TextEditingController();
  final answerTextController = TextEditingController();

  final exampleTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.quizCard != null) {
      questionTextController.text = widget.quizCard!.question;
      answerTextController.text = widget.quizCard!.answer;
      exampleTextController.text = widget.quizCard!.example;
    }
  }

  @override
  Widget build(BuildContext context) {
    Deck deck = widget.deck;
    var provider = Provider.of<AppDataProvider>(context, listen: false);
    bool isArchive = widget.quizCard?.archive ?? false;


    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        title: widget.quizCard == null
            ? const Text("Add Card")
            : const Text("View Card"),
          // backgroundColor: Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 25.0),
                    child: _questionFieldNewCardScreen(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 50.0),
                    child: _answerFieldNewCardScreen(),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 50.0),
                  child: _examplesFieldNewCardScreen(),
                ),
                Center(
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Active"),
                        selected: isArchive == false,
                        onSelected: (value) {
                          widget.quizCard?.archive = false;
                          widget.quizCard?.save(provider, widget.deck);
                          setState(() {});
                        },
                      ),
                      ChoiceChip(
                        label: const Text("Archive"),
                        selected: isArchive == true,
                        onSelected: (value) async {
                          widget.quizCard?.archive = true;
                          widget.quizCard?.save(provider, widget.deck);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),


                  _submitButton(deck)
                ],
              ),
            ),
          ],
      ),
    );
  }

// custom Widgets

  Widget _questionFieldNewCardScreen() {
    return TextField(
      controller: questionTextController,
      textAlign: TextAlign.center,
      autocorrect: true,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: const InputDecoration(
          hintText: "Question",
          label: Text(" Question"),

          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                  color: Colors.black, width: 2.0, style: BorderStyle.solid))),
    );
  }

  Widget _answerFieldNewCardScreen() {
    return TextField(
      controller: answerTextController,
      textAlign: TextAlign.center,
      autocorrect: true,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: const InputDecoration(
          hintText: "Answer",
          label: Text(" Answer"),

          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                  color: Colors.black, width: 2.0, style: BorderStyle.solid))),
    );
  }

Widget _examplesFieldNewCardScreen() {
    return TextField(
      controller: exampleTextController,
      textAlign: TextAlign.center,
      autocorrect: true,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: const InputDecoration(
          hintText: "Example",
          label: Text(" Example"),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black, width: 2.0, style: BorderStyle.solid))),
    );
  }


  Widget _submitButton(Deck currenDeck) {
    return ElevatedButton(
      // color: Colors.black,
      onPressed: () async {
        var provider = await Provider.of<AppDataProvider>(context, listen: false);
        var card = QuizCard(
            question: questionTextController.text,
            answer: answerTextController.text,
            id: 0,
            example: "");
        if (widget.quizCard == null) {
          var card = await provider.addQuizQuestion(
              questionTextController.text, answerTextController.text, currenDeck,
              example: exampleTextController.text);

          // MockDecks.addCard(
          //     questionTextController.text, answerTextController.text, deck);
          questionTextController.text = "";
          answerTextController.text = "";
        } else {
          card = await provider.updateQuestion(
              widget.quizCard!, answerTextController.text, currenDeck, questionTextController.text,
              example: exampleTextController.text);

          // .addQuizQuestion(questionTextController.text,
          // answerTextController.text, currenDeck);
        }
        Navigator.pop(context, card);
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
      // shape: OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
      // ),
      child: const Text(
        "Submit",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

// custom Widgets

// events
}
