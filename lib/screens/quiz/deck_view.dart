import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/screens/quiz/add_quiz_group.dart';
import 'package:wortschatzchen_quiz/screens/quiz/deck_entry_view.dart';

class DeckView extends StatefulWidget {
  final List<Deck> decks;

  const DeckView(this.decks, {super.key});

  @override
  State<DeckView> createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
        builder: (context, AppDataProvider, child) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _itemBuilder(context, index, AppDataProvider.decks);
        },
        itemCount: AppDataProvider.decks.length,
      );
    });
  }

  Widget? _itemBuilder(BuildContext context, int index, List<Deck> decks) {
    Deck currentDeck = decks[index];
    String deckCardCount =
        currentDeck.cards.isNotEmpty
        ? "${currentDeck.cards.length} cards"
        : "0 cards";
    return Dismissible(
      key: Key(currentDeck.deckTitle),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
      ),
      onDismissed: (direction) {
        //widget.talker.debug("Dismissible delete ${wordItem.name} ");
        setState(() {
          decks.removeAt(index);
          //listWords.removeAt(index);
        });
        _delete(
          currentDeck,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black54)),
        ),
        child: GestureDetector(
          onDoubleTap: () => AddQuizGroup(
            deck: currentDeck,
          ),
          onTap: () => _navigateToSelectedDeckEntryScreen(context, currentDeck),
          child: ListTile(
      
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
        ),
      ),
    );
  }
  
  Future<void> _delete(
    Deck currentDeck,
  ) async {
    var appData = Provider.of<AppDataProvider>(context, listen: false);
    await appData.db.deleteQuestionGroup(currentDeck.id);
    appData.updateDecks();
  }
}

_navigateToSelectedDeckEntryScreen(
    BuildContext context, Deck currentDeck) async {
  var currentDeckLoc =
      await Provider.of<AppDataProvider>(context, listen: false)
              .getQuizData(currentDeck) ??
          currentDeck;
  var decks = Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeckEntryView(currentDeckLoc)));
}
