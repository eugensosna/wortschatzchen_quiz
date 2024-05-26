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
