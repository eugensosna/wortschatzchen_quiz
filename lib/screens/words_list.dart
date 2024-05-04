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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words'),
      ),
      body: getWordsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("kkk");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WordsDetail();
          }));
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
      subtitle: Text(itemWord.name),
      trailing: const Icon(
        Icons.delete,
        color: Colors.grey,
      ),
    );
  }

  void updateListWords() {
    Future<List<Word>> flistWords = db.select(db.words).get();
    flistWords.then((value) {
      setState(() {
        listWords = value;
      });
    });
  }
}
