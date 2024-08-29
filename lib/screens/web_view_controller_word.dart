import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wortschatzchen_quiz/db/db.dart';

class WebViewControllerWord extends StatefulWidget {
  final Word editWord;
  final String baseUri; 
  final String title;
  const WebViewControllerWord(
      {super.key,
      required this.editWord,
      required this.title,
      this.baseUri = "https://www.verbformen.de/?w="});

  @override
  WebViewControllerWordState createState() => WebViewControllerWordState();
}

class WebViewControllerWordState extends State<WebViewControllerWord> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  // WebViewControllerWordState();
  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse("${widget.baseUri}${widget.title}");
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen();
            },
          )),
      body: WebViewWidget(
        controller: controller..loadRequest(uri),
      ),
    );
  }

  void moveToLastScreen() async {
    Navigator.pop(context, false);
    //Navigator.pop(context, true);
  }
}
