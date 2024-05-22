import 'dart:async';

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
  final DbHelper db;

  const WordsDetail(this.editWord, this.title, this.db, {super.key});

  @override
  WordsDetailState createState() => WordsDetailState(editWord, title, db);
}

class WordsDetailState extends State<WordsDetail> {
  bool changed = false;
  late Word editWord;
  final String appBarText;
  DbHelper db;
  WordsDetailState(this.editWord, this.appBarText, this.db);

  String inputLanguage = 'de';
  String outputLanguage = 'uk';

  final translator = GoogleTranslator();
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController immportantController = TextEditingController();

  TextEditingController meanController = TextEditingController();
  Word? wordEditing = const Word(
      id: 0,
      uuid: "",
      name: "",
      description: "",
      immportant: "",

      mean: "",
      baseForm: "",
      baseLang: 0,
      rootWordID: 0);
  List<Synonym> listSynonyms = [];
  String article = "";
  String baseWord = "";
  Language baseLang = const Language(id: 0, name: "dummy", shortName: "du", uuid: "oooo");

  Future<String> translateText(String inputText) async {
    final translated =
        await translator.translate(inputText, from: inputLanguage, to: outputLanguage);

    //setState(() {    });
    return translated.text;
  }

  @override
  void initState() {

    fillControllers(editWord);
    

    super.initState();
    try {
      setBaseSettings().then((value) {
        setState(() {});
      });
    } catch (e) {}
    setBaseSettings().then((value) {
      setState(() {});
    });
  }

  fillControllers(Word editWord) {
    titleController.text = editWord.name;
    descriptionController.text = editWord.description;
    meanController.text = editWord.mean;
    immportantController.text = editWord.immportant;
  }

  Future<String> setBaseSettings() async {
    if (editWord.id > 0) {
      var editWordupdated = await db.getWordById(editWord.id);
      if (editWordupdated != null) {
        editWord = editWordupdated;
      }
    }
    if (editWord.baseLang > 0) {
     

      baseLang = (await db.getLangById(editWord.baseLang))!;
    } else {
      var baseLang1 = await DbHelper().getLangByShortName("de");
      if (baseLang1 == null) {
        int id = (await db
            .into(db.languages)
            .insert(LanguagesCompanion.insert(name: "German", shortName: "de")));
        baseLang = (await db.getLangById(id))!;
      }
      if (editWord.name.isNotEmpty && editWord.id > 0) {
        fillControllers(editWord);
        UpdateWordIfNeed(editWord);
        //await addWord();

        db.getSynonymsByWord(editWord.id).then((value) {
          listSynonyms = value;
          setState(() {});
        });
        db.getLeipzigDataByWord(editWord).then(
          (value) {
            if (value != null) {
              setState(() {
                article = value.article;
                baseWord = value.wordOfBase;
              });
            }
          },
        );
      } else {}
    }

    return "Ok";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.displaySmall;
    var textToAppBar = appBarText;
    if (editWord.baseForm.isNotEmpty) {
      textToAppBar = "$textToAppBar ${editWord.baseForm}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(textToAppBar),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                  controller: titleController,
                  style: textStyle,
                  decoration: InputDecoration(
                      label: const Text('Title'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)))),
            ),
            // 3 element
            article.isNotEmpty ? Text(article) : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  //FIXME: add save
                  // updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            TextField(
              controller: meanController,
              decoration: const InputDecoration(label: Text("Mean")),
            ),
            TextField(
              controller: immportantController,
              decoration: const InputDecoration(label: Text("Immportant")),
              onChanged: (value) {
                editWord = editWord.copyWith(immportant: value);
              },
            ),

            buildWidgetSynonymsView(listSynonyms),

            if (isLoading)
              const LinearProgressIndicator()
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(onPressed: _fillData, icon: const Icon(Icons.downloading)),
                  IconButton(onPressed: SaveWord, icon: const Icon(Icons.save)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<String> SaveWord() async {
    editWord = editWord.copyWith(
        name: titleController.text,
        description: descriptionController.text,
        mean: meanController.text,
        immportant: immportantController.text);
    if (editWord.id > 0) {
      await UpdateWordIfNeed(editWord);
    } else {
      await addWord();
    }
    setState(() {});
    return "";
  }

  Widget _addListTitleSynonym(String title1, String description, Synonym item) {
    String tempTitle = title1;
    return ListTile(
        // leading: item.synonymWord > 0
        //     ? const CircleAvatar(
        //         backgroundColor: Colors.red,
        //         child: Icon(Icons.keyboard_arrow_right),
        //       )
        //     : Container(),
        title: Text(title1),
        subtitle: Text(description),
        trailing: item.synonymWord > 0
            ? IconButton(
                onPressed: () {
                  viewWord(item);
                },
                icon: const Icon(Icons.download_done))
            : IconButton(
                onPressed: () {
                  addNewWordFromSynonym(item);
                },
                icon: const Icon(Icons.do_disturb)),
        onLongPress: () {
          debugPrint(tempTitle);
        },
        onTap: () async {
          String onTapeString = tempTitle;
          Word? wordToEdit;
          if (item.synonymWord > 0) {
            wordToEdit = await db.getWordById(item.synonymWord);
          }
          navigateToDetail(
              wordToEdit ??
                  Word(
                      id: -99,
                      uuid: "",
                      name: onTapeString,
                      description: description,
                      mean: "",
                      immportant: "",
                      baseForm: "",
                      baseLang: baseLang.id,
                      rootWordID: editWord.id),
              wordToEdit != null
                  ? "View synonyme for '${editWord.name}'"
                  : "Add synonyme for ${editWord.name}");
        }

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

  Widget buildWidgetSynonymsView(List<Synonym> listSynonyms) {
    List<Widget> listChildren = [];
    int maxLengthSynonymsList = 100;
    String titleList = "";
    if (listSynonyms.isNotEmpty) {
      int maxCount =
          listSynonyms.length > maxLengthSynonymsList ? maxLengthSynonymsList : listSynonyms.length;
      titleList = listSynonyms
          .map((e) {
            return " ${e.name}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      var listSynonymsSliced = listSynonyms.sublist(0, maxCount);
      for (var _item in listSynonymsSliced) {
        listChildren.add(_addListTitleSynonym(_item.name, _item.translatedName, _item));

        // ))
      }
    }

    return ExpansionTile(
      title: const Text("Synonyms: "),
      subtitle: Text(titleList),
      initiallyExpanded: false,
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          for (var synItem in listSynonyms) {
            if (synItem.synonymWord == 0) {
              addNewWordWithAllData(synItem.name, editWord);
            }
          }
          db.getSynonymsByWord(editWord.id).then((value) {
            listSynonyms = value;
            setState(() {
              isLoading = false;
            });
          });
        },
      ),
      children: listChildren,
    );
  }

  Future<String> _fillData() async {
    setState(() {
      isLoading = true;
    });
    if (descriptionController.text.isEmpty) {
      descriptionController.text = await translateText(titleController.text);
    }
    _addUpdateWord().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    db.getLeipzigDataByWord(editWord).then((value) {
      if (value != null) {
        setState(() {
          article = value.article;
          baseWord = value.wordOfBase;
        });
      }
    });

    return "ok";
  }

  Future<Word?> addWordShort(String name, String translated, Word editWord) async {
    var leipzigSynonyms = LeipzigWord(editWord.name, db);
    leipzigSynonyms.db = db;
    var word = await leipzigSynonyms.addWodrUpdateshort(name, translated, editWord, baseLang);
    return word;
  }

  Future<Word?> addNewWord(String name, Word editWord) async {
    var leipzigSynonyms = LeipzigWord(editWord.name, db);
    leipzigSynonyms.db = db;
    var word = (await leipzigSynonyms.addNewWord(name, editWord, baseLang))!;
    return word;

    // var leipzigTranslator = LeipzigTranslator(db: db);
    // leipzigTranslator.baseLang = baseLang;

    // var word = await db.getWordByName(name);
    // if (word == null) {
    //   var translatedName = await leipzigTranslator.translate(name);
    //   int id = await db.into(db.words).insert(WordsCompanion.insert(
    //         name: name,
    //         description: translatedName,
    //         mean: "",
    //         baseForm: "",
    //         rootWordID: editWord.id,
    //         baseLang: editWord.id <= 0 ? baseLang.id : editWord.id,
    //       ));
    //   word = await db.getWordById(id);
    // }
    // return word;
  }

  Future<Word> UpdateWordIfNeed(Word wordToUpdate) async {
    if (wordToUpdate.id <= 0) {
      /*var word = await addNewWord(titleController.text, editWord);
      if (word != null) {
        editWord = word.copyWith();
      } else {*/
      Error();
    } else {
      var isChanched = true;

      Word toUpdate = wordToUpdate.copyWith();

      if (wordToUpdate.name != titleController.text && titleController.text.isNotEmpty) {
        toUpdate = toUpdate.copyWith(name: titleController.text);
        isChanched = true;
      }
      if (wordToUpdate.description != descriptionController.text &&
          descriptionController.text.isNotEmpty) {
        toUpdate = toUpdate.copyWith(description: descriptionController.text);
        isChanched = true;
      }
      if (isChanched) {
        var result = await db.updateWord(toUpdate);
        wordToUpdate = toUpdate.copyWith();
      }
    }
    return wordToUpdate;
  }

  Future<Word> addWord() async {
    if (editWord.id <= 0) {
      var word = await addNewWord(titleController.text, editWord);
      if (word != null) {
        editWord = word.copyWith();
      } else {
        Error();
      }
    } else {
      Word toUpdate = editWord.copyWith(
          name: titleController.text,
          description: descriptionController.text,
          baseLang: baseLang.id == 0 ? editWord.baseLang : baseLang.id);

      bool result = await db.updateWord(toUpdate);
      if (result) {
        editWord = toUpdate.copyWith();
      }
    }
    return editWord;
  }

  Future<bool> _addUpdateWord() async {
    editWord = await addWord();
    var leipzigSynonyms = LeipzigWord(editWord.name, db);

    try {
      await leipzigSynonyms.getFromInternet();
      await leipzigSynonyms.updateDataDB(leipzigSynonyms, db, editWord);
      var leipzigdate = await db.getLeipzigDataByWord(editWord);
      if (leipzigdate != null) {}
    } on Exception catch (e) {
      // TODO
    }
    listSynonyms = await db.getSynonymsByWord(editWord.id);

    return true;
  }

  void moveToLastScreen() async {
    if (titleController.text.isEmpty) {
      addWord().then((value) {
        Navigator.pop(context, false);
      });

      return;
    } else {
      Navigator.pop(context, true);
    }
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, db);
    }));
    if (result) {}
  }

  viewWord(Synonym item) async {
    Word? synonymWord = await db.getWordByName(item.name);
    synonymWord ??= Word(
        id: -99,
        uuid: "",
        name: item.name,
        description: "",
        mean: "",
        immportant: "",

        baseForm: "",
        baseLang: 0,
        rootWordID: editWord.id);
    navigateToDetail(synonymWord, "View synonym ");
  }

  Future<Word?> addNewWordWithAllData(String name, Word basedWord) async {
    var newWord = await addNewWord(name, basedWord);
    if (newWord != null) {
      var syn = await db.getSynonymEntry(name, basedWord);
      if (syn != null) {
        var synToUpdate = syn.copyWith(synonymWord: newWord.id);
        await db.updateSynonym(synToUpdate);
      }

      var leipzigSynonyms = LeipzigWord(newWord.name, db);
      await leipzigSynonyms.getFromInternet();
      await leipzigSynonyms.updateDataDB(leipzigSynonyms, db, newWord);
    }
    return newWord;
  }

  addNewWordFromSynonym(Synonym item) {
    addNewWordWithAllData(item.name, editWord).then((result) {
      item = item.copyWith(baseWord: result!.id);

      db.getSynonymsByWord(editWord.id).then((value) {
        listSynonyms = value;
        setState(() {});
      });

      setState(() {});
    });
  }


}
