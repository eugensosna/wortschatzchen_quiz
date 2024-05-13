import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:image_picker/image_picker.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  _ImageToTextState createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  final ImagePicker _picker = ImagePicker();
  String s = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: 250,
            child: Center(
              child: GestureDetector(
                  onTap: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    String a = await getImageTotext(image!.path);
                    setState(() {
                      s = a;
                    });
                  },
                  child: const Icon(
                    Icons.file_copy,
                  )),
            ),
          ),
          Text(
            s,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
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
