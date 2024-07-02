import 'package:flutter/material.dart';
import 'package:wortschatzchen_quiz/screens/session_word_list.dart';

class DropDownMenuForSessions extends StatelessWidget {
  final List<SessionHeader> sessions;
  final String defaultValue;
  final Function callBackOnChose;

  const DropDownMenuForSessions(
      {super.key,
      required this.sessions,
      required this.defaultValue,
      required this.callBackOnChose});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        value: defaultValue,
        hint: const Text("Group"),
        items: sessions
            .map((element) => DropdownMenuItem<String>(
                  value: element.typesession,
                  child: Text(element.typesession),
                ))
            .toList(),
        onChanged: (value) async {
          callBackOnChose(value);
        });
  }
}
