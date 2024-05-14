import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/dbHelper.dart';
import 'package:wortschatzchen_quiz/main.dart';
import 'package:wortschatzchen_quiz/screens/image_to_text.dart';
import 'package:wortschatzchen_quiz/screens/words_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    tabBarPages = [
      WordsList(dbH),
      WordsList(dbH),
      WordsList(dbH),
      WordsList(dbH),
      ImageToText(db: dbH)
    ];
    // tabBarPages = [
    //   const WordsList(),
    //   const WordsList(),
    //   const WordsList(
    //     db: dbH,
    //   ),
    //   const WordsList(
    //     db: dbH,
    //   ),
    //   const ImageToText(db: dbH),
    // ];
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
