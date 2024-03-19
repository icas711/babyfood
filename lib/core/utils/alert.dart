import 'package:flutter/material.dart';

void showTutorSnack(context) => showSnack(context,
    "💡 Use tools at top bar to change selected text parameters\n\nSingle Tap (click) - SELECT text\nDouble Tap (click) - EDIT text\nLong tap (click) - DELETE text",
    bgColor: Colors.lightBlue, delaySec: 10);
void showSnack(BuildContext context, String msg,
    {Color bgColor = Colors.transparent, int delaySec = 1}) {
  if (bgColor == Colors.transparent &&
      Theme.of(context).primaryColor != Colors.transparent) {
    bgColor = Theme.of(context).primaryColor;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      duration: Duration(seconds: delaySec),
      showCloseIcon: true,
      content: Text(msg),
    ),
  );
}