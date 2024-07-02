import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/screens/quiz/deck_entry_view.dart';

class AddQuizGroup extends StatefulWidget {
  const AddQuizGroup({super.key});

  @override
  State<AddQuizGroup> createState() => _AddQuizGroupState();
}

class _AddQuizGroupState extends State<AddQuizGroup> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        var deck = await Provider.of<AppDataProvider>(context, listen: false)
            .addQuizGroup(textController.text);
        // MockDecks.addDeck(textController.text);
        textController.text = "";
        // List<Deck> decks = MockDecks.fetchDecks();
        // Deck deck = decks.elementAt(decks.length - 1);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeckEntryView(
                      deck,
                    )));
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
      // shape: OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
      // ),
    );
  }
}
