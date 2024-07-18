import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/WordMvc.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  late DbHelper db;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
            child: const Text("Import words from json "),
            onPressed: () {
              exportToJson(context);
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
        var leipzigTempWord =
            await leipzigSynonyms.getParseAllData(
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void exportToJson(BuildContext context) async {
    Map<String, dynamic> resultJson = {}; 
    Map<String, dynamic> resultExport = {};
    var talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var dbInto = Provider.of<AppDataProvider>(context, listen: false).db;
      File file = File(result.files.single.path!);
      var dbToImport = DbHelper(pathToFile: file.path);
      var lwords = await dbInto.getOrdersWordList();
      List<dynamic> words = [];
      for (var item in lwords) {
        var elem = await WordMvc.read(db, Provider.of<AppDataProvider>(context, listen: false),
            uuid: item.uuid);
        words.add(elem.toJson());
      }
      resultJson["words"] = words;
    }
    
  }
}
