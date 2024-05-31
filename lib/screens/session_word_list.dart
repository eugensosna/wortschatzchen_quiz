import 'dart:core';

import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

class SessionWordList extends StatefulWidget {
  final DbHelper db;
  final Talker talker;
  final String currentSesion;

  const SessionWordList(
      {super.key,
      required this.talker,
      required this.db,
      required this.currentSesion});
  @override
  _SessionWordListState createState() => _SessionWordListState();
}

class _SessionWordListState extends State<SessionWordList> {
  String currentTypeSession = "";
  bool isLoad = false;
  List<Word> listWords = [];
  List<AutoComplitHelper> autoComplitData = [];
  List<SessionHeader> llistSessions = [];
  String defaultSession = "";
  final TextEditingController sessionsController = TextEditingController();
  final autoComplitController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // _getListSessions().then(
    //   (value) {
    //     setState(() {
    //       llistSessions = value;
    //     });
    //   },
    // );
    super.initState();
    _updateWordsList();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getListSessions();
  }

  @override
  Widget build(BuildContext context) {
    final String empty = getDefaultSessionName();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            // title: SessionListtChoiceView(empty),
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                moveToLastScreen();
              },
            ),
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: SearchWordsButton()),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              var itemWord = listWords.elementAt(index);
              return GestureDetector(
                onDoubleTap: () {
                  navigateToDetail(itemWord, "View ${itemWord.name}");
                },
                child: Dismissible(
                  key: Key(itemWord.uuid),
                  direction: DismissDirection.startToEnd,
                  child: ListTile(
                    title: Text(
                        "${itemWord.name},${itemWord.baseForm}-${itemWord.description} "),
                    leading: Text(" ${itemWord.important}  "),
                  ),
                ),
              );
            },
            itemCount: listWords.length,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addWord(""),
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );
  }

  Container SearchWordsButton() {
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: autoComplitController,
          decoration: const InputDecoration(label: Text("Suchen")),
          onChanged: (value) {},
        ));
  }

  PreferredSize SessionListtChoiceView(String empty) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            DropdownMenu<String>(
              // initialSelection: llistSessions.isNotEmpty
              // ? llistSessions[0].description
              // : empty,
              enableFilter: false,
              enableSearch: true,
              controller: sessionsController,
              dropdownMenuEntries: llistSessions.map((toElement) {
                return DropdownMenuEntry<String>(
                  value: toElement.typesession,
                  label: toElement.description,
                );
              }).toList(),
              onSelected: (value) {
                widget.talker.info("selected session item $value");
                currentTypeSession = value!;
                _updateWordsList();
              },
            ),
            IconButton(
                onPressed: () {
                  currentTypeSession = "";
                  _updateWordsList();

                  setState(() {
                    sessionsController.clear();
                  });
                },
                icon: Icon(Icons.cancel)),
          ],
        ),
      ),
    );
  }

  Widget autoCompliteWidget() {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<AutoComplitHelper>.empty();
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

  Future<List<SessionHeader>> _getListSessions() async {
    final String todaySession = getDefaultSessionName();
    defaultSession = "";

    List<SessionHeader> result = [];
    //def =  getFormattedDate(DateTime.now());
    final sessions = await widget.db
        .

        /// The `getGroupedSessionsByName` method is a function that
        /// retrieves a list of sessions grouped by name from the database.
        /// It returns a list of `SessionHeader` objects, where each object
        /// contains information about the session type and its description
        /// (including the count of items in that session). This method is
        /// used in the `_getListSessions` function to populate the list of
        /// sessions displayed in the UI.
        getGroupedSessionsByName();
    for (var item in sessions) {
      if (item.typesession.contains(todaySession)) {
        defaultSession = "${item.typesession} (${item.count})";
      }
      result.add(SessionHeader(
          typesession: item.typesession,
          description: "${item.typesession} (${item.count})"));
    }

    if (defaultSession.isEmpty) {
      defaultSession = todaySession;
      result.insert(
          0,
          SessionHeader(
              typesession: defaultSession, description: "$defaultSession (0)"));
    }
    return result;
  }

  void moveToLastScreen() async {
    Navigator.pop(context, true);

    return;
  }

  _updateWordsList() async {
    List<Word> result = await widget.db.getWordsBySession(widget.currentSesion);

    setState(() {
      listWords = result;
    });
  }

  Future<void> addWord(String name) async {
    navigateToDetail(
        Word(
            id: -99,
            uuid: "",
            name: name,
            description: "",
            important: "",
            mean: "",
            baseForm: "",
            baseLang: 0,
            rootWordID: 0),
        "Add new");
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(wordToEdit.id);
      return WordsDetail(wordToEdit, title, widget.db);
    }));
    if (result) {
      listWords = await _updateWordsList();
      setState(() {
        isLoad = false;
      });
    }
  }
}

class SessionHeader {
  final String typesession;
  final String description;

  SessionHeader({required this.typesession, required this.description});
}
