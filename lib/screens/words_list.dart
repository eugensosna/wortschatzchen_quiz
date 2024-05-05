import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class WordsList extends StatefulWidget {
  const WordsList({super.key});

  @override
  State<StatefulWidget> createState() {
    return WordsListState();
  }
}

class WordsListState extends State<WordsList> {
  int count = 2;
  final db = AppDatabase();
  List<Word> listWords = [];

  @override
  void initState() {
    // TODO: implement initState
    updateListWords();
    super.initState();
  }

  Future<void> _AddNewWord() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const WordsDetail();
    }));
    if (result) {
      updateListWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words'),
      ),
      body: getWordsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _AddNewWord();
        },
        tooltip: "Add note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getWordsListView() {
    TextStyle? titleStile = Theme.of(context).textTheme.labelLarge;
    return ListView.builder(
      itemCount: listWords.length,
      itemBuilder: (context, index) {
        Word wordItem = listWords[index];
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: listWordView(wordItem),
        );
      },
    );
  }

  ListTile listWordView(Word itemWord) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.keyboard_arrow_right),
      ),
      title: Text(
        itemWord.name,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(itemWord.description),
      trailing: const Icon(
        Icons.delete,
        color: Colors.grey,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    updateListWords();
    super.didChangeDependencies();
  }

  void updateListWords() {
    Future<List<Word>> fListWords = db.select(db.words).get();
    fListWords.then((value) {
      setState(() {
        listWords = value;
      });
    });
  }
}
