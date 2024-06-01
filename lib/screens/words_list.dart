import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class WordsList extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const WordsList(this.db, {super.key, required this.talker});

  @override
  State<StatefulWidget> createState() => WordsListState(db);
}

class WordsListState extends State<WordsList> {
  int count = 2;
  final DbHelper db;
  bool isLoad = false;
  List<AutocompleteDataHelper> autoComplitData = [
    AutocompleteDataHelper(name: "test", isIntern: true, uuid: "uuid"),
  ];
  TextEditingController autocompleteController = TextEditingController();

  int selectedIndex = 2;

  List<Word> listWords = [];

  WordsListState(this.db);
  List<Word> ordersListWords = [];

  @override
  void initState() {
    // TODO: implement initState
    updateListWords().then((value) {
      setState(() {
        isLoad = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Words')),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Autocomplete<AutocompleteDataHelper>(
                  optionsBuilder: (textEditingValue) async {
                    final textToTest = textEditingValue.text.trim();
                    if (textToTest.isEmpty || textToTest.length <= 3) {
                      return const Iterable<AutocompleteDataHelper>.empty();
                    }

                    var leipzig = LeipzigWord(textToTest, db);
                    autoComplitData =
                        await leipzig.getAutocompleteLocal(textToTest);
                    autoComplitData.insert(
                        0,
                        AutocompleteDataHelper(
                            name: textToTest, isIntern: false, uuid: ""));
                    var autoComplitDataExt =
                        await leipzig.getAutocomplete(textToTest);
                    autoComplitData.addAll(autoComplitDataExt);
                    return autoComplitData;
                  },
                  onSelected: (AutocompleteDataHelper item) {
                    debugPrint(item.name);
                    if (item.isIntern) {
                      // navigateToDetail(wordItem, "View ${wordItem.name}");
                    } else {
                      navigateToDetail(
                          Word(
                              id: -99,
                              uuid: "uuid",
                              name: item.name,
                              important: "",
                              description: "",
                              mean: "",
                              baseForm: "",
                              baseLang: 0,
                              rootWordID: 0),
                          "Add ${item.name}");
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                      autofocus: true,
                      focusNode: focusNode,
                      controller: textEditingController,
                      onFieldSubmitted: (value) {
                        onFieldSubmitted();
                      },
                      decoration: InputDecoration(hoverColor: Colors.black38),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    color: Colors.green.shade100,
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: getWordsListView()),
                  ),
                )
              ],
            ),

      // bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget autoComplite() {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<AutocompleteDataHelper>.empty();
        } else {
          if (autoComplitData.isNotEmpty) {
            return autoComplitData;
          }
          return autoComplitData;
        }
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 2,
          child: ListView.separated(
              itemBuilder: (context, index) {
                var autoItem = options.elementAt(index);
                return ListTile(
                  title: Text(autoItem.name),
                  onTap: () {
                    widget.talker.debug("on tap ${autoItem.name}");
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: options.length),
        );
      },
    );
  }

  ListView getWordsListView() {
    return ListView.builder(
        itemCount: listWords.length,
        itemBuilder: (context, index) {
          Word wordItem = listWords[index];
          if (wordItem.rootWordID > 0) {}
          return GestureDetector(
            onDoubleTap: () {
              print(wordItem.name);
              widget.talker.debug("doubletape edit ${wordItem.name}");
              navigateToDetail(wordItem, "View ${wordItem.name}");
            },
            child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: Key(wordItem.uuid),
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
                    widget.talker.debug("Dismissible delete ${wordItem.name} ");
                    _delete(wordItem).then(
                      (value) {
                        setState(() {});
                      },
                    );
                  },
                  child: listWordView(wordItem),
                )),
          );
        }

        //   Card(
        //     color: Colors.white,
        //     elevation: 2.0,
        //     child: listWordView(wordItem),
        //   );
        // },
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
            : itemWord.name,
        //style: const TextStyle(fontSize: 6),
      ),
      subtitle: Text("${itemWord.description} ${itemWord.mean}"),
      onTap: () {
        debugPrint("lit Tap");
      },
    );
  }

  @override
  void didChangeDependencies() {
    updateListWords();
    super.didChangeDependencies();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, db);
    }));
    if (result) {
      
      autocompleteController.clear();
      updateListWords().then((onValue) {
        listWords = onValue;
        setState(() {
          isLoad = false;
        });
      });
    }
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
      // ignore: unused_local_variable
      var newTreeOrder = await getRecursiveWordTree(treeOrder, ids, item);
    }

    return treeOrder;
  }

  Future<List<Word>> updateListWords() async {
    setState(() {
      isLoad = true;
    });
    widget.talker.info("start get wordList");
    Future<List<Word>> fListWords =
        db.getOrdersWordList(); //db.select(db.words).get();
    fListWords.then((value) async {
      listWords = value;
      setState(() {
        listWords = value;
        isLoad = false;
      });
      widget.talker.info("end get wordList");
      return ordersListWords;
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

  Future<int> _delete(Word itemWord) async {
    db.deleteWord(itemWord).then((value) {
      updateListWords();
    });
    return 0;
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

  void addNewWord() {
    db.getGroupedSessionsByName().then((onValue) {});
    navigateToDetail(
        const Word(
            id: -99,
            uuid: "",
            name: "",
            description: "",
            important: "",
            mean: "",
            baseForm: "",
            baseLang: 0,
            rootWordID: 0),
        "Add new");
  }
}
