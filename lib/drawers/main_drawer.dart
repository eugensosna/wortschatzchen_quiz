import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/utils/constaints.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 40,
            color: Colors.amberAccent,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeBackupRestoreDataPage);
            },
            leading: const Icon(Icons.backup),
            title: const Text("Backup, Restore"),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeDriftViewer);
            },
            leading: const Icon(Icons.backup),
            title: const Text("DBViewer"),
          )
        ],
      ),
    );
  }
}
