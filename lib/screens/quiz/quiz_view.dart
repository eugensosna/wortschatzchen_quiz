import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';
import 'package:wortschatzchen_quiz/screens/quiz/activ_quiz_card.dart';
import 'package:wortschatzchen_quiz/screens/quiz/answer.dart';

class QuizView extends StatefulWidget {
  final Deck deck;
  const QuizView({super.key, required this.deck});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int activeCardIndex = 0;
  List<ActiveQuizCard> newCardDeck = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeCardIndex = widget.deck.cards.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    Deck deck = widget.deck;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(deck.deckTitle),
        centerTitle: true,
        backgroundColor: Colors.amber[900],
      ),
      backgroundColor: Colors.amber[700],
      body: Center(
        child: activeCardIndex == -1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'You are all caught up',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 30.0,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        // color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // ),
                        // padding: EdgeInsets.symmetric(
                        //     vertical: 10.0, horizontal: 30.0),
                        child: const Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20.0),
                    child: _renderCards(),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _renderFlatButton("Incorrect"),
                          _renderFlatButton("Correct")
                        ],
                      )),
                ],
              ),
      ),
    );
  }

  _cardDeck(List<QuizCard> cards) {
    print("deck");
    int currentCardIndex = 0;
    List<ActiveQuizCard> newCardDeck = [];
    for (QuizCard card in cards) {
      if (currentCardIndex <= activeCardIndex) {
        var userAnswer = Answer();
        var x = ActiveQuizCard(
          card: card,
          answer: userAnswer,
          isDraggable: currentCardIndex++ == activeCardIndex ? true : false,
          onSlideOutComplete: _onSlideOutComplete,
        );
        newCardDeck.add(x);
      }
    }
    return newCardDeck.toList();
  }

  _renderCards() {
    return widget.deck.cards.isNotEmpty
        ? Stack(
            alignment: Alignment.center,
            children: _cardDeck(widget.deck.cards),
          )
        : const Text(
            "You are all caught up.",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.red,
            ),
          );
  }

  _renderFlatButton(String buttonText) {
    var userAnswer = Answer();

    return ElevatedButton(
      onPressed: () {
        if (newCardDeck.isNotEmpty) {
          userAnswer = newCardDeck[0].answer;
        }
        buttonText == "Correct" ? userAnswer.correct() : userAnswer.incorrect();
        _onSlideOutComplete();
      },
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //     side: BorderSide(
      //       color: Colors.white,
      //       style: BorderStyle.solid,
      //       width: 2,
      //     )),
      // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      // color: buttonText == "Correct" ? Colors.green[800] : Colors.red[800],
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 20.0,
          // color: Colors.white,
        ),
      ),
    );
  }

  _onSlideOutComplete() {
    setState(() {
      activeCardIndex = activeCardIndex - 1;
    });
  }
}
