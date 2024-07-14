import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';
import 'package:wortschatzchen_quiz/widgets/widgetAutoComplit.dart';

class WordsList extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const WordsList(this.db, {super.key, required this.talker});

  @override
  State<StatefulWidget> createState() => WordsListState();
}

class WordsListState extends State<WordsList> {
  int count = 2;
  String currentSearch = "";
  String unviewUnicode = "	";
  bool stateAutocomplit = false;
  bool isLoad = false;
  List<AutocompleteDataHelper> autoComplitData = [];
  TextEditingController autocompleteController = TextEditingController();
  final FocusNode _listViewFocusNode = FocusNode();
  int selectedIndex = 2;
  Map<String, dynamic> searchCache = {};

  List<Word> listWords = [];
  List<AzWords> listAzWords = [];
  List<Word> orderedListWords = [];
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    updateListWords();
  }

  @override
  void dispose() {
    _listViewFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 40,
          //   child: Container(
          //     decoration: BoxDecoration(color: Colors.blue),
          //   ),
          // ),
          //autoCompliteWidget(),
          WidgetAutoComplit(
              scrollController: _scrollController,
              listWords: listWords,
              navigateToDetail: navigateToDetail,
              listViewFocusNode: _listViewFocusNode),
          Consumer<AppDataProvider>(
            builder: (context, value, child) {
              listWords = value.listWords;
              return Expanded(
                child: Container(
                  color: Colors.green.shade100,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      // child: getAzWordListView()),
                      child: getWordsListView(value.listWords)),
                ),
              );
            },
          ),
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




  Widget getAzWordListView() {
    return Container();
  }
  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  ScrollablePositionedList getWordsListView(List<Word> listWords) {
    return ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: listWords.length,
        itemBuilder: (context, index) {
          Word wordItem = listWords[index];
          if (wordItem.rootWordID > 0) {}
          return listItemWidget(wordItem, index, listWords);
        }

        //   Card(
        //     color: Colors.white,
        //     elevation: 2.0,
        //     child: listWordView(wordItem),
        //   );
        // },
        );
  }

  GestureDetector listItemWidget(
      Word wordItem, int index, List<Word> listWords) {
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
              setState(() {
                listWords.removeAt(index);
              });
              _delete(wordItem);
            },
            child: listWordView(wordItem),
          )),
    );
  }

  Focus listWordView(Word itemWord) {
    return Focus(
      focusNode: _listViewFocusNode,
      child: ListTile(
        autofocus: true,
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: getKeyboardColor(itemWord),
          child: const Icon(Icons.keyboard_arrow_right),
        ),
        title: Text(
          itemWord.baseForm.isNotEmpty
              ? "${itemWord.baseForm}, ${itemWord.name} ${itemWord.important}"
              : itemWord.important.isNotEmpty
                  ? " ${itemWord.name} ,${itemWord.important}"
                  : itemWord.name,
          //style: const TextStyle(fontSize: 6),
        ),
        subtitle: Text("${itemWord.description} ${itemWord.mean}"),
        onTap: () {
          navigateToDetail(itemWord, "View");

          debugPrint("lit Tap");
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateListWords();
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
    searchCache.clear();
    stateAutocomplit = true;
    updateListWords().then((onValue) {
      var positionIndex = 0;
      listWords = onValue;
      for (var (index, item) in onValue.indexed) {
        if (item.id == result.id) {
          positionIndex = index;
          break;
        }
      }
      _scrollController.jumpTo(index: positionIndex);
      // Scrollable.ensureVisible(positionKey)
    });
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
    listWords = await Provider.of<AppDataProvider>(context, listen: false)
        .updateListWords();

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
    await widget.db.deleteWord(itemWord);
    for (var (index, item) in listWords.indexed) {
      if (item.id == itemWord.id) {
        listWords.removeAt(index);
        break;
      }
    }
    updateListWords().then((words) {
      setState(() {
        listWords = words;
      });
    });
    setState(() {
      listWords = listWords;
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
