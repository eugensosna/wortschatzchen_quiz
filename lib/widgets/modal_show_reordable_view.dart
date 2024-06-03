import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/models/auto_complit_helper.dart';

class ModalShowReordableView extends StatefulWidget {
  final List<ReordableElement> listToView;

  const ModalShowReordableView({super.key, required this.listToView});

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
        title: const Text("Reorder"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              moveToLastScreen(context);
            }),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < widget.listToView.length; index += 1)
            ListTile(
              key: Key("$index"),
              title: Text(widget.listToView[index].name),
              subtitle: Text(widget.listToView[index].translate),
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
      // bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewWord(
              context,
              ReordableElement(
                  id: 0, name: "", translate: "", orderId: 0, uuid: ""));
        },
        tooltip: "Add new",
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String> onSave(BuildContext context) async {
    Navigator.of(context).pop(widget.listToView);
    return "";
  }

  void addNewWord(BuildContext context, ReordableElement edit) async {
    TextEditingController descriptionController = TextEditingController();

    TextEditingController translateController = TextEditingController();

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
                  Navigator.of(context).pop(false);
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
                  widget.listToView.insert(0, edit);
                  setState(() {});

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
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
              TextField(
                decoration: const InputDecoration(hintText: "Translated"),
                controller: translateController,
                onEditingComplete: () {
                  widget.editElement.translate = translateController.text;
                },
              ),
            ],
          ),
        ));
  }
}