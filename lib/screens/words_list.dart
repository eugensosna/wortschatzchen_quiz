import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
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
  final db = DbHelper();
  List<Word> listWords = [];

  List<Word> orderslistWords = [];

  @override
  void initState() {
    // TODO: implement initState
    updateListWords().then((value) {
      return;
    });
    super.initState();
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(wordToEdit.id);
      return WordsDetail(wordToEdit, title);
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
          navigateToDetail(
              const Word(
                  id: -99,
                  uuid: "",
                  name: "",
                  description: "",
                  mean: "",
                  baseLang: 0,
                  rootWordID: 0),
              "Add new");
        },
        tooltip: "Add note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getWordsListView() async {
    return ListView.builder(
      itemCount: listWords.length,
      itemBuilder: (context, index) {
        Word wordItem = listWords[index];
        if (wordItem.rootWordID > 0) {}
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
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundColor: getKeyboardColor(itemWord),
        child: const Icon(Icons.keyboard_arrow_right),

      ),
      
      
      title: Text(
        itemWord.name,
        //style: const TextStyle(fontSize: 6),
      ),
      subtitle: Text(itemWord.description),
      trailing: GestureDetector(
        child: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onTap: () {
          _delete(itemWord);
        },
      ),

      onTap: () {
        debugPrint("lit Tap");
        navigateToDetail(itemWord, "View ${itemWord.name}");
      },
      
    );
  }

  @override
  void didChangeDependencies() {
    updateListWords();
    super.didChangeDependencies();
  }

  Future<List<Word>> getRecursiveWordTree(
      List<Word> treeOrder, List<int> ids, Word root) async {
    if (ids.contains(root.id)) {
      return treeOrder;
    }
    treeOrder.add(root);
    ids.add(root.id);

    List<Word> childs = await db.getChildrenWordList(root);
    for (var item in childs) {
      var newtreeOrder = await getRecursiveWordTree(treeOrder, ids, item);
    }

    return treeOrder;
  }

  Future<List<Word>> updateListWords() async {
    Future<List<Word>> fListWords =
        db.getOrdersWordList(); //db.select(db.words).get();
    fListWords.then((value) async {
      // List<int> idsin = [];
      // for (var item in value) {
      //   orderslistWords =
      //       await getRecursiveWordTree(orderslistWords, idsin, item);
      // }
      listWords = value;
      setState(() {
        listWords = value;
      });
      return orderslistWords;
    });
    return listWords;
  }

  Color getKeyboardColor(Word word) {
    if (word.rootWordID > 0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _delete(Word itemWord) async {
    DbHelper().deleteWord(itemWord).then((value) {
      updateListWords();
    });
  }
}
