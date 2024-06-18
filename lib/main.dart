
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/screens/home_page.dart';
import 'package:talker/talker.dart';


late AppDatabase db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dataProviderTemp = AppDataProvider();
  db = dataProviderTemp.db;
  final talker = dataProviderTemp.talker;
  // talker.info("init Talker ");

  
  runApp(ChangeNotifierProvider(
      create: (context) => dataProviderTemp,
      child: MyApp(
    talker: talker,
      )));

  // runZonedGuarded(
  //   () => runApp(MyApp(
  //     talker: talker,
  //   )),
  //   (Object error, StackTrace stack) {
  //     talker.handle(error, stack, 'Uncaught app exception');
  //   },
  // );

  //  List<Language> allLang = await database.select(database.languages).get();

}

class MyApp extends StatelessWidget {
  final Talker talker;
  const MyApp({super.key, required this.talker});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var wtalker = talker;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        talker: wtalker,
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.talker});

  final Talker talker;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Word> listWords = [];

  @override
  void initState() {
    widget.talker;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final wtalker = widget.talker;
    return MaterialApp(
      title: "Wortschatzchen",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(
        talker: wtalker,
      ),

      
    );
  }



}




