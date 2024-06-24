import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  final _formKey = GlobalKey<FormState>();
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
        title: Text("Backup, Restore"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
            width: 40,
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              save();
            },
          ),
          ElevatedButton(
            child: Text("Load"),
            onPressed: () {
              load();
            },
          ),
          Container(
            child: SizedBox(
              width: 50,
              height: 60,
            ),
          ),
          ElevatedButton(
            child: Text("Fill data words"),
            onPressed: () {
              _fillWords();
            },
          ),
        ],
      ),
    );
  }

  load() async {
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

  save() async {
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
    for (var editWord in listWords) {
      if (editWord.mean.isNotEmpty) {
        continue;
      }
      await db.deleteExamplesByWord(editWord);
      await db.deleteMeansByWord(editWord);
      await db.deleteSynonymsByWord(editWord);
      var leipzigSynonyms = LeipzigWord(editWord.name, db, talker);
      leipzigSynonyms.serviceMode = true;
      try {
        var leipzigTempWord =
            await leipzigSynonyms.getParseAllData(leipzigSynonyms, editWord);
        talker.info(" parsed ${editWord.name}");
      } catch (e) {
        talker.error("error parse ${editWord.name}", e);
      }
    }
    showMessage("refill data");
  }

  showMessage(String message) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
