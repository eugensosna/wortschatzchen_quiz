import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';
import 'package:wortschatzchen_quiz/screens/quiz/answer.dart';

class ActiveQuizCard extends StatefulWidget {
  final QuizCard card;
  final Answer answer;
  final bool isDraggable;
  final Function onSlideOutComplete;
  const ActiveQuizCard(
      {super.key,
      required this.card,
      required this.answer,
      required this.isDraggable,
      required this.onSlideOutComplete});

  @override
  State<ActiveQuizCard> createState() => _ActiveQuizCardState();
}

class _ActiveQuizCardState extends State<ActiveQuizCard>
    with TickerProviderStateMixin {
  GlobalKey cardKey = GlobalKey(debugLabel: 'card_key');
  Offset? cardOffset = Offset(0.0, 0.0);
  Offset? dragStart;
  Offset? dragPosition;
  Offset? slideCardBack;
  AnimationController? slideCardBackController;
  Tween<Offset>? slideOutTween;
  AnimationController? slideOutController;
  UserAnswer? userAnswer;
  bool isShowingAnswer = false;

  @override
  void initState() {
    super.initState();
    slideCardBackController = AnimationController(
      // vsync: this,
      duration: Duration(milliseconds: 1000), vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideCardBack, const Offset(0.0, 0.0),
                Curves.elasticInOut.transform(slideCardBackController!.value));
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideCardBack = null;
          });
        }
      });

    slideOutController = AnimationController(
      // vsync: this,
      duration: Duration(milliseconds: 500), vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween?.evaluate(slideOutController!);
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(
                  // TODO: slideDirection
                  );
            }
          });
        }
      });

    widget.answer.addListener(onAnswerChange);
    userAnswer = widget.answer.userAnswer;
  }

  @override
  void dispose() {
    widget.answer.removeListener(onAnswerChange);
    slideCardBackController!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ActiveQuizCard oldWidget) {
    if (oldWidget.isDraggable != widget.isDraggable) {
      oldWidget.answer.removeListener(onAnswerChange);
      widget.answer.addListener(onAnswerChange);
      userAnswer = widget.answer.userAnswer;
      print(userAnswer);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return draggableCard(widget.card);
  }

  Widget draggableCard(QuizCard card) {
    Size screenSize = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.translationValues(cardOffset!.dx, cardOffset!.dy, 0.0)
        ..rotateZ(_rotation(screenSize)),
      origin: _rotationOrigin(screenSize),
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: _flipCard,
        child: Card(
          key: cardKey,
          color: isShowingAnswer ? Colors.pink : Colors.deepPurple[800],
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(
                color: Colors.white,
                style: BorderStyle.solid,
                width: 4,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenSize.height / 2.0,
              alignment: Alignment.center,
              child: 
                  Text(
                    isShowingAnswer ? "${card.answer}" : "${card.question}",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )

              ),
            ),
          ),
        ),
    );
  }

  // Events
  Offset chooseRandomPosition() {
    final cardContext = cardKey.currentContext;
    final cardTopLeft = (cardContext?.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        (cardContext!.size!.height * (Random().nextDouble())) +
            cardTopLeft.dy;
    return Offset(cardContext.size!.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void swipeRight() {
    double screenWidth = MediaQuery.of(context).size.width;
    dragStart = chooseRandomPosition();
    slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: Offset(2 * screenWidth, 0.0));
    slideOutController?.forward(from: 0.0);
  }

  void swipeLeft() {
    double screenWidth = MediaQuery.of(context).size.width;
    dragStart = chooseRandomPosition();
    slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: Offset(-2 * screenWidth, 0.0));
    slideOutController?.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideCardBackController!.isAnimating) {
      setState(() {
        slideCardBackController!.stop(canceled: true);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = (dragPosition! - dragStart!);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset! / cardOffset!.distance;
    final isInCorrect = (cardOffset!.dx / context.size!.width) < -0.45;
    final isCorrect = (cardOffset!.dx / context.size!.width) > 0.45;

    setState(() {
      if (isInCorrect || isCorrect) {
        slideOutTween = Tween(
          begin: cardOffset,
          end: dragVector * (2 * context.size!.width),
        );
        slideOutController!.forward(from: 0.0);
      } else {
        slideCardBack = cardOffset;
        slideCardBackController!.forward(from: 0.0);
      }
    });
  }

  void _flipCard() {
    setState(() {
      isShowingAnswer = !isShowingAnswer;
    });
  }

  double _rotation(dragBounds) {
    if (dragStart != null) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      int rotationCornerMultiplier = dragStart!.dy >= screenHeight / 2 ? -1 : 1;
      return (pi / 8) *
          (cardOffset!.dx / screenWidth) *
          rotationCornerMultiplier;
    } else
      return 0.0;
  }

  Offset? _rotationOrigin(dragBounds) =>
      dragStart != null ? dragStart : const Offset(0.0, 0.0);

  void onAnswerChange() {
    if (widget.isDraggable) {
      print("Hi");
      if (widget.answer.userAnswer != userAnswer) {
        switch (widget.answer.userAnswer) {
          case UserAnswer.correct:
            swipeRight();
            break;
          case UserAnswer.incorrect:
            swipeLeft();
            break;
          default:
            break;
        }
      }
    }
  }
}
