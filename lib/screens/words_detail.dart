import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:wortschatzchen_quiz/models/LeipzigWord.dart';

class WordsDetail extends StatefulWidget {
  const WordsDetail({super.key});

  @override
  _WordsDetailState createState() => _WordsDetailState();
}

class _WordsDetailState extends State<WordsDetail> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Word? wordEditing = Word(
      id: 0,
      uuid: "",
      name: "",
      description: "",
      mean: "",
      baseLang: 0,
      rootWordID: 0);
  List<Synonym> listSynonyms = [];

  final db = DbHelper();
  late Language baseLang;
  @override
  void initState() {
    // TODO: implement initState
    // final result().getDefauiltBaseLang();
    super.initState();
    setBaseSetings().then((value) => print(value));
  }

  Future<String> setBaseSetings() async {
    var baseLang1 = await DbHelper().getLangByShortName("de");
    if (baseLang1 == null) {
      int id = (await db
          .into(db.languages)
          .insert(LanguagesCompanion.insert(name: "German", shortName: "de")));
      baseLang1 = await db.getLangById(id);
    }
    if (wordEditing == null) {
    } else {
      listSynonyms = await db.getSynonymsByWord(wordEditing!.id);
      setState(() {});
    }
    setState(() {
      baseLang = baseLang1!;
      titleController.text = wordEditing!.name;
      descriptionController.text = wordEditing!.description;
    });
    return "Ok";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.displayMedium;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Someting changed in Title $value');
                  },
                  onEditingComplete: () async {
                    debugPrint("onEditingComplete");
                    // _addUpdateWord();
                  },
                  onTapOutside: (event) {
                    debugPrint("onTapOutside" + event.toString());
                  },
                  decoration: InputDecoration(
                      label: const Text('Title'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)))),
            ),
            buildSynonyms(listSynonyms),
            // 3 element

            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  // updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            IconButton(
                onPressed: _fillData, icon: const Icon(Icons.downloading)),
          ],
        ),
      ),
    );
  }

  Widget buildSynonyms(List<Synonym> _listSynonyms) {
    String title = "";
    _listSynonyms.map((e) => title + e.name);
    List<Widget> listChildren = [];
    for (var _item in _listSynonyms) {
      listChildren.add(ListTile(
        title: Text(_item.name),
        subtitle: const Text("translate"),
      ));
    }

    return ExpansionTile(
      title: Text("Synonyms: $title"),
      children: listChildren,
    );
  }

  Future<String> _fillData() async {
    _addUpdateWord();

    return "ok";
  }

  void _addUpdateWord() async {
    var _word = await db.getWordByName(titleController.text);
    if (_word == null) {
      int id = await db.into(db.words).insert(WordsCompanion.insert(
            name: titleController.text,
            description: descriptionController.text,
            mean: "",
            rootWordID: 0,
            baseLang: baseLang.id,
          ));
      _word = await db.getWordById(id);

      var leipzigSynonyms = LeipzigWord(_word!.name);
      await leipzigSynonyms.getFromInternet();
      for (var item in leipzigSynonyms.Synonym) {
        print(item);

        var idSyn = await db.into(db.synonyms).insert(SynonymsCompanion.insert(
            name: item.name,
            baseWord: _word.id,
            synonymWord: 0,
            baseLang: _word.baseLang));
      }
    }

    setState(() {
      wordEditing = _word!;
    });
  }

  void moveToLastScreen() async {
    if (titleController.text.isEmpty && descriptionController.text.isEmpty) {
      Navigator.pop(context, false);
      return;
    } else {
      final result = await db.into(db.words).insert(WordsCompanion.insert(
          name: titleController.text,
          description: descriptionController.text,
          mean: '',
          baseLang: baseLang.id,
          rootWordID: 0));
      Navigator.pop(context, true);
    }
  }
}
