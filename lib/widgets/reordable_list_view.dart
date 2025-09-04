import 'package:flutter/material.dart';

class ReordableListView extends StatelessWidget {
  final List<Widget> listChildren;

  const ReordableListView({super.key, required this.listChildren});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: listChildren,
      ),
      floatingActionButton: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
    );
  }
}
