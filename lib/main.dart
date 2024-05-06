import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/screens/words_list.dart';

late AppDatabase db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase();

  //  List<Language> allLang = await database.select(database.languages).get();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Word> listWords = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: "Wortschatzchen",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WordsList(),

      
    );
  }

//     return Scaffold(
//         /*appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//     );
//   }
// }
// */

//         body = CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               pinned: true,
//               snap: true,
//               floating: true,
//               title: const Text("test"),
//               backgroundColor: theme.primaryColor,
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(70),
//                 child: Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(horizontal: 70),
//                   decoration: const BoxDecoration(),
//                   child: TextFormField(
//                     controller: TextEditingController(),
//                   ),
//                 ),
//               ),
//             ),
//             SliverList.builder(
//                 itemCount: counttest,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: double.infinity,
//                     height: 40,
//                     margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
//                     child: const Text("data"),
//                   );
//                 }
//             )

//           ],
//         ),
//       floatingActionButton = FloatingActionButton(
//           onPressed: () {
//             debugPrint("jljljljl");
//           },
//           tooltip: 'Add',
//         child: const Icon(Icons.add),
//         )
//     );
}





//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         tooltip: 'Add',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     )
//   }
// }
