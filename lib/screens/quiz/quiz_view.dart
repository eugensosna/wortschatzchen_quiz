import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
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
      // backgroundColor: const Color.fromARGB(255, 15, 15, 14),
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
                  Text(
                    "Quiz name ${deck.deckTitle}",
                    style: const TextStyle(fontSize: 30),
                  ),
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
    var provider = Provider.of<AppDataProvider>(context, listen: false);
    int currentCardIndex = 0;
    List<ActiveQuizCard> newCardDeck = [];
    for (QuizCard card in cards) {
      if (currentCardIndex <= activeCardIndex) {
        var userAnswer = Answer(provider, widget.deck, card);
        var x = ActiveQuizCard(
          card: card,
          answer: userAnswer,
          isDraggable: currentCardIndex++ == activeCardIndex ? true : false,
          onSlideOutComplete: _onSlideOutComplete,
          onSlideSwiped: _onSlideSwaped,
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
    var provider = Provider.of<AppDataProvider>(context, listen: false);

    var userAnswer = Answer(provider, widget.deck, widget.deck.cards[activeCardIndex]);

    return ElevatedButton(
      onPressed: () {
        if (newCardDeck.isNotEmpty) {
          userAnswer = newCardDeck[0].answer;
        }
        userAnswer.card = widget.deck.cards[activeCardIndex];
        buttonText == "Correct" ? userAnswer.correct() : userAnswer.incorrect();
        _onSlideOutComplete(userAnswer.userAnswer);
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

  _onSlideOutComplete(UserAnswer userAnswer) {
    var addition = -1;
    switch (userAnswer) {
      case UserAnswer.goBack:
        addition = 1;
        break;
      default:
        addition = -1;
    }

    setState(() {
      activeCardIndex = activeCardIndex + addition;
    });
  }

  _onSlideSwaped(UserActions status) {
    var addition = -1;
    switch (status) {
      case UserActions.left:
        addition = 2; //current swiped
        break;
      case UserActions.right:
        addition = -1;
        break;
      default:
        addition = 0;
    }
    activeCardIndex = activeCardIndex + addition;
    if (activeCardIndex > widget.deck.cards.length) {
      activeCardIndex = widget.deck.cards.length;
    }

    setState(() {
      activeCardIndex = activeCardIndex;
    });
  }
}
