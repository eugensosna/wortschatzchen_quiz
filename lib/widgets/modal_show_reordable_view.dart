import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';

class ModalShowReordableView extends StatefulWidget {
  final List<ReordableElement> listToView;

  const ModalShowReordableView({Key? key, required this.listToView})
      : super(key: key);

  @override
  State<ModalShowReordableView> createState() => _ModalShowReordableViewState();
}

class _ModalShowReordableViewState extends State<ModalShowReordableView> {
  void moveToLastScreen(BuildContext context) {
    Navigator.pop(context, widget.listToView);
  }

  @override
  Widget build(BuildContext context) {
    //listToView.length;
    return Scaffold(
      appBar: AppBar(
        title: Text("kkkk"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            moveToLastScreen(context);
          },
        ),
      ),
      body: ReorderableListView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < widget.listToView.length; index += 1)
            ListTile(
              key: Key("$index"),
              title: Text("${widget.listToView[index].name}"),
              subtitle: Text("${widget.listToView[index].translate}"),
              // leading: ,
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = widget.listToView.elementAt(oldIndex);
            widget.listToView.removeAt(oldIndex);
            widget.listToView.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Future<String> onSave(BuildContext context) async {
    Navigator.of(context).pop(widget.listToView);
    return "";
  }
}
