import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';
import 'package:wortschatzchen_quiz/widgets/animated_Card.dart';

class SessionWordList extends StatefulWidget {
  final DbHelper db;
  final Talker talker;
  final String currentSession;

  const SessionWordList(
      {super.key,
      required this.talker,
      required this.db,
      required this.currentSession});
  @override
  SessionWordListState createState() => SessionWordListState();
}

class SessionWordListState extends State<SessionWordList> {
  String currentTypeSession = "";
  bool isLoad = false;
  List<Word> listWords = [];
  List<AutoCompliteHelper> autoComplitData = [];
  List<SessionHeader> listSessions = [];
  String defaultSession = "";
  final TextEditingController sessionsController = TextEditingController();
  final autoComplitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateWordsList().then((onValue) {
      setState(() {
        listWords = onValue;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _getListSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppDataProvider>(
          builder: (context, AppDataProvider, child) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  snap: true,
                  elevation: 0,
            title: isLoad
                ? const Center(child: CircularProgressIndicator())
                : Text(widget.currentSession),


                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      moveToLastScreen();
                    },
                  ),
                  surfaceTintColor: Colors.transparent,
                  // bottom: PreferredSize(
                  //     preferredSize: const Size.fromHeight(70),
                  //   // child: searchWordsButton()
                  // ),
                ),
                SliverGrid.builder(
                  itemCount: listWords.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300, crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    Word element = listWords.elementAt(index);
                      return Container(
                        child: Center(
                          child: AnimatedCard(
                              editWord: element,
                              db: widget.db,
                              talker: widget.talker),
                        ),
                      );
                    //  Card(
                    //   color: Colors.amber,
                    // );
                  },
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                      var itemWord =
                          AppDataProvider.sessionByFilter.elementAt(index);
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
                    itemCount: AppDataProvider.sessionByFilter.length,
                )
              ],
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addWord(""),
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );
  }

  Container searchWordsButton() {
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: autoComplitController,
          decoration: const InputDecoration(label: Text("Search")),
          onChanged: (value) {},
        ));
  }

  PreferredSize sessionListChoiceView(String empty) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            DropdownMenu<String>(
              enableFilter: false,
              enableSearch: true,
              controller: sessionsController,
              dropdownMenuEntries: listSessions.map((toElement) {
                return DropdownMenuEntry<String>(
                  value: toElement.typesession,
                  label: toElement.description,
                );
              }).toList(),
              onSelected: (value) {
                widget.talker.info("selected session item $value");
                currentTypeSession = value!;
                _updateWordsList().then((onValue) {
                  setState(() {
                    listWords = onValue;
                  });
                });
              },
            ),
            IconButton(
                onPressed: () {
                  currentTypeSession = "";
                  _updateWordsList().then((onValue) {
                    setState(() {
                      listWords = onValue;
                    });
                  });

                  setState(() {
                    sessionsController.clear();
                  });
                },
                icon: const Icon(Icons.cancel)),
          ],
        ),
      ),
    );
  }

  Widget autoCompliteWidget() {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<AutoCompliteHelper>.empty();
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
        .getGroupedSessionsByName();
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

  Future<List<Word>> _updateWordsList() async {
    
    setState(() {
      isLoad = true;
    });

    List<Word> result =
        await widget.db.getWordsBySession(widget.currentSession);

    setState(() {
      isLoad = false;
      listWords = result;
    });
    return result;
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
      // widget.talker.info("session word list route to detail ", wordToEdit);
      return WordsDetail(
        wordToEdit,
        title,
        widget.db,
        talker: widget.talker,
      );
    }));
    if (result) {
      autoComplitController.text = "";
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
