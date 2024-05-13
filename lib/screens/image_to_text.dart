import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  _ImageToTextState createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  final ImagePicker _picker = ImagePicker();

  List<String> wordsInImage = [];
  List<String> lines = [];

  XFile? _image;
  final picker = ImagePicker();

  String s = "";
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
    //   String a = await getImageTotext(image!.path);

    setState(() {});
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      String a = await getImageTotext(_image!.path);
      lines = a.split("\n");
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
            icon: Icon(Icons.do_disturb)),
        onTap: () async {
          String onTapeString = title;
          Word? wordToEdit;

          navigateToDetail(
              wordToEdit ??
                  Word(
                      id: -99,
                      uuid: "",
                      name: title,
                      description: "",
                      mean: "",
                      baseForm: "",
                      baseLang: 0,
                      rootWordID: 0),
              "Add synonyme ");
        });
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title);
    }));
    if (result) {}
  }

  List<Widget> listLinesExpansionTile(List<String> lines) {
    RegExp exp = RegExp(r'([a-zA-ZÄÖÜäöüß]+)');

    RegExp allWords = RegExp("\w");
    List<Widget> result = [];
    for (var line in lines) {
      List<Widget> listChildren = [];

      Iterable<RegExpMatch> matches = exp.allMatches(line);

      for (var match in matches) {
        listChildren.add(_addListTitle(match[1].toString()));
      }
      var expansion = ExpansionTile(
        title: Text(line),
        // subtitle: Text(titleList),
        initiallyExpanded: false,
        trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              setState(() {});
            }),

        children: listChildren,
      );
      result.add(expansion);
    }

    return result;
  }

  Future openAddWidgets(String data) async {
    lines = data.split("\n");
    setState(() {});
    RegExp exp = RegExp(r'([a-zA-ZÄÖÜäöüß]+)');
    for (var line in lines) {
      Iterable<RegExpMatch> matches = exp.allMatches(line);

      for (var item in matches) {
        print(item);
        print(item[1]);
      }
    }
  }

  Future showOptions() async {
    openAddWidgets('''Herunterlagen 3 wort wörtchen
    kklllkl''');
    return;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
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
      body: Column(children: [
        Container(
          height: 250,
          width: 250,
          child: Center(
            child: GestureDetector(
              onTap: showOptions,

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
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        Expanded(
          child: Column(
            children: listLinesExpansionTile(lines),
          ),
        ),
      ]),
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
