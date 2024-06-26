import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/quiz/mock/mock_decks.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';

class AddCardView extends StatefulWidget {
  final Deck deck;
  const AddCardView({super.key, required this.deck});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final questionTextController = new TextEditingController();
  final answerTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Deck deck = widget.deck;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Add Card"),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 25.0),
                    child: _questionFieldNewCardScreen(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 50.0),
                    child: _answerFieldNewCardScreen(),
                  ),
                  _submitButton(deck)
                ],
              ),
            ),
          ],
        ));
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                  color: Colors.black, width: 2.0, style: BorderStyle.solid))),
    );
  }

  Widget _submitButton(Deck deck) {
    return ElevatedButton(
      // color: Colors.black,
      onPressed: () {
        MockDecks.addCard(
            questionTextController.text, answerTextController.text, deck);
        questionTextController.text = "";
        answerTextController.text = "";
        Navigator.pop(context);
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
