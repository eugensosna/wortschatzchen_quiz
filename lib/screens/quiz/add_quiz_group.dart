import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/deck_entry_view.dart';

class AddQuizGroup extends StatefulWidget {
  Deck? _deck;
  AddQuizGroup({super.key, Deck? deck}) {
    _deck = deck;
  }

  @override
  State<AddQuizGroup> createState() => _AddQuizGroupState();
}

class _AddQuizGroupState extends State<AddQuizGroup> {
  final textController = TextEditingController();

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            _infoTextNewDeckTab(),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 50.0),
              child: _textFieldNewDeckTab(),
            ),
            _submitButtonNewDeckTab()
          ],
        ),
      ),
    );
  }

  Widget _infoTextNewDeckTab() {
    return const Text(
      "What is the title of your deck?",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _textFieldNewDeckTab() {
    String textToView = widget._deck != null ? widget._deck!.deckTitle : "";
    if (textController.text.isEmpty) {
      textController.text = textToView;
    }
    return TextField(

      
      controller: textController,
      textAlign: TextAlign.center,
      autocorrect: true,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: const InputDecoration(
          hintText: "Deck Title",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                  color: Colors.black, width: 2.0, style: BorderStyle.solid))),
    );
  }

  Widget _submitButtonNewDeckTab() {
    return ElevatedButton(
      child: const Text(
        "Submit",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onPressed: () async {
        Deck deck;
        var provider = await Provider.of<AppDataProvider>(context, listen: false);
        if (widget._deck != null) {
          var db = provider.db;
          var deckdb = await db.getQuizByNameOrId("", id: widget._deck!.id);
          if (deckdb != null) {
            var toUpdate = deckdb.copyWith(name: textController.text);
            await db.update(db.quizGroup).replace(toUpdate);
          }
          deck = await provider.getQuizGroup(textController.text);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeckEntryView(
                        deck,
                      )));
        } else {
          deck = await provider.addQuizGroup(textController.text);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeckEntryView(
                        deck,
                      )));
          dispose();
        }

        // MockDecks.addDeck(textController.text);
        // List<Deck> decks = MockDecks.fetchDecks();
        // Deck deck = decks.elementAt(decks.length - 1);
        
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
      // shape: OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
      // ),
    );
  }
}
