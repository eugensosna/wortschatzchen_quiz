import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:wortschatzchen_quiz/screens/image_to_text.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class WordsList extends StatefulWidget {
  final DbHelper db;

  const WordsList(this.db, {super.key});

  @override
  State<StatefulWidget> createState() {
    return WordsListState(db);
  }
}

class WordsListState extends State<WordsList> {
  int count = 2;
  final DbHelper db;

  int selectedIndex = 2;
  
  List<Word> listWords = [];

  WordsListState(this.db);
  List<Word> orderslistWords = [];

  @override
  void initState() {
    // TODO: implement initState
    updateListWords().then((value) {
      setState(() {});
      ;
    });
    super.initState();
  }

  // static List<Widget> tabBarPages = [
  //   const WordsList(),
  //   const WordsList(),
  //   const WordsList(),
  //   const WordsList(),
  //   const ImageToText(),
  // ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(wordToEdit.id);
      return WordsDetail(wordToEdit, title, db);
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
      // bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(
              const Word(
                  id: -99,
                  uuid: "",
                  name: "",
                  description: "",
                  mean: "",
                  baseForm: "",
                  baseLang: 0,
                  rootWordID: 0),
              "Add new");
        },
        tooltip: "Add note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getWordsListView() {
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
        itemWord.baseForm.isNotEmpty
            ? "${itemWord.baseForm}, ${itemWord.name}"
            : "${itemWord.name}",
        //style: const TextStyle(fontSize: 6),
      ),
      subtitle: Text("${itemWord.description} ${itemWord.mean}"),
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

  bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: "Quiz"),
        BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined), label: "Repeat"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
        BottomNavigationBarItem(icon: Icon(Icons.image_search), label: "Scan"),
      ],
    );
  }
}
