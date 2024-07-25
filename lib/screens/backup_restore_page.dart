import 'dart:convert';
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' as nativewrappers;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/WordMvc.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  late DbHelper db;

  bool isLoading = false;
  double _progress = 0;
  String semanticValue = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = Provider.of<AppDataProvider>(context, listen: false).db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup, Restore"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
            width: 40,
          ),
          ElevatedButton(
            child: const Text("Save DB"),
            onPressed: () {
              saveDB();
            },
          ),
          ElevatedButton(
            child: const Text("Load DB"),
            onPressed: () {
              loadDB();
            },
          ),
          Container(
            child: const SizedBox(
              width: 50,
              height: 60,
            ),
          ),
          ElevatedButton(
            child: const Text("Fill data words"),
            onPressed: () {
              _fillWords();
            },
          ),
          ElevatedButton(
              child: const Text("Export words to json "),
              onPressed: () {
                exportToJson(context);
              }),
          isLoading
              ? Stack(
                  children: [
                    Container(
                      height: 20,
                      child: LinearProgressIndicator(
                        value: _progress,
                        semanticsValue: semanticValue,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    Align(
                      child: Text(semanticValue),
                      alignment: Alignment.topCenter,
                    )
                  ],
                )
              : ElevatedButton(
                  child: const Text("Import data from json "),
                  onPressed: () {
                    importFromJson(context);
                  },
                ),
        ],
      ),
    );
  }

  loadDB() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> bytes = file.readAsBytesSync();
      final fileDB = await db.getDataFilePath();
      await saveFileLocally(fileDB, bytes);
      // await fileDB.writeAsBytes(bytes);
      SystemNavigator.pop();
    }
  }

  saveDB() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      showMessage("need select directory to save ");
      return;
    }

    var dbpath = await db.getDataFilePath();
    List<int> bytes = File(dbpath).readAsBytesSync();

    String path = ppath.join(selectedDirectory, "worts.sqlite");

    saveFileLocally(path, bytes).then((onValue) {
      showMessage("saved $path");
    });
  }

  Future<void> saveFileLocally(String path, List<int> bytes) async {
    Directory? directory = await getDownloadsDirectory();

    File file = File(path);

    await file.writeAsBytes(bytes);

    showMessage("File saved at $path");
  }

  void _fillWords() async {
    var talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    var listWords = await db.getOrdersWordList();
    for (var (index, editWord) in listWords.indexed) {
      if (editWord.mean.isNotEmpty || editWord.description.isEmpty) {
        continue;
      }
      await db.deleteExamplesByWord(editWord);
      await db.deleteMeansByWord(editWord);
      await db.deleteSynonymsByWord(editWord);
      var leipzigSynonyms = LeipzigWord(editWord.name, db, talker);
      leipzigSynonyms.serviceMode = true;
      try {
        var leipzigTempWord = await leipzigSynonyms.getParseAllData(
          leipzigSynonyms,
          editWord,
          Provider.of<AppDataProvider>(context, listen: false),
        );
        talker.info(" parsed ${editWord.name}");
      } catch (e) {
        talker.error("error parse ${editWord.name}", e);
      }
      if (index % 10 == 1) {
        showMessage("$index from ${listWords.length}");
      }
    }
    showMessage("refill data");
  }

  showMessage(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void importFromJson(BuildContext context) async {
    isLoading = true;
    var talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var provider = Provider.of<AppDataProvider>(context, listen: false);
    var db = Provider.of<AppDataProvider>(context, listen: false).db;
    if (result != null) {
      File file = File(result.files.single.path!);
      // Read the file
      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      var baseWord = WordMvc(db, provider, 0, '', '');
      if (jsonMap.containsKey("words")) {
        int sumLength = jsonMap['words'].length;
        var index = 0;
        sumLength = sumLength * 2;
        for (var element in jsonMap['words']) {
          index += 1;
          try {
            talker.verbose("start ${element["name"]}");
            var word = baseWord.fromJson(element, provider);
            semanticValue = word.name;
            var savedword = await word.save();
            String formatted = getDefaultSessionName();

            if (savedword != null) {
              await db
                  .into(db.sessions)
                  .insert(SessionsCompanion.insert(baseWord: savedword.id, typesession: formatted));
            }
            talker.verbose("end ${element["name"]}");

          } on Exception catch (e) {
            print(e);
            // TODO
          }
          _progress = index / sumLength;
          setState(() {
            _progress = index / sumLength;
          });
        }
      }
      if (jsonMap.containsKey("quiz")) {
        int sumLength = jsonMap['quiz'].length;
        var index = sumLength;
        sumLength = sumLength * 2;
        for (var element in jsonMap['quiz']) {
          var deck = Deck.fromJson(element);
          await deck.save(provider);
          index += 1;

          semanticValue = element["deckTitle"];
          _progress = index / sumLength;
          setState(() {
            _progress = index / sumLength;
          });
        }
      }
      setState(() {
        isLoading = false;
      });

      showMessage("Load endet  ");
    }
  }

  void exportToJson(BuildContext context) async {
    Map<String, dynamic> resultJson = {};
    Map<String, dynamic> resultExport = {};
    var talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    String? result = await FilePicker.platform.saveFile();
    if (result != null) {
      List<Word> wordsToExport = [];
      if (context.mounted) {
        await exportWords(context, resultJson);
        await exportQuiz(context, resultJson);
      }
      await writeJsonToFile(resultJson, result);
      showMessage("Saved to ${result}");
    }
  }

  Future<void> exportQuiz(BuildContext context, Map<String, dynamic> resultJson) async {
    var dbInto = Provider.of<AppDataProvider>(context, listen: false).db;
    // File file = File(result);
    // var dbToImport = DbHelper(pathToFile: file.path);
    var quizGroups = await db.getQuestions();
    List<dynamic> resultList = [];
    for (var item in quizGroups) {
      resultList.add(item.toJson());
    }
    resultJson["quiz"] = resultList;
  }

  Future<void> exportWords(BuildContext context, Map<String, dynamic> resultJson) async {
    var dbInto = Provider.of<AppDataProvider>(context, listen: false).db;
    var provider = Provider.of<AppDataProvider>(context, listen: false);
    // File file = File(result);
    // var dbToImport = DbHelper(pathToFile: file.path);
    var lwords = await dbInto.getOrdersWordList();
    List<dynamic> words = [];
    for (var item in lwords) {
      var elem = await WordMvc.read(provider, uuid: item.uuid);
      words.add(elem.toJson());
    }
    resultJson["words"] = words;
  }

  Future<void> writeJsonToFile(Map<String, dynamic> jsonMap, String filePath) async {
    // Convert the map to a JSON string
    String jsonString = jsonEncode(jsonMap);

    // Get the path to the app's document directory
    // final directory = await getApplicationDocumentsDirectory();
    final file = File(filePath);

    // Write the JSON string to the file
    await file.writeAsString(jsonString);
  }
}
