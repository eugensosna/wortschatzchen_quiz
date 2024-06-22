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
              readAndSave();
            },
          ),
          ElevatedButton(
            child: Text("Load"),
            onPressed: () {
              pickUpFile();
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

  pickUpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> bytes = file.readAsBytesSync();
      final fileDB = File(await db.getDataFilePath());
      await fileDB.writeAsBytes(bytes);
      SystemNavigator.pop();
    }
  }

  readAndSave() async {
    var dbpath = await db.getDataFilePath();
    List<int> bytes = File(dbpath).readAsBytesSync();
    saveFileLocally("worts.sqlite", bytes).then((onValue) {
      print("saved");
    });
  }

  Future<void> saveFileLocally(String filename, List<int> bytes) async {
    Directory? directory = await getDownloadsDirectory();

    String path = ppath.join(directory!.path, filename);

    File file = File(path);

    await file.writeAsBytes(bytes);

    print("File saved at $path");
  }

  void _fillWords() async {
    var talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    var listWords = await db.getOrdersWordList();
    for (var editWord in listWords) {
      await db.deleteExamplesByWord(editWord);
      await db.deleteMeansByWord(editWord);
      await db.deleteSynonymsByWord(editWord);
      var leipzigSynonyms = LeipzigWord(editWord.name, db, talker);
      leipzigSynonyms.serviceMode = true;
      var leipzigTempWord =
          await leipzigSynonyms.getParseAllDataSpeed(leipzigSynonyms, editWord);
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Processing Data')));
  }
}
