import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:image_picker/image_picker.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';

class ImageToText extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const ImageToText({super.key, required this.db, required this.talker});

  @override
  ImageToTextState createState() => ImageToTextState();
}

class ImageToTextState extends State<ImageToText> {
  List<String> wordsInImage = [];
  List<String> lines = [];
  List<String> transLines = [];

  XFile? _image;
  final picker = ImagePicker();
  late DbHelper db;
  String s = "";
  @override
  void initState() {
    db = widget.db;
    super.initState();
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      String a = await getImageTotext(_image!.path);

      await openAddWidgets(a);
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
    setState(() {});
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      String a = await getImageTotext(_image!.path);
      // lines = a.split("\n");
      await openAddWidgets(a);

      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  Widget _addListTitle(String title) {
    return ListTile(
        // leading: item.synonymWord > 0
        //     ? const CircleAvatar(
        //         backgroundColor: Colors.red,
        //         child: Icon(Icons.keyboard_arrow_right),
        //       )
        //     : Container(),
        title: Text(title),
        // subtitle: Text(description),
        trailing: IconButton(
            onPressed: () {
              // addNewWordFromSynonym(item);
            },
            icon: const Icon(Icons.do_disturb)),
        onTap: () async {
          navigateToDetail(
              Word(
                  id: -99,
                  uuid: "",
                  name: title,
                  description: "",
                  important: "",
                  mean: "",
                  baseForm: "",
                  baseLang: 0,
                  rootWordID: 0),
              "Add word ");
        });
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(
        wordToEdit,
        title,
        db,
        talker: widget.talker,
      );
    }));
    if (result) {}
  }

  List<Widget> listLinesExpansionTile(List<String> lines) {
    RegExp exp = RegExp(r'([a-zA-ZÄÖÜäöüß]+)');

    List<Widget> result = [];
    for (var (index, line) in lines.indexed) {
      List<Widget> listChildren = [];
      String transLine = "";

      if (transLines.length >= index) {
        transLine = transLines[index];
      }

      Iterable<RegExpMatch> matches = exp.allMatches(line);

      for (var match in matches) {
        String word = match[1].toString();
        if (word.length > 3) {
          listChildren.add(_addListTitle(word));
        }
      }
      var expansion = ExpansionTile(
        title: Text(line),
        subtitle: Text(transLine),
        initiallyExpanded: false,
        trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // addNewWords(listChildren).then((value) => null);
              setState(() {});
            }),
        children: listChildren,
      );
      result.add(expansion);
    }

    return result;
  }

  Future<bool> addNewWords(List<Widget> listWords) async {
    // for (var item in listWords) {
    //   var leipz = LeipzigWord(item.title as Text).toString(), db);
    //   var newWord = await leipz.addNewWord(
    //       leipz.name,
    //       Word(
    //           id: 0,
    //           uuid: "",
    //           name: leipz.name,
    //           description: "",
    //           mean: "",
    //           baseForm: "",
    //           baseLang: 0,
    //           rootWordID: 0));
    // }
    return true;
  }

  Future openAddWidgets(String data) async {
    lines = data.split("\n");
    var translator = LeipzigTranslator(db: db);
    for (var line in lines) {
      transLines.add(await translator.translate(line));
    }

    setState(() {});
  }

  Future showOptions(BuildContext context) async {
    // openAddWidgets('''Dezember 2021 zum neunten Bundeskanzler
    // der Bundesrepublik Deutschland gewählt und anschließend
    // vom Bundespräsidenten ernannt.''');
    // return;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(15.0),
        children: [
          Column(children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showOptions(context).then((value) => null);
                  },

                  // onTap: () async {
                  //   final XFile? image =
                  //       await _picker.pickImage(source: ImageSource.);
                  //   String a = await getImageTotext(image!.path);
                  //
                  //   setState(() {
                  //     s = a;
                  //   });
                  //),
                  child: Center(
                    child: _image == null
                        ? const Icon(
                            Icons.file_copy,
                          )
                        : Image.file(File(_image!.path)),
                  ),
                ),
              ),
            ),
            Text(
              s,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            SingleChildScrollView(
              child: Column(
                children: listLinesExpansionTile(lines),
              ),
            ),
          ])
        ],
      ),
    );
  }

  Future getImageTotext(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    var image = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    String text = recognizedText.text.toString();
    return text;
  }
}
