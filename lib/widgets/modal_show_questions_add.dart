import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart' as Db;
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class QuestionsGenerator extends StatefulWidget {
  final Deck QuizGroup;
  final String questionsField;
  final String answerField;

  const QuestionsGenerator(Deck deck,
      {super.key,
      required this.QuizGroup,
      required this.questionsField,
      required this.answerField});

  @override
  State<QuestionsGenerator> createState() => _QuestionsGeneratorState();
}

class _QuestionsGeneratorState extends State<QuestionsGenerator> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<SessionsGroupedByName> listSessions = [];
  List<String> fieldNames = ["mean", "description", "important", "name"];

  TextEditingController descriptionController = TextEditingController();

  TextEditingController translateController = TextEditingController();

  final TextEditingController sessionsController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  List<QuestionCardMarkable> words = [];
  String questionDefault = "";
  String answerDefault = "";

  void moveToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSessions =
        Provider.of<AppDataProvider>(context, listen: false).sessionsByName;

    words = fillBaseWords();
    questionDefault = widget.questionsField;
    answerDefault = widget.answerField;
  }

  List<QuestionCardMarkable> fillBaseWords() {
    return widget.QuizGroup.cards.map((toElement) {
      var elem = QuestionCardMarkable(
          question: toElement.question,
          answer: toElement.answer,
          id: 0,
          example: "");
      elem.mark = false;
      return elem;
    }).toList();
  }

  @override
  void dispose() {
    translateController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //listToView.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate "),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen(context);
            }),
        actions: const [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            //height: MediaQuery.of(context).size.height / 3,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownMenu<String>(
                    helperText: "Session for words ",
                    hintText: "Session",
                    enableFilter: false,
                    enableSearch: true,
                    onSelected: (value) {
                      _generate(value);
                    },
                    controller: sessionsController,
                    dropdownMenuEntries: listSessions.map((toElement) {
                      return DropdownMenuEntry<String>(
                        value: toElement.typesession,
                        label: toElement.typesession,
                      );
                    }).toList()),
                DropdownMenu<String>(
                    helperText: "Question field",
                    hintText: "Question",
                    enableFilter: false,
                    enableSearch: true,
                    initialSelection: questionDefault,
                    onSelected: (value) {
                      _generate(value);
                    },
                    controller: questionController,
                    dropdownMenuEntries: fieldNames.map((value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                      // trailingIcon: Icon(Icons.question_mark));
                    }).toList()),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            child: Row(
              children: [
                DropdownMenu<String>(
                    helperText: "Answer field",
                    hintText: "Answer",
                    initialSelection: answerDefault,
                    enableFilter: false,
                    enableSearch: true,
                    onSelected: (value) {
                      _generate(value);
                    },
                    controller: answerController,
                    dropdownMenuEntries: fieldNames.map((value) {
                      return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          trailingIcon: const Icon(Icons.abc));
                    }).toList()),
                ElevatedButton(
                    onPressed: () {
                      _generate("");
                    },
                    child: Text("Generate Questions")),
              ],
            ),
          ),
          words.isEmpty
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      var item = words[index];
                      return ListTile(
                        leading: IconButton(
                          icon: item.mark
                              ? const Icon(Icons.add)
                              : const Icon(Icons.menu),
                          onPressed: () {
                            item.mark = !item.mark;
                            setState(() {});
                          },
                        ),
                        title: Text(item.question),
                        subtitle: Text(item.answer),
                        trailing: item.word != null
                            ? ElevatedButton(
                                child: Text(
                                  item.word!.name,
                                  style: const TextStyle(
                                      backgroundColor: Colors.blue),
                                ),
                                onPressed: () {},
                              )
                            : const Icon(Icons.hourglass_empty_sharp),
                      );
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed: _save, child: Text("Save"))],
          )
        ],
      ),
    );
  }

  Future<String> onSave(BuildContext context) async {
    // Navigator.of(context).pop(widget.listToView);
    return "";
  }

  dynamic getValueByFieldName(String fieldName, Db.Word item) {
    dynamic result = "";
    var mapItem = item.toColumns(false);
    result = mapItem[fieldName];
    switch (fieldName) {
      case "mean":
        result = item.mean;
        break;
      case "important":
        result = item.important;
        break;
      case "description":
        result = item.description;
        break;
      default:
        result = item.name;
    }
    return result;
  }

  void _generate(String? value) async {
    words = fillBaseWords();
    var questionField = questionController.text;
    var answerField = answerController.text;
    var sessionWords =
        await Provider.of<AppDataProvider>(context, listen: false)
            .updateSessionByFilter(
      current: sessionsController.text,
    );
    for (var item in sessionWords) {
      String question = getValueByFieldName(questionField, item).toString();
      String answer = getValueByFieldName(answerField, item).toString();

      var questionDB =
          await Provider.of<AppDataProvider>(context, listen: false)
              .db
              .getQuestionByName(question, widget.QuizGroup.id, wordId: 0);

      if (question.isNotEmpty && answer.isNotEmpty) {
        var newElement = QuestionCardMarkable(
            question: question, answer: answer, id: 0, example: "");
        newElement.mark = questionDB == null ? true : false;
        newElement.word = item;
        words.insert(0, newElement);
      }
    }
    setState(() {});
  }

  _delete(int index) {
    // widget.listToView.removeAt(index);
    setState(() {});
  }

  void _save() async {
    int count = 0;
    for (var item in words) {
      if (item.mark) {
        item.mark = false;
        count += 1;
        await Provider.of<AppDataProvider>(context, listen: false)
            .addQuizQuestion(item.question, item.answer, widget.QuizGroup,
                wordID: item.word?.id ?? 0);

        var elem = QuizCard(
            question: item.question,
            answer: item.answer,
            id: item.id,
            example: item.question);
        widget.QuizGroup.cards.add(elem);
      }
      if (count > 3) {
        count = 0;
        setState(() {});
      }
    }
    words = fillBaseWords();

    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Complite!")));
  }
}

class QuestionCardMarkable extends QuizCard {
  bool mark = false;
  // Word word;

  QuestionCardMarkable(
      {required super.question,
      required super.answer,
      required super.id,
      required super.example,
      this.mark = false});
}
