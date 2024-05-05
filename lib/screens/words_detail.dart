import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';

class WordsDetail extends StatefulWidget {
  const WordsDetail({super.key});

  @override
  _WordsDetailState createState() => _WordsDetailState();
}

class _WordsDetailState extends State<WordsDetail> {
  static final List<String> _prioretys = ["Hight", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
      baseLang1 = db.getLangById(id) as Language?;
    }
    setState(() {
      baseLang = baseLang1!;
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
            ListTile(
              title: DropdownButton(
                items: _prioretys
                    .map((String value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    debugPrint("select proirety $value");
                  });
                },
              ),
            ),
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
                  decoration: InputDecoration(
                      label: const Text('Title'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)))),
            ),
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
          ],
        ),
      ),
    );
  }

  void _addWord() {}

  void moveToLastScreen() async {
    if (titleController.text.isEmpty && descriptionController.text.isEmpty) {
      Navigator.pop(context, false);
      return;
    } else {
      final result = await db.into(db.words).insert(WordsCompanion.insert(
          name: titleController.text, description: descriptionController.text));
      Navigator.pop(context, true);
    }
  }
}
