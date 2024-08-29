import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/widgets/modal_show_reordable_view.dart';

class ReordableListView extends StatelessWidget {
  final List<Widget> listChildren;

  const ReordableListView({Key? key, required this.listChildren}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: listChildren,
      ),
      floatingActionButton: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
    );
  }
}
