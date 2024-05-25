import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

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
  final TextEditingController sessionsController = TextEditingController();
  final autoComplitController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    llistSessions.add("todayjkljljkjkjkjlj");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: DropdownMenu<String>(
                  enableFilter: true,
                  controller: sessionsController,
                  dropdownMenuEntries: llistSessions.map((toElement) {
                    return DropdownMenuEntry<String>(
                      value: toElement,
                      label: toElement,
                    );
                  }).toList()),
            ),
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: TextField(
                      controller: autoComplitController,
                    ))),
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
