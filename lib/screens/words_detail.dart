import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:talker/talker.dart';
import 'package:translator/translator.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
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
  bool isLoadFast = false;
  String semantic = "";

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
  double _progress = 0;

  fillSimpleTranslations(String input, Word editWord) async {
    widget.talker.info("libre translator start  $input");

    // final lt = SimplyTranslator(EngineType.libre);
    widget.talker.verbose("libre save to base $input");

    setState(() {
      isLoadFast = true;
      _progress = 0.1;
      semantic = "save to base";
    });
    widget.talker.verbose("libre save to base $input");
    editWord = await saveWord();

    final st = SimplyTranslator(EngineType.google);
 
    st.setSimplyInstance = "simplytranslate.pussthecat.org";
    var eipzTranslator = LeipzigTranslator(db: db);
    eipzTranslator.updateLanguagesData();
    _progress += 0.2;
    widget.talker.verbose("start Internet $input");

    setState(() {
      _progress += 0.2;
      semantic = "start Internet";
    });
    List<String> stringMeans = [];

    /// get the list with instances
    try {
      final translated = await st.translateSimply(input,
          from: inputLanguage,
          to: outputLanguage,
          instanceMode: InstanceMode.Random);
      widget.talker.info(translated.translations.text);
      descriptionController.text =
          encodeToHumanText(translated.translations.text);

      widget.talker.verbose("libre end Internet $input");

      if (translated.translations.definitions.isNotEmpty) {
        for (var item in translated.translations.definitions) {
          stringMeans.add(encodeToHumanText(item.definition));
        }
      }
    } catch (e) {
      widget.talker.error(" fillSimpleTranslations ", e);
    }
    widget.talker.verbose("libre save Means");

    setState(() {
      semantic = "save Means";
      _progress = 0.7;
    });
    try {
      if (stringMeans.isNotEmpty) {
        await Provider.of<AppDataProvider>(context, listen: false)
            .addMeansToBase(stringMeans, editWord);
      }
      editWord = await db.getWordById(editWord.id) ?? editWord;
    } catch (e) {
      widget.talker.error(" fillSimpleTranslations write means ", e);
    }
    widget.talker.verbose(" fillSimpleTranslations write means ");

    setState(() {
      _progress = 0.9;
    });
    if (descriptionController.text.isNotEmpty) {
      var toUpdate = editWord.copyWith(description: descriptionController.text);
      editWord = await db.updateWord(toUpdate);
      // editWord = toUpdate;
    }

    widget.talker.verbose("libre translator end $input");
    await setBaseSettings(editWord);
    setState(() {
      isLoadFast = true;
      _progress = 1.0;
    });
    widget.talker.verbose("libre translator setbasesettinngs");

    Provider.of<AppDataProvider>(context, listen: false).translateNeededWords();
    setState(() {
      isLoadFast = false;
      _progress = 0;
    });
    _fillData();
  }

  Future<String> translateText(String inputText) async {
    var translator = LeipzigTranslator(
        db: db, inputLanguage: inputLanguage, outputLanguage: outputLanguage);

    // result = translated.translations.text.toString();

    try {
      final translated = await translator.translate(inputText);

      return translated;
    } catch (e) {
      widget.talker.error(" detail translateText $inputText", e);
    }

    // ignore: control_flow_in_finally
    return "";
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
      setBaseSettings(editWord).then((value) {});
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

  setBaseSettings(Word editWord, {bool falseRecursion = false}) async {
    if (editWord.id > 0) {
      var editWordUpdated = await db.getWordById(editWord.id);
      if (editWordUpdated != null) {
        editWord = editWordUpdated;
      }
    }

    if (editWord.baseLang > 0) {
      var baseLangOrNull = (await db.getLangById(editWord.baseLang));
      if (baseLangOrNull != null) {
        baseLang = baseLangOrNull;
      }
    } else {
      var baseLangOrNull = await db.getLangByShortName("de");
      if (baseLangOrNull == null) {
        int id = (await db.into(db.languages).insert(
            LanguagesCompanion.insert(name: "German", shortName: "de")));
        baseLangOrNull = (await db.getLangById(id));
        if (baseLangOrNull != null) {
          baseLang = baseLangOrNull;
        }
      }
    }

    listSessions = await _getListSessions();
    currentWordSession = await _getWordSession(editWord);

    if (editWord.name.isNotEmpty && editWord.id > 0) {
      editWord = await db.getWordById(editWord.id) ?? editWord;
      listSynonyms = await db.getSynonymsByWord(editWord.id);
      listExamples = await db.getExamplesByWord(editWord.id);
      listMeans = await db.getMeansByWord(editWord.id);

      var data = await db.getLeipzigDataByWord(editWord);
      if (data != null) {
        article = data.article;
        baseWord = data.wordOfBase;
      }
      Future.delayed(const Duration(milliseconds: 200)).then(
        (value) {
          setState(() {});
        },
      );
    } else {
      if (editWord.name.isNotEmpty && editWord.id < 0 && !falseRecursion) {
        // fillControllers(editWord);
        if (editWord.description.isEmpty) {
          descriptionController.text = await translateText(editWord.name);
          saveWord().then(
            (value) {
              editWord = value;

              fillSimpleTranslations(value.name, value).then(
                (value) async {
                  editWord = await db.getWordById(editWord.id) ?? editWord;
                  await setBaseSettings(editWord, falseRecursion: true);
                  fillControllers(editWord);

                  setState(() {});
                },
              );
            },
          );
        }
      }
    }

    fillControllers(editWord);

    // return "Ok";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.displaySmall;

    var textToAppBar = appBarText;
    if (editWord.baseForm.isNotEmpty) {
      textToAppBar = "$textToAppBar ${editWord.baseForm}";
    }

    return PopScope(
        canPop: true,
        onPopInvoked: (_) async {
          await saveWord();
          // moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(textToAppBar),
            leading: buttonBack(),
            actions: [
              buttonBack() ?? Container(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onEditingComplete: () {
                        if (editWord.name.isEmpty &&
                            titleController.text.isNotEmpty) {
                          fillSimpleTranslations(
                              titleController.text, editWord);
                        }
                      },
                      decoration: InputDecoration(
                          label: const Text('Title'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)))),
                ),
                editWord.baseForm.isNotEmpty
                    ? InkWell(
                        child: Text(
                          "Base form :${editWord.baseForm}",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          viewWord(editWord.baseForm);
                        },
                      )
                    : Container(
                        height: 2,
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
                  decoration: InputDecoration(
                      label: Text("Mean"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _showEditMeans(context, listMeans);
                          },
                          icon: Icon(Icons.account_tree_rounded))),
                  onTap: () {
                   
                  },
                ),
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
                        ? CircularProgressIndicator(
                            value: _progress,
                          )
                        : TextButton(
                            onPressed: _fillData,
                            child: const Text("Full"),
                          ),
                    IconButton(onPressed: saveWord, icon: const Icon(Icons.save)), //Save button
                    IconButton(
                        onPressed: goToVerbForm,
                        icon: const Icon(Icons.add_task)),

                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoadFast = true;
                          });
                          fillSimpleTranslations(
                              titleController.text, editWord);
                        },
                        child: const Text("Fast")),
                    isLoadFast
                        ? CircularProgressIndicator(
                            value: _progress,
                            semanticsValue: "Download $_progress*100",
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          )
                        : Container(),
                  ],
                ),
                isLoading || isLoadFast
                    ? LinearProgressIndicator(
                        value: _progress,
                        minHeight: 5,
                        semanticsLabel: semantic,
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }

  Widget? buttonBack() {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          moveToLastScreen();
        });
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

          setBaseSettings(editWord).then((onValue) {
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
    Word result;

    editWord = await db.getWordById(editWord.id) ?? editWord;
    editWord = editWord.copyWith(
        name: titleController.text,
        description: descriptionController.text,
        mean: meanController.text,
        important: importantController.text);
    if (editWord.id > 0) {
      result = await updateWordIfNeed(editWord);
    } else {
      result = await addWord();
    }
    Provider.of<AppDataProvider>(context, listen: false).updateAll();
    return result;
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
      title: Text("Examples: $titleList"),
      subtitle: Text(translatedList),
      initiallyExpanded: false,
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          var result = await _showOrEditReordable(context, listExamples);
          await _saveToExamples(result);
          setState(() {
            // isLoading = true;
          });

          db.getSynonymsByWord(editWord.id).then((value) {
            listSynonyms = value;
            // setState(() {
            //   isLoading = false;
            // });
            db.getExamplesByWord(editWord.id).then((onValue) {
              listExamples = onValue;
              // setState(() {
              // isLoading = false;
              // });
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
            // isLoading = true;
          });
          // for (var synItem in listSynonyms) {
          //   if (synItem.synonymWord == 0) {
          //     addNewWordWithAllData(synItem.name, editWord);
          //   }
          // }
          db.getSynonymsByWord(editWord.id).then((value) {
            listSynonyms = value;
            // setState(() {
            //   isLoading = false;
            // });
            db.getExamplesByWord(editWord.id).then((onValue) {
              listExamples = onValue;
              // setState(() {
              //   isLoading = false;
              // });
            });
          });
        },
      ),
      children: listChildren,
    );
  }

  Future<String> _fillData() async {
    widget.talker.info("_fillData STart");
    setState(() {
      isLoading = true;
      _progress = 0.1;
    });
    if (descriptionController.text.isEmpty) {
      descriptionController.text = await translateText(titleController.text);
    }

    _addUpdateWord().then((value) {
      widget.talker.info("_fillData End");
      if (value != null) {
        setBaseSettings(value);
        setState(() {
          editWord = value;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
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
  }

  Future<Word> updateWordIfNeed(Word wordToUpdate) async {
    if (!context.mounted) {
      return editWord;
    }
    var db = Provider.of<AppDataProvider>(context, listen: false).db;
    var provider = Provider.of<AppDataProvider>(context, listen: false);

    if (wordToUpdate.id <= 0) {
      throw "its now existed Word , you shold save befor update ";
    } else {
      var isChanched = true;

      Word toUpdate = wordToUpdate.copyWith();
      if (toUpdate.mean.isNotEmpty) {
        var translator =
            provider.translator;
        var meanRow = await db.getMeanByNameAndWord(toUpdate.mean, toUpdate.id);
        if (meanRow == null) {
          int id = await db
              .into(db.means)
              .insert(MeansCompanion.insert(baseWord: toUpdate.id, name: toUpdate.mean));
          meanRow = await db.getMeanByIdOrUuid(id);
          if (meanRow != null) {
            var meanToUpdate = meanRow.copyWith(meansOrder: 1);
            await db.update(db.means).replace(meanToUpdate);
          }
        }


        var translatedMean = await db.getTranslateString(
            toUpdate.mean, toUpdate.baseLang, translator.targetLanguage!.id);
        if (translatedMean.isEmpty) {
          await db.into(db.translatedWords).insert(
              TranslatedWordsCompanion.insert(
                  baseLang: toUpdate.baseLang,
                  targetLang: translator.targetLanguage!.id,
                  name: toUpdate.mean,
                  translatedName: ""));
            
        }
      }

      if (isChanched) {
        wordToUpdate = await db.updateWord(toUpdate);
      }
    }
    return wordToUpdate;
  }

  Future<Word> addWord() async {
    var word = await addNewWord(titleController.text, editWord);
    editWord = word!;

    descriptionController.text = editWord.description;
    setBaseSettings(editWord, falseRecursion: true);
    setState(() {});
    return editWord;
  }

  Future<Word?> _addUpdateWord() async {
    editWord = await saveWord();
    var leipzigSynonyms = LeipzigWord(editWord.name, db, widget.talker);
    leipzigSynonyms.talker
        .warning("start _addUpdateWord- getFromInternet ${editWord.name}");

    try {
      var leipzigTempWord = await leipzigSynonyms.getParseAllDataSpeed(
          leipzigSynonyms, editWord,
          _progressbar, Provider.of<AppDataProvider>(context, listen: false));
      // await leipzigSynonyms.parseRawHtmlData(editWord.name);
      leipzigSynonyms.talker
          .warning("end _addUpdateWord- getFromInternet ${editWord.name}");
    } on Exception catch (e) {
      widget.talker.error("get data from Internet ${editWord.name}", e);
    }

    // var baseForm = leipzigSynonyms.baseWord;
    // leipzigSynonyms.talker
    //     .warning("start _addUpdateWord- updateDataDB $baseForm");

    // await leipzigSynonyms.updateDataDB(leipzigSynonyms, db, editWord);
    leipzigSynonyms.translateNeededWords();
    await setBaseSettings(editWord);

    listSynonyms = await db.getSynonymsByWord(editWord.id);
    listExamples = await db.getExamplesByWord(editWord.id);
    editWord = (await db.getWordById(editWord.id))!;
    return editWord;
  }

  void moveToLastScreen() async {
    if (titleController.text.isEmpty) {
      Navigator.pop(context, editWord);

      return;
    } else {
      Navigator.pop(context, editWord);
    }
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, db, talker: widget.talker);
    }));
    if (result != null) {}
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

  _progressbar(double progress) async {
    setState(() {
      _progress = progress;
    });
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

      leipzigSynonyms = await leipzigSynonyms.getParseAllDataSpeed(
          leipzigSynonyms, editWord,
          _progressbar, Provider.of<AppDataProvider>(context, listen: false));
      
      leipzigSynonyms.translateNeededWords();
      await setBaseSettings(newWord);
      setState(() {});
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
      widget.talker.debug("go to verbform ${editWord.name}");
      return WebViewControllerWord(editWord: editWord, title: editWord.name);
    }));
    if (result) {
      setState(() {});
    }
  }

  _saveToExamples(List<ReordableElement>? elements) async {
    Example? elemExamples;
    if (elements == null) {
      return;
    }
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
    await setBaseSettings(editWord);
    setState(() {});
  }

  Future<List<ReordableElement>>? _showOrEditReordable(
      BuildContext context, List<ReordableElement> elements) async {
    // var dbmeans = await db.getSynonymsByWord(editWord.id);
    // List<ReordableElement> orders = [];
    // for (var item in dbmeans) {
    //   orders.add(ReordableElement(
    //       id: 0, name: item.name, translate: item.translatedName, order: 0));
    // }
    var result =
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
    result ??= listElements;
    //await db.deleteMeansByWord(editWord);
    for (var (index, item) in result.indexed) {
      if (item.id <= 0) {
        int id = await db.into(db.means).insert(
            MeansCompanion.insert(baseWord: editWord.id, name: item.name));
        element = await db.getMeanByIdOrUuid(id);
        
        
        if (element != null) {
          element = element.copyWith(meansOrder: index);
          item.id = id;
          item.uuid = element.uuid;
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
    if (result.isNotEmpty && meanController.text != result[0].name) {
      meanController.text = result[0].name;
      var toUpdate = editWord.copyWith(mean: result[0].name);
      editWord = await db.updateWord(toUpdate);
      
    }
    // fillControllers(editWord);
    await setBaseSettings(editWord);
    setState(() {});
  }
}
