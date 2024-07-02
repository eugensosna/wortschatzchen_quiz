import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime dt, {String pattern = 'yyyy-MM-dd'}) {
  return DateFormat(pattern).format(dt);
}

String getFormattedTime(TimeOfDay tm, {String pattern = 'HH:mm'}) {
  return DateFormat(pattern).format(DateTime(0, 0, 0, tm.hour, tm.minute));
}

void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

String getDefaultSessionName() {
  return getFormattedDate(DateTime.now(), pattern: 'yyyy-MM-dd');
}

String getDefaultSessionNamedByDate(DateTime dt) {
  return getFormattedDate(dt, pattern: 'yyyy-MM-dd');
}

String encodeToHumanText(String input) {
  // Step 1: Encode the misinterpreted text to bytes using ISO-8859-1 encoding
  List<int> bytes = latin1.encode(input);
  String correctText = input;
  // Step 2: Decode the bytes back to a string using UTF-8 encoding
  // String correctText = utf8.decode(bytes);
  try {
    correctText = utf8.decode(bytes);
  } catch (e) {
    // If UTF-8 fails, try other common encodings
    correctText = const Utf8Decoder(allowMalformed: true).convert(bytes);
  }

  return correctText;
}
