import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:wortschatzchen_quiz/models/LeipzigWord.dart';

class WordsDetail extends StatefulWidget {
  final Word editWord;
  final String title;

  const WordsDetail(this.editWord, this.title, {super.key});

  @override
  WordsDetailState createState() => WordsDetailState(editWord, title);
}

class WordsDetailState extends State<WordsDetail> {
  late Word editWord;
  final String AppBarText;
  WordsDetailState(this.editWord, this.AppBarText);

  String inputLanguage = 'de';
  String outputLanuage = 'uk';

  final translator = GoogleTranslator();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Word? wordEditing =
      const Word(
      id: 0,
      uuid: "",
      name: "",
      description: "",
      mean: "",
      baseLang: 0,
      rootWordID: 0);
  List<Synonym> listSynonyms = [];


Future<String> translateText(String inputText) async {
    final translated =
        await translator.translate(inputText, from: inputLanguage, to: outputLanuage);

    //setState(() {    });
    return translated.text;
  }
  final db = DbHelper();
  late Language baseLang;
  @override
  void initState() {
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
    if (editWord.name.isNotEmpty && editWord.id <= 0) {
      titleController.text = editWord.name;
      _addUpdateWord();
    }
    db.getSynonymsByWord(editWord.id).then((value) {
      listSynonyms = value;
      setState(() {});
    });
    setState(() {
      baseLang = baseLang1!;
     
    });
    return "Ok";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.displayMedium;
    titleController.text = editWord.name;
    descriptionController.text = editWord.description;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppBarText),
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

Widget _addListTitleSynonym(String title1, String description) {
    return ListTile(
      title: Text(title1),
      subtitle: Text(description),
      onLongPress: () {
        debugPrint("lljj");
      },
      // onTap: () {

      //   navigateToDetail(
      //       const Word(
      //           id: -99,
      //           uuid: "",
      //           name: title1,
      //           description: description,
      //           mean: "",
      //           baseLang: 0,
      //           rootWordID: 0),
      //       "Add synonym");
      // },
    );
  }

  Widget buildSynonyms(List<Synonym> listSynonyms) {

    List<Widget> listChildren = [];
    String titleList = "";
    if (listSynonyms.isNotEmpty) {
      int maxCount = listSynonyms.length > 10 ? 10 : listSynonyms.length;
      titleList = listSynonyms
          .map((e) {
            return " ${e.name}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      var listSynonymsSliced = listSynonyms.sublist(0, maxCount);
      for (var _item in listSynonymsSliced) {
        listChildren.add(_addListTitleSynonym(_item.name, _item.translatedName));
        // ListTile(
        //   title: Text(_item.name),
        //   subtitle: const Text("translate"),
        //     onTap: () {
        //       navigateToDetail(
        //           const Word(
        //               id: -99,
        //               uuid: "",
        //               name: _item.name,
        //               description: "",
        //               mean: "",
        //               baseLang: 0,
        //               rootWordID: 0),
        //           "Add synonym");
        //     },

        // ))
      }
    }

    return ExpansionTile(
      title: const Text("Synonyms: "),
      subtitle: Text(titleList),
      initiallyExpanded: true,
      children: listChildren,
    );
  }

  Future<String> _fillData() async {
    _addUpdateWord();

    return "ok";
  }

  void _addUpdateWord() async {
    if (editWord.id <= 0) {
      descriptionController.text = await translateText(titleController.text);
      var word = await db.getWordByName(titleController.text);
      int id = await db.into(db.words).insert(WordsCompanion.insert(
            name: titleController.text,
            description: descriptionController.text,
            mean: "",
            rootWordID: 0,
            baseLang: baseLang.id,
          ));
      word = await db.getWordById(id);
      if (word != null) {
        editWord = word;
      }
      var leipzigSynonyms = LeipzigWord(word!.name);
      await leipzigSynonyms.getFromInternet();
      if (leipzigSynonyms.Synonym.isNotEmpty) {
        db.deleteSynonymsByWord(editWord);
      }
      for (var item in leipzigSynonyms.Synonym) {
        String translated = await translateText(item.name);

        var idSyn = await db.into(db.synonyms).insert(SynonymsCompanion.insert(
            name: item.name,
            translatedName: translated,
            baseWord: editWord.id,
            synonymWord: 0,
            baseLang: word.baseLang));
      }
    } else {
      Word toUpdate =
          editWord.copyWith(name: titleController.text, description: descriptionController.text);

      bool result = await db.updateWord(toUpdate);
      if (result) {
        editWord = toUpdate.copyWith();
      }
    }
    

    listSynonyms = await db.getSynonymsByWord(editWord.id);

    setState(() {
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



Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(wordToEdit.id);
      return WordsDetail(wordToEdit, title);
    }));
    if (result) {}
  }

}
