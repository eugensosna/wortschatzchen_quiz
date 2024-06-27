import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/quiz/mock/mock_decks.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/add_card_view.dart';
import 'package:wortschatzchen_quiz/screens/quiz/quiz_view.dart';

class DeckEntryView extends StatelessWidget {
  final Deck deck;
  const DeckEntryView(this.deck, {super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 100.0),
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
                      "Add Card",
                      style: TextStyle(
                        fontSize: 40.0,
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
                ElevatedButton(
                    onPressed: () {}, child: const Text("Fill by sessions"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
