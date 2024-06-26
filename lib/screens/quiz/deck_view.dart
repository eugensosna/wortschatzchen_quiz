import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/dock_entry_view.dart';

class DeckView extends StatefulWidget {
  final List<Deck> decks;

  DeckView(this.decks, {super.key});

  @override
  State<DeckView> createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: widget.decks.length,
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    Deck currentDeck = widget.decks[index];
    String deckCardCount = currentDeck.cards.length != null
        ? "${currentDeck.cards.length} cards"
        : "0 cards";
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black54)),
      ),
      child: ListTile(
        onTap: () => _navigateToSelectedDeckEntryScreen(context, currentDeck),
        title: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            currentDeck.deckTitle,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        )),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
          child: Center(
              child: Text(
            deckCardCount,
            style: const TextStyle(fontSize: 20),
          )),
        ),
      ),
    );
  }
}

_navigateToSelectedDeckEntryScreen(
    BuildContext context, Deck currentDeck) async {
  var decks = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DockEntryView(deck: currentDeck)));
}
