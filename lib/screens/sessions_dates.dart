import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/screens/session_word_list.dart';
import 'package:wortschatzchen_quiz/utils/helper_functions.dart';

class SessionsDates extends StatefulWidget {
  final DbHelper db;
  final Talker talker;

  const SessionsDates({
    super.key,
    required this.db,
    required this.talker,
  });

  @override
  SessionsDatesState createState() => SessionsDatesState();
}

class SessionsDatesState extends State<SessionsDates> {
  List<SessionHeader> listSessions = [];
  final widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getListSessions().then((value) {
      setState(() {
        listSessions = value;
      });
    });
  }

  Future<List<SessionHeader>> _getListSessions() async {
    List<SessionHeader> result = [];
    final sessions = await widget.db.getGroupedSessionsByName();
    for (var item in sessions) {
      // if (item.typesession.contains(todaySession)) {
      //   defaultSession = "${item.typesession} (${item.count})";
      // }
      result.add(SessionHeader(
          typesession: item.typesession,
          description: "${item.typesession} (${item.count})"));
    }

    return result;
  }

  showWordsBySession(String session) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SessionWordList(
          talker: widget.talker, db: widget.db, currentSession: session);
    }));
    if (result) {
      _getListSessions().then((onValue) {
        setState(() {
          listSessions = onValue;
        });
      });
    }
  }

  RelativeRect _getRelativeRect(GlobalKey key) {
    return RelativeRect.fromSize(
        _getWidgetGlobalRect(key), const Size(200, 200));
  }

  Rect _getWidgetGlobalRect(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    debugPrint('Widget position: ${offset.dx} ${offset.dy}');
    return Rect.fromLTWH(offset.dx / 3.1, offset.dy * 1.05,
        renderBox.size.width, renderBox.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverGrid.builder(
            itemCount: listSessions.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 200,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3),
            itemBuilder: (context, index) {
              var item = listSessions.elementAt(index);
              return Dismissible(
                key: Key(item.typesession.toString()),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
                onDismissed: (direction) async {
                  listSessions.removeAt(index);
                  _removeSession(item.typesession).then((onValue) {
                    setState(() {
                      listSessions = onValue;
                    });
                  });
                },
                child: GestureDetector(
                  
                  // onLongPress: () {
                  //   showMenu(
                  //       context: context,
                  //       position: _getRelativeRect(widgetKey),
                  //       items: <PopupMenuEntry>[
                  //         PopupMenuItem(
                  //             child: Row(
                  //           children: [
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 _showEditDialog(item.typesession);
                  //               },
                  //               child: const Text("Rename"),
                  //             ),
                  //             ElevatedButton(
                  //                 onPressed: () {
                  //                   showWordsBySession(item.typesession);
                  //                 },
                  //                 child: const Text("Open"))
                  //           ],
                  //         ))
                  //       ]);
                  //},
                  onDoubleTap: () {
                    _showEditDialog(item.typesession);
                  },
                  onTap: () {
                    showWordsBySession(item.typesession);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: index % 2 == 0
                        ? Colors.red.shade300
                        : Colors.amber.shade400,
                    child: Text(
                      item.description,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showEditDialog(oldName) async {
    var nameController = TextEditingController();

    bool? result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextField(
              controller: nameController,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _onCancel(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    _saveNewSession(context, oldName, nameController.text);
                  },
                  child: const Text("Save"))
            ],
          );
        });
    if (result != null && result) {
      _getListSessions().then(
        (value) {
          setState(() {
            listSessions = value;
          });
        },
      );
    }
  }

  void _saveNewSession(
      BuildContext contextLo, String oldName, String newName) async {
    var listSessionsToRen =
        await widget.db.getSessionEntryByTypeSession(oldName);
    for (var item in listSessionsToRen) {
      var newSession = item.copyWith(typesession: newName);
      await widget.db.update(widget.db.sessions).replace(newSession);
    }
    Navigator.of(contextLo).pop(true);
  }

  Future<List<SessionHeader>> _removeSession(String typesession) async {
    var listSessionsToRen =
        await widget.db.getSessionEntryByTypeSession(typesession);
    String formatted = getDefaultSessionName();

    for (var item in listSessionsToRen) {
      if (item.baseWord > 0) {
        await widget.db.into(widget.db.sessions).insert(
            SessionsCompanion.insert(
                baseWord: item.baseWord, typesession: formatted));
      }

      await widget.db.deleteSession(item);
    }
    listSessions = await _getListSessions();
    return listSessions;
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop(false);
  }
}
