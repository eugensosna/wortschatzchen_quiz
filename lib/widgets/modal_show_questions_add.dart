import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/auto_complite_helper.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/deck.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';
import 'package:wortschatzchen_quiz/screens/session_word_list.dart';

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

  void moveToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSessions =
        Provider.of<AppDataProvider>(context, listen: false).sessionsByName;

    words = widget.QuizGroup.cards.map((toElement) {
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
        title: Text("Generate "),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen(context);
            }),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
                    controller: sessionsController,
                    dropdownMenuEntries: listSessions.map((toElement) {
                      return DropdownMenuEntry<String>(
                        value: toElement.typesession,
                        label: "${toElement.typesession}",
                      );
                    }).toList()),
                DropdownMenu<String>(
                    helperText: "Question field",
                    hintText: "Question",
                    enableFilter: false,
                    enableSearch: true,
                    controller: questionController,
                    dropdownMenuEntries: fieldNames.map((value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                      // trailingIcon: Icon(Icons.question_mark));
                    }).toList()),
                DropdownMenu<String>(
                    helperText: "Answer field",
                    hintText: "Answer",
                    enableFilter: false,
                    enableSearch: true,
                    controller: answerController,
                    dropdownMenuEntries: fieldNames.map((value) {
                      return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          trailingIcon: Icon(Icons.abc));
                    }).toList()),
              ],
            ),
          ),
          words.isEmpty
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      var item = words[index];
                      return ListTile(
                        leading: item.mark
                            ? Icon(Icons.add) : Icon(Icons.menu),
                        title: Text(item.question),
                        subtitle: Text(item.answer),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
    /*
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Reorder"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen(context);
            }),
      ),
      body: ReorderableListView.builder(
        itemCount: widget.listToView.length,
        itemBuilder: (context, index) {
          var item = widget.listToView.elementAt(index);
          return GestureDetector(
              key: Key(index.toString()),
              onDoubleTap: () {
                editItem(context, item);
              },
              child: Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
                onDismissed: (direction) {
                  // widget.talker.debug("Dismissible delete ${wordItem.name} ");
                  _delete(index);
                },
                child: ListTile(
                  key: Key(index.toString()),
                  title: Text(item.name),
                  subtitle: Text(item.translate),
                  leading: Text("${item.orderId}"),
                ),
              ));
        },
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

      // bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          editItem(
              context,
              ReordableElement(
                  id: -1, name: "", translate: "", orderId: 0, uuid: ""));
        },
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );*/
  }

  Future<String> onSave(BuildContext context) async {
    // Navigator.of(context).pop(widget.listToView);
    return "";
  }

  void editItem(BuildContext context, ReordableElement edit) async {
    descriptionController.text = edit.name;
    translateController.text = edit.translate;

    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// The `TextField` widget in Flutter is used to create a text input field where users can
                /// enter text. In the provided code snippet, the `TextField` widget is being used to
                /// create an input field for the description of an element. The `controller` property is
                /// used to control the text entered in the field, and the `onEditingComplete` callback is
                /// triggered when the user finishes editing the text in the field.
                TextField(
                  controller: descriptionController,
                  onEditingComplete: () {
                    edit.name = descriptionController.text;
                  },
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                IconButton(
                    onPressed: () => translate(context),
                    icon: const Icon(Icons.move_down)),
                TextField(
                  decoration: const InputDecoration(hintText: "Translated"),
                  controller: translateController,
                  onEditingComplete: () {
                    edit.translate = translateController.text;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Disable'),
                onPressed: () {
                  Navigator.of(_scaffoldKey.currentContext ?? context)
                      .pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Save'),
                onPressed: () {
                  edit.name = descriptionController.text;
                  edit.translate = translateController.text;
                  if (edit.id < 0) {
                    edit.id = 0;
                    // widget.listToView.insert(0, edit);
                  }
                  setState(() {});

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  _delete(int index) {
    // widget.listToView.removeAt(index);
    setState(() {});
  }


  void translate(BuildContext context) async {
    print("translate ");
    translateController.text =
        await Provider.of<AppDataProvider>(context, listen: false)
            .translate(descriptionController.text);
  }
}

class FormExample extends StatefulWidget {
  final ReordableElement editElement;
  const FormExample({super.key, required this.editElement});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController translateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsetsGeometry.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// The `TextField` widget in Flutter is used to create a text input field where users can
            /// enter text. In the provided code snippet, the `TextField` widget is being used to
            /// create an input field for the description of an element. The `controller` property is
            /// used to control the text entered in the field, and the `onEditingComplete` callback is
            /// triggered when the user finishes editing the text in the field.
            TextField(
              controller: descriptionController,
              onEditingComplete: () {
                widget.editElement.name = descriptionController.text;
              },
              decoration: const InputDecoration(hintText: "Description"),
            ),
            IconButton(
                onPressed: () {
                  print("translate ");
                },
                icon: const Icon(Icons.move_down)),
            TextField(
              decoration: const InputDecoration(hintText: "Translated"),
              controller: translateController,
              onEditingComplete: () {
                widget.editElement.translate = translateController.text;
              },
            ),
          ],
        ),
      ),
    );
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
