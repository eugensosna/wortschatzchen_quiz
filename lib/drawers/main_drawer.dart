import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
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
          ),
          ListTile(
            onTap: () {
              var talker =
                  Provider.of<AppDataProvider>(context, listen: false).talker;
              Navigator.pop(context);
              Navigator.pushNamed(context, routeTalkerView);
            },
            title: Text("Talker"),
          )
        ],
      ),
    );
  }
}
