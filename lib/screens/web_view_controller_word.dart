import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class WebViewControllerWord extends StatefulWidget {
  final Word editWord;
  final String title;
  const WebViewControllerWord({super.key, required this.editWord, required this.title});

  @override
  _WebViewControllerWordState createState() =>
      _WebViewControllerWordState(editWord, appBarText: title);
}

class _WebViewControllerWordState extends State<WebViewControllerWord> {
  final Word editWord;
  final String appBarText;
  final contoler = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

  _WebViewControllerWordState(this.editWord, {required this.appBarText});
  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse("https://www.verbformen.de/?w=$appBarText");
    return Scaffold(
      appBar: AppBar(
          title: Text(appBarText),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen();
            },
          )),
      body: WebViewWidget(
        controller: contoler..loadRequest(uri),
      ),
    );
  }

  void moveToLastScreen() async {
    Navigator.pop(context, false);
    //Navigator.pop(context, true);
  }
}
