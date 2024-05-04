import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class WordsDetail extends StatefulWidget {
  const WordsDetail({super.key});

  @override
  _WordsDetailState createState() => _WordsDetailState();
}

class _WordsDetailState extends State<WordsDetail> {
  static final List<String> _prioretys = ["Hight", "Low"];
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
                    .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
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
                  controller: titleControler,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Someting changed in Title $value');
                  },
                  decoration: InputDecoration(
                      label: const Text('Title'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)))),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addWord() {}

  void moveToLastScreen() async {
    final db = AppDatabase();
    await db.into(db.words).insert(
        WordsCompanion.insert(name: titleControler.text, description: descriptionController.text));
    Navigator.pop(context, true);
  }
}
