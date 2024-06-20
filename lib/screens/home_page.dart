import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/drawers/main_drawer.dart';
import 'package:wortschatzchen_quiz/screens/image_to_text.dart';
import 'package:wortschatzchen_quiz/screens/quiz_page.dart';
import 'package:wortschatzchen_quiz/screens/sessions_dates.dart';
import 'package:wortschatzchen_quiz/screens/words_list.dart';
import 'package:wortschatzchen_quiz/utils/constaints.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.talker});
  final Talker talker;



  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int count = 2;
  int selectedIndex = 2;
  final DbHelper dbH = DbHelper();
  List<Widget> tabBarPages = [];

  @override
  void initState() {
    dbH.setTalker(widget.talker);

    tabBarPages = [
      QuizPage(db: dbH, talker: widget.talker),
      SessionsDates(db: dbH, talker: widget.talker),
      WordsList(
        dbH,
        talker: widget.talker,
      ),
      TalkerScreen(
          talker: widget.talker,
          theme: const TalkerScreenTheme(
            /// Your custom log colors
            logColors: {
              TalkerLogType.httpResponse: Color(0xFF26FF3C),
              TalkerLogType.error: Colors.redAccent,
              TalkerLogType.info: Color.fromARGB(255, 0, 255, 247),
            },
          )),

      ImageToText(
        db: dbH,
        talker: widget.talker,
      )
    ];
    
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(routeNameHome),
      ),
      
      bottomNavigationBar: bottomNavigationBar(context),
      body: Center(
        child: tabBarPages.elementAt(selectedIndex),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Color getKeyboardColor(Word word) {
    if (word.rootWordID > 0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: "Quiz"),
        BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined), label: "Repeat"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
        BottomNavigationBarItem(icon: Icon(Icons.image_search), label: "Scan"),
      ],
    );
  }
}
