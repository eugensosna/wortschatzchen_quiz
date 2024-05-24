import 'package:flutter/material.dart';
import 'package:webview_universal/webview_universal.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class WebViewControllerWord extends StatefulWidget {
  final Word editWord;
  final String title;
  const WebViewControllerWord(
      {super.key, required this.editWord, required this.title});

  @override
  _WebViewControllerWordState createState() =>
      _WebViewControllerWordState(editWord, appBarText: title);
}

class _WebViewControllerWordState extends State<WebViewControllerWord> {
  final Word editWord;
  final String appBarText;
  final controller = WebViewController();

  _WebViewControllerWordState(this.editWord, {required this.appBarText});
  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse("https://www.verbformen.de/?w=$appBarText");
    controller.init(context: context, setState: setState, uri: uri);
    return Scaffold(
      appBar: AppBar(
          title: Text(appBarText),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen();
            },
          )),
      body: WebView(
        controller: controller,
      ),
    );
  }

  void moveToLastScreen() async {
    Navigator.pop(context, false);
    //Navigator.pop(context, true);
  }
}
