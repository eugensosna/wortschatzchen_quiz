import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/screens/session_word_list.dart';
import 'package:wortschatzchen_quiz/screens/web_view_controller_word.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';
import 'package:wortschatzchen_quiz/widgets/modal_show_reordable_view.dart';

class WordsDetail extends StatefulWidget {
  final Word editWord;
  final String title;
  final DbHelper db;
  final Talker talker;

  const WordsDetail(this.editWord, this.title, this.db,
      {super.key, required this.talker});

  @override
  // ignore: no_logic_in_create_state
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
  TextEditingController importantController = TextEditingController();

  TextEditingController meanController = TextEditingController();

  List<ReordableElement> listSynonyms = [];
  List<ReordableElement> listExamples = [];
  List<ReordableElement> listMeans = [];
  List<SessionHeader> listSessions = [];

  String article = "";
  String baseWord = "";
  String currentWordSession = getDefaultSessionName();
  late Language baseLang;

  Future<String> translateText(String inputText) async {
    try {
      final translated = await translator.translate(inputText,
          from: inputLanguage, to: outputLanguage);

      return translated.text;
    } catch (e) {
      widget.talker.error(" detail translateText $inputText", e);
    } finally {
      // ignore: control_flow_in_finally
      return "";
    }
  }

  Future<String> _getWordSession(Word wordItem) async {
    String result = getDefaultSessionName();
    if (wordItem.id > 0) {
      var sessionItem = await widget.db.getSessionEntryByWord(wordItem);
      if (sessionItem != null) {
        result = sessionItem.typesession;
      }
    }

    return result;
  }

  Future<List<SessionHeader>> _getListSessions() async {
    List<SessionHeader> result = [];
    String defaultSession = getDefaultSessionName();
    bool defaultFound = false;

    final sessions = await widget.db.getGroupedSessionsByName();
    for (var item in sessions) {
      if (!defaultFound && item.typesession.contains(defaultSession)) {
        defaultFound = true;
      }
      // if (item.typesession.contains(todaySession)) {
      //   defaultSession = "${item.typesession} (${item.count})";
      // }
      result.add(SessionHeader(
          typesession: item.typesession,
          description: "${item.typesession} (${item.count})"));
    }
    if (!defaultFound) {
      result.insert(
          0,
          SessionHeader(
              typesession: defaultSession, description: defaultSession));
    }

    return result;
  }

  @override
  void initState() {
    baseLang =
        const Language(id: 0, name: "dummy", shortName: "du", uuid: "oooo");

    fillControllers(editWord);

    super.initState();
    try {
      setBaseSettings().then((value) {});
    } catch (e) {
      widget.talker
          .error("detail init state error fill for ${editWord.name}", e);
    }
  }

  fillControllers(Word editWord) {
    titleController.text = editWord.name

        /// The above code snippet appears to be written in Dart. It
        /// seems to be setting the text of a description controller to
        /// a value stored in a variable or constant named "editWo".
        /// However, the code is incomplete and contains some syntax
        /// errors, such as the semicolon after "Dart" and the random
        /// characters "
        ;
    descriptionController.text = editWord.description;
    meanController.text = editWord.mean;
    importantController.text = editWord.important;
    if (listMeans.isNotEmpty && meanController.text.isEmpty) {
      meanController.text = listMeans[0].name;
    }
  }

  Future<String> setBaseSettings() async {
    if (editWord.id > 0) {
      var editWordUpdated = await db.getWordById(editWord.id);
      if (editWordUpdated != null) {
        editWord = editWordUpdated;
      }
    }

    if (editWord.baseLang > 0) {
      var baseLangOrNull = (await db.getLangById(editWord.baseLang))!;
      if (baseLangOrNull != null) {
        baseLang = baseLangOrNull;
      }
    } else {
      var baseLangOrNull = await db.getLangByShortName("de");
      if (baseLangOrNull == null) {
        int id = (await db.into(db.languages).insert(
            LanguagesCompanion.insert(name: "German", shortName: "de")));
        baseLangOrNull = (await db.getLangById(id))!;
        if (baseLangOrNull != null) {
          baseLang = baseLangOrNull;
        }
      }
    }
    listSessions = await _getListSessions();
    currentWordSession = await _getWordSession(editWord);

    if (editWord.name.isNotEmpty && editWord.id > 0) {
      fillControllers(editWord);
      updateWordIfNeed(editWord);
      //await addWord();

      listSynonyms = await db.getSynonymsByWord(editWord.id);
      listExamples = await db.getExamplesByWord(editWord.id);
      listMeans = await db.getMeansByWord(editWord.id);

      var data = await db.getLeipzigDataByWord(editWord);
      if (data != null) {
        article = data.article;
        baseWord = data.wordOfBase;
      }
      Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          setState(() {});
        },
      );
    } else {
      if (editWord.name.isNotEmpty && editWord.id < 0) {
        descriptionController.text = await translateText(editWord.name);
        saveWord().then(
          (value) {
            _fillData().then(
              (value) {
                fillControllers(editWord);
                setState(() {});
              },
            );
          },
        );
      }
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)))),
            ),
            // 3 element
            article.isNotEmpty ? Text(article) : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            TextField(
              controller: meanController,
              decoration: const InputDecoration(label: Text("Mean")),
              onTap: () {
                _showEditMeans(context, listMeans);
              },
            ),
            // IconButton.filled(
            //     onPressed: _showEditMeans(context), icon: Icon(Icons.edit))

            TextField(
              controller: importantController,
              decoration: const InputDecoration(label: Text("Important")),
              onChanged: (value) {
                editWord = editWord.copyWith(important: value);
              },
            ),

            buildWidgetSynonymsView(listSynonyms),

            buildWidgetExamplesView(listExamples, maxDesc: 1),
            DroupDownSessionsChange(),

            Row(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        onPressed: _fillData,
                        icon: const Icon(Icons.downloading)),
                IconButton(onPressed: saveWord, icon: const Icon(Icons.save)),
                IconButton(
                    onPressed: goToVerbForm, icon: const Icon(Icons.add_task)),
                IconButton(
                    onPressed: () async {
                      var result =
                          await _showOrEditReordable(context, listSynonyms);
                      await _saveToExamples(result);
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<String> DroupDownSessionsChange() {
    return DropdownButtonFormField(
        value: currentWordSession,
        hint: const Text("Group"),
        items: listSessions
            .map((element) => DropdownMenuItem<String>(
                  value: element.typesession,
                  child: Text(element.typesession),
                ))
            .toList(),
        onChanged: (value) async {
          currentWordSession = value ?? "";
          _moveWordToSession(currentWordSession, editWord);

          setBaseSettings().then((onValue) {
            setState(() {});
          });
        });
  }

  _moveWordToSession(String newSession, Word wordItem) async {
    var session = await widget.db.getSessionEntryByWord(wordItem);
    if (session != null) {
      var toUpdate = session.copyWith(typesession: newSession);
      widget.db.update(widget.db.sessions).replace(toUpdate);
    }
  }

  Future<Word> saveWord() async {
    editWord = editWord.copyWith(
        name: titleController.text,
        description: descriptionController.text,
        mean: meanController.text,
        important: importantController.text);
    if (editWord.id > 0) {
      return await updateWordIfNeed(editWord);
    } else {
      return await addWord();
    }
  }

  Widget _addListTitleSynonym(
      String title1, String description, ReordableElement item) {
    String tempTitle = title1;
    return ListTile(
        title: Text(title1),
        subtitle: Text(description),
        trailing: IconButton(
            onPressed: () {
              viewWord(item.name);
            },
            icon: const Icon(Icons.download_done)),
        // : IconButton(
        //     onPressed: () {
        //       addNewWordFromSynonym(item);
        //     },
        //     icon: const Icon(Icons.do_disturb)),
        onLongPress: () {
          debugPrint(tempTitle);
        },
        onTap: () async {
          String onTapeString = tempTitle;
          Word? wordToEdit;
          // wordToEdit = await db.getWordById(item.name);

          navigateToDetail(
              wordToEdit ??
                  Word(
                      id: -99,
                      uuid: "",
                      name: onTapeString,
                      description: description,
                      mean: "",
                      important: "",
                      baseForm: "",
                      baseLang: baseLang.id,
                      rootWordID: editWord.id),
              "Add synonym for ${editWord.name}");
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

  Widget _addListTitleExample(
      String title1, String description, ReordableElement item) {
    String tempTitle = title1;
    return ListTile(
        title: Text(title1),
        subtitle: Text(description),
        trailing: IconButton(
            onPressed: () {
              viewWord(item.name);
            },
            icon: const Icon(Icons.download_done)),
        onLongPress: () {
          debugPrint(tempTitle);
        },
        onTap: () async {
          String onTapeString = tempTitle;
          Word? wordToEdit;
          // wordToEdit = await db.getWordById(item.name);

          navigateToDetail(
              wordToEdit ??
                  Word(
                      id: -99,
                      uuid: "",
                      name: onTapeString,
                      description: description,
                      mean: "",
                      important: "",
                      baseForm: "",
                      baseLang: baseLang.id,
                      rootWordID: editWord.id),
              "Add synonym for ${editWord.name}");
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

  Widget buildWidgetExamplesView(List<ReordableElement> examples,
      {int maxDesc = 100}) {
    List<Widget> listChildren = [];
    int maxLengthSynonymsList = maxDesc;
    String titleList = "";
    String translatedList = "";
    if (examples.isNotEmpty) {
      int maxCount = examples.length > maxLengthSynonymsList
          ? maxLengthSynonymsList
          : examples.length;
      titleList = examples
          .map((e) {
            return " ${e.name}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      translatedList = examples
          .map((e) {
            return " ${e.translate}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      var listSynonymsSliced = examples.sublist(0);
      for (var item in listSynonymsSliced) {
        listChildren.add(_addListTitleExample(item.name, item.translate, item));

        // ))
      }
    }
    var firstElement = examples.elementAtOrNull(0);
    firstElement ??=
        ReordableElement(id: 0, name: "", translate: "", orderId: 0, uuid: "");

    return ExpansionTile(
      title: Text("Examples: ${titleList}"),
      subtitle: Text(translatedList),
      initiallyExpanded: false,
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          var result = await _showOrEditReordable(context, listExamples);
          await _saveToExamples(result);
          setState(() {
            isLoading = true;
          });

          db.getSynonymsByWord(editWord.id).then((value) {
            listSynonyms = value;
            setState(() {
              isLoading = false;
            });
            db.getExamplesByWord(editWord.id).then((onValue) {
              listExamples = onValue;
              setState(() {
                isLoading = false;
              });
            });
          });
        },
      ),
      children: listChildren,
    );
  }

  Widget buildWidgetSynonymsView(List<ReordableElement> listSynonyms) {
    List<Widget> listChildren = [];
    int maxLengthSynonymsList = 4;
    String titleList = "";
    String translatedList = "";
    if (listSynonyms.isNotEmpty) {
      int maxCount = listSynonyms.length > maxLengthSynonymsList
          ? maxLengthSynonymsList
          : listSynonyms.length;
      translatedList = listSynonyms
          .map((e) {
            return " ${e.translate}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      titleList = listSynonyms
          .map((e) {
            return " ${e.name}";
          })
          .toList()
          .sublist(0, maxCount)
          .join(", ");
      var listSynonymsSliced = listSynonyms.sublist(0);
      for (var item in listSynonymsSliced) {
        listChildren.add(_addListTitleSynonym(item.name, item.translate, item));

        // ))
      }
    }

    return ExpansionTile(
      title: Text("Synonyms: $titleList "),
      subtitle: Text(translatedList),
      initiallyExpanded: false,
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          {
            var result = await _showOrEditReordable(context, listSynonyms);
            await _saveToExamples(result);
          }

          setState(() {
            isLoading = true;
          });
          // for (var synItem in listSynonyms) {
          //   if (synItem.synonymWord == 0) {
          //     addNewWordWithAllData(synItem.name, editWord);
          //   }
          // }
          db.getSynonymsByWord(editWord.id).then((value) {
            listSynonyms = value;
            setState(() {
              isLoading = false;
            });
            db.getExamplesByWord(editWord.id).then((onValue) {
              listExamples = onValue;
              setState(() {
                isLoading = false;
              });
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

  Future<Word?> addWordShort(
      String name, String translated, Word editWord) async {
    var leipzigSynonyms = LeipzigWord(editWord.name, db, widget.talker);
    leipzigSynonyms.db = db;
    var word = await leipzigSynonyms.addWordUpdateShort(
        name, translated, editWord, baseLang);
    return word;
  }

  Future<Word?> addNewWord(String name, Word editWord) async {
    var leipzigSynonyms = LeipzigWord(editWord.name, db, widget.talker);
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

  Future<Word> updateWordIfNeed(Word wordToUpdate) async {
    if (wordToUpdate.id <= 0) {
      /*var word = await addNewWord(titleController.text, editWord);
      if (word != null) {
        editWord = word.copyWith();
      } else {*/
      Error();
    } else {
      var isChanched = true;

      Word toUpdate = wordToUpdate.copyWith();

      // if (wordToUpdate.name != titleController.text &&
      //     titleController.text.isNotEmpty) {
      //   toUpdate = toUpdate.copyWith(name: titleController.text);
      //   isChanched = true;
      // }
      // if (wordToUpdate.description != descriptionController.text &&
      //     descriptionController.text.isNotEmpty) {
      //   toUpdate = toUpdate.copyWith(description: descriptionController.text);
      //   isChanched = true;
      // }
      if (isChanched) {
        await db.updateWord(toUpdate);
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

    descriptionController.text = editWord.description;
    setState(() {});
    return editWord;
  }

  Future<Word?> _addUpdateWord() async {
    editWord = await addWord();
    var leipzigSynonyms = LeipzigWord(editWord.name, db, widget.talker);
    leipzigSynonyms.talker
        .debug("start _addUpdateWord- getFromInternet ${editWord.name}");

    try {
      await leipzigSynonyms.getFromInternet();
      leipzigSynonyms.talker
          .debug("end _addUpdateWord- getFromInternet ${editWord.name}");

      var baseForm = leipzigSynonyms.baseWord;
      // if (leipzigSynonyms.baseWord.isNotEmpty) {
        

      //   var leipzigSynonyms = LeipzigWord(baseForm, db, widget.talker);
      //   leipzigSynonyms.talker.debug(
      //       "start _addUpdateWord- getFromInternet base form  ${baseForm}");

      //   await leipzigSynonyms.getFromInternet();
      // }
      leipzigSynonyms.talker
          .debug("start _addUpdateWord- updateDataDB $baseForm");

      await leipzigSynonyms.updateDataDB(leipzigSynonyms, db, editWord);
      var leipzigdate = await db.getLeipzigDataByWord(editWord);
      if (leipzigdate != null) {}
      widget.talker.debug("end updateDataDB ");
    } on Exception catch (e) {
      widget.talker.error("get data from Internet ${editWord.name}", e);
    }
    listSynonyms = await db.getSynonymsByWord(editWord.id);
    listExamples = await db.getExamplesByWord(editWord.id);
    editWord = (await db.getWordById(editWord.id))!;
    return editWord;
  }

  void moveToLastScreen() async {
    if (titleController.text.isEmpty) {
      Navigator.pop(context, false);

      return;
    } else {
      Navigator.pop(context, true);
    }
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, db, talker: widget.talker);
    }));
    if (result) {}
  }

  viewWord(String item) async {
    Word? synonymWord = await db.getWordByName(item);
    synonymWord ??= Word(
        id: -99,
        uuid: "",
        name: item,
        description: "",
        mean: "",
        important: "",
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

      var leipzigSynonyms = LeipzigWord(newWord.name, db, widget.talker);
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
      db.getExamplesByWord(editWord.id).then((value) {
        listExamples = value;
        setState(() {});
      });

      setState(() {});
    });
  }

  void goToVerbForm() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      widget.talker.info("go to verbform ${editWord.name}");
      return WebViewControllerWord(editWord: editWord, title: editWord.name);
    }));
    if (result) {
      setState(() {});
    }
  }

  _saveToExamples(List<ReordableElement> elements) async {
    Example? elemExamples;
    //await db.deleteExamplesByWord(editWord);
    for (var (index, item) in elements.indexed) {
      if (item.id <= 0) {
        int id = await db.into(db.examples).insert(
            ExamplesCompanion.insert(baseWord: editWord.id, name: item.name));
        elemExamples = await db.getExampleByIdOrUuid(id);
        if (elemExamples != null) {
          elemExamples = elemExamples.copyWith(exampleOrder: index);
        }
      } else {
        elemExamples = Example(
            id: item.id,
            uuid: item.uuid,
            baseWord: editWord.id,
            name: item.name,
            goaltext: "",
            exampleOrder: index);
      }
      if (elemExamples != null) {
        await db.update(db.examples).replace(elemExamples);
      }
    }
    await setBaseSettings();
    setState(() {});
  }

  Future<List<ReordableElement>> _showOrEditReordable(
      BuildContext context, List<ReordableElement> elements) async {
    // var dbmeans = await db.getSynonymsByWord(editWord.id);
    // List<ReordableElement> orders = [];
    // for (var item in dbmeans) {
    //   orders.add(ReordableElement(
    //       id: 0, name: item.name, translate: item.translatedName, order: 0));
    // }
    final List<ReordableElement> result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ModalShowReordableView(listToView: elements);
    }));

    if (result.isNotEmpty) {
      // toUpdate =
    }
    return result;
  }

  void _showEditMeans(
      BuildContext context, List<ReordableElement> listElements) async {
    Mean? element;
    var result = await _showOrEditReordable(context, listMeans);
    //await db.deleteMeansByWord(editWord);
    for (var (index, item) in result.indexed) {
      if (item.id <= 0) {
        int id = await db.into(db.means).insert(
            MeansCompanion.insert(baseWord: editWord.id, name: item.name));
        element = await db.getMeanByIdOrUuid(id);
        if (element != null) {
          element = element.copyWith(meansOrder: index);
        }
      } else {
        element = Mean(
            id: item.id,
            uuid: item.uuid,
            baseWord: editWord.id,
            name: item.name,
            meansOrder: index);
      }
      if (element != null) {
        await db.update(db.means).replace(element);
      }
    }
    if (result.isNotEmpty) {
      var toUpdate = editWord.copyWith(mean: result[0].name);
      db.updateWord(toUpdate);
    }
    // fillControllers(editWord);
    await setBaseSettings();
    setState(() {});
  }
}
