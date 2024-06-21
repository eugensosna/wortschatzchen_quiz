import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class WordsList extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const WordsList(this.db, {super.key, required this.talker});

  @override
  State<StatefulWidget> createState() => WordsListState();
}

class WordsListState extends State<WordsList> {
  int count = 2;
  bool stateAutocomplit = false;
  bool isLoad = false;
  List<AutocompleteDataHelper> autoComplitData = [];
  TextEditingController autocompleteController = TextEditingController();

  int selectedIndex = 2;

  List<Word> listWords = [];
  List<AzWords> listAzWords = [];
  List<Word> orderedListWords = [];
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    updateListWords().then((value) {
      setState(() {
        isLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Words')),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 40,
                //   child: Container(
                //     decoration: BoxDecoration(color: Colors.blue),
                //   ),
                // ),
                autoCompliteWidget(),
                Expanded(
                  child: Container(
                    color: Colors.green.shade100,
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        // child: getAzWordListView()),
                        child: getWordsListView()),
                  ),
                )
              ],
            ),

      // bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );
  }

  Container autoCompliteWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 8.2),
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.redAccent)),
      child: Autocomplete<AutocompleteDataHelper>(
        optionsBuilder: (textEditingValue) async {
          final textToTest = textEditingValue.text.trim();
          if (textToTest.isEmpty || textToTest.length <= 1) {
            return const Iterable<AutocompleteDataHelper>.empty();
          }

          var leipzig = LeipzigWord(textToTest, widget.db, widget.talker);
          var autoComplitDataLoc =
              await leipzig.getAutocompleteLocal(textToTest);

          var autoComplitDataExt = await leipzig.getAutocomplete(textToTest);
          var autoComplitDataVerb =
              await leipzig.getAutocompleteVerbForm(textToTest);

          autoComplitDataLoc.addAll(autoComplitDataExt);
          autoComplitDataLoc.addAll(autoComplitDataVerb);
          if (autoComplitDataLoc.isEmpty) {
            autoComplitDataLoc = autoComplitData;
            autoComplitDataLoc.insert(
                0,
                AutocompleteDataHelper(
                    name: textToTest, isIntern: false, uuid: ""));
          } else {
            autoComplitData = autoComplitDataLoc;
            autoComplitDataLoc.insert(
                0,
                AutocompleteDataHelper(
                    name: textToTest, isIntern: false, uuid: ""));
          }
          return autoComplitDataLoc;
        },
        onSelected: (AutocompleteDataHelper item) async {
          // widget.talker.debug("onSelected ${item.name}");
          stateAutocomplit = true;
          debugPrint(item.name);
          if (item.isIntern) {
            Word? wordItem = await widget.db.getWordByName(item.name);
            if (wordItem != null) {
              navigateToDetail(wordItem, "View");
            }
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
          item.name = "";
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          // widget.talker.debug(
          //     "fieldViewBuilder ${textEditingController.text}:$stateAutocomplit");
          if (stateAutocomplit) {
            textEditingController.text = "";
            stateAutocomplit = false;
            // textEditingController.value = AutocompleteDataHelper(
            //     name: "", isIntern: false, uuid: "") as TextEditingValue;
          }
          return TextFormField(
            autofocus: true,
            focusNode: focusNode,
            controller: textEditingController,
            onFieldSubmitted: (value) {
              onFieldSubmitted();
            },
            decoration: const InputDecoration(hoverColor: Colors.black38),
          );
        },
      ),
    );
  }

  Widget getAzWordListView() {
    return AzListView(
      data: listAzWords,
      itemCount: listAzWords.length,
      itemBuilder: (BuildContext context, int index) {
        Word wordItem = listAzWords[index].word;
        return listItemWidget(wordItem);
      },
      physics: const BouncingScrollPhysics(),
      indexBarData: SuspensionUtil.getTagIndexList(listAzWords),
      indexBarMargin: const EdgeInsets.all(15),
      indexBarItemHeight: 30,
      indexBarWidth: 25,
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        decoration: getIndexBarDecoration(Colors.grey[50]!),
        downDecoration: getIndexBarDecoration(Colors.grey[200]!),
      ),
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  ScrollablePositionedList getWordsListView() {
    return ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: listWords.length,
        itemBuilder: (context, index) {
          Word wordItem = listWords[index];
          if (wordItem.rootWordID > 0) {}
          return listItemWidget(wordItem);
        }

        //   Card(
        //     color: Colors.white,
        //     elevation: 2.0,
        //     child: listWordView(wordItem),
        //   );
        // },
        );
  }

  GestureDetector listItemWidget(Word wordItem) {
    return GestureDetector(
      // onDoubleTap: () {
      //   navigateToDetail(wordItem, "View ${wordItem.name}");
      // },
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
        navigateToDetail(itemWord, "View");

        debugPrint("lit Tap");
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateListWords().then((onValue) {
      setState(() {});
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    autocompleteController.text = "";

    final Word result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, widget.db, talker: widget.talker);
    }));
    autocompleteController.clear();
    updateListWords().then((onValue) {
      var positionIndex = 0;
      listWords = onValue;
      for (var (index, item) in listWords.indexed) {
        if (item.id == result.id) {
          positionIndex = index;
        }
      }
      setState(() {
        isLoad = false;
      });
      _scrollController.jumpTo(index: positionIndex);
      // Scrollable.ensureVisible(positionKey)
    });

    if (result != null) {}
  }

  Future<List<Word>> getRecursiveWordTree(
      List<Word> treeOrder, List<int> ids, Word root) async {
    if (ids.contains(root.id)) {
      return treeOrder;
    }
    treeOrder.add(root);
    ids.add(root.id);

    List<Word> chields = await widget.db.getChildrenWordList(root);
    for (var item in chields) {
      // ignore: unused_local_variable
      var newTreeOrder = await getRecursiveWordTree(treeOrder, ids, item);
    }

    return treeOrder;
  }

  Future<List<Word>> updateListWords() async {
    // setState(() {
    isLoad = true;
    // });
    // widget.talker.info("start get wordList");
    listWords = await widget.db.getOrdersWordList();

    Future<List<Word>> fListWords =
        widget.db.getOrdersWordList(); //db.select(db.words).get();
    fListWords.then((value) async {
      // listWords = value;
      listAzWords = value.map((e) {
        return AzWords(e, e.name, e.name.trim().substring(0, 1).toUpperCase());
      }).toList();
      SuspensionUtil.sortListBySuspensionTag(listAzWords);
      SuspensionUtil.setShowSuspensionStatus(listAzWords);

      setState(() {
        // listWords = value;
        isLoad = false;
      });
      // widget.talker.info("end get wordList");
      return orderedListWords;
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
    widget.db.deleteWord(itemWord).then((value) async {
      await updateListWords();
      setState(() {});
    });
    for (var (index, item) in listWords.indexed) {
      if (item.id == itemWord) {
        listWords.removeAt(index);
        break;
      }
    }

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
    //widget.db.getGroupedSessionsByName().then((onValue) {});
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
