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

  const SessionWordList({super.key, required this.talker, required this.db});
  @override
  _SessionWordListState createState() => _SessionWordListState();
}

class _SessionWordListState extends State<SessionWordList> {
  bool isLoad = false;
  List<AutoComplitHelper> autoComplitData = [];
  List<String> llistSessions = [];
  String defaultSession = "";
  final TextEditingController sessionsController = TextEditingController();
  final autoComplitController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _getListSessions().then(
      (value) {
        setState(() {
          llistSessions = value;
        });
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getListSessions();
  }

  Future<List<String>> _getListSessions() async {
    final String todaySession = getDefaultSessionName();
    defaultSession = "";

    List<String> result = [];
    //def =  getFormattedDate(DateTime.now());
    final sessions = await widget.db.getGroupedSessionsByName();
    for (var item in sessions) {
      if (item.typesession.contains(todaySession)) {
        defaultSession = "${item.typesession} (${item.count})";
      }
      result.add("${item.typesession} (${item.count})");
    }

    if (defaultSession.isEmpty) {
      defaultSession = todaySession;
      result.insert(0, todaySession);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final String empty = getDefaultSessionName();
    return Scaffold(
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: SessionListtChoiceView(empty),
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: SearchWordsButton()),
          ),
          SliverList.builder(
            itemBuilder: (context, index) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              height: 40,
              decoration: const BoxDecoration(color: Colors.lightGreen),
              child: const Text("word"),
            ),
            itemCount: 40,
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
        child: DropdownMenu<String>(
            initialSelection: llistSessions.isNotEmpty ? llistSessions[0] : empty,
            enableFilter: true,
            enableSearch: true,
            controller: sessionsController,
            dropdownMenuEntries: llistSessions.map((toElement) {
              return DropdownMenuEntry<String>(
                value: toElement,
                label: toElement,
              );
            }).toList()),
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

  Future<void> addWord(String name) async {
    navigateToDetail(
        Word(
            id: -99,
            uuid: "",
            name: name,
            description: "",
            immportant: "",
            mean: "",
            baseForm: "",
            baseLang: 0,
            rootWordID: 0),
        "Add new");
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(wordToEdit.id);
      return WordsDetail(wordToEdit, title, widget.db);
    }));
    if (result) {
      setState(() {
        isLoad = false;
      });
    }
  }
}
