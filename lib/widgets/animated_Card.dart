import 'dart:math';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/screens/words_detail.dart';

class AnimatedCard extends StatefulWidget {
  final Word editWord;
  final DbHelper db;
  final Talker talker;
  const AnimatedCard({
    super.key,
    required this.editWord,
    required this.db,
    required this.talker,
  });

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  int transparentId = -1;
  List<ReordableElement> means = [];

  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
    updateHelpData();
  }

  void updateHelpData() async {
    means = await widget.db.getMeansByWord(widget.editWord.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: transparentId <= 0 ? getFrontWidget() : getBackWidget(),
      ),
      //  Transform(
      //   alignment: FractionalOffset.center,

      //   transform: Matrix4.identity()
      //     ..setEntry(3, 2, 0.0015)
      //     ..rotateY(pi * _animation.value),
      //   child: Card(
      //     child: _animation.value <= 0.5 ? getFrontWidget() : getBackWidget(),
      //   ),
      // ),

      //  Card(
      //     child: Text(
      //         "${widget.editWord.important},${widget.editWord.name} \n${widget.editWord.mean}\n ${widget.editWord.description}"),
      //   ),
      onDoubleTap: () {
        navigateToDetail(widget.editWord, "View");
      },
      onTap: () {
        print("tap");

        if (transparentId < 0) {
          transparentId = 1;
        } else {
          transparentId = -1;
        }

        if (_status == AnimationStatus.dismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }

        setState(() {
          // transparentId = widget.editWord.id;
        });
      },
    );
  }

  Future<void> navigateToDetail(Word wordToEdit, String title) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WordsDetail(wordToEdit, title, widget.db, talker: widget.talker);
    }));
    updateHelpData();
  }

  Container getBackWidget() {
    List<ReordableElement> localMeans = [];
    if (means.isNotEmpty) {
      int minElements = min(means.length, 3);
      localMeans = means.sublist(0, minElements);
    }

    return Container(
      color: Colors.grey,
      child: ListView.builder(
        itemCount: localMeans.length,
        itemBuilder: (context, index) {
          var item = localMeans.elementAt(index);
          return ListTile(
            subtitle: Text(item.translate),
            title: Text(item.name),
            isThreeLine: true,
          );
        },
      ),
    );
  }

  Container getFrontWidget() {
    return Container(
        color: Colors.blue,
        child: widgets.Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "${widget.editWord.name} ",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Text("mean:${widget.editWord.description} "),
            Text("${widget.editWord.mean} "),
          ],
        ));
  }
}
