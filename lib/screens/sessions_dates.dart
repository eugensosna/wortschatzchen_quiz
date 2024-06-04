import 'package:flutter/material.dart';
import 'package:talker/talker.dart';
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
    getDefaultSessionName();

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
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  color: index % 2 == 0
                      ? Colors.red.shade300
                      : Colors.amber.shade400,
                  child: Text(
                    item.description,
                  ),
                ),
                on
                onTap: () {
                  showWordsBySession(item.typesession);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
