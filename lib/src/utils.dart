import 'package:flutter/material.dart';

// Shorten of pushNamed without arguments
void push(BuildContext context, String routeName, bool isPop) {
  final nav = Navigator.of(context);
  if (isPop) {
    nav.popAndPushNamed(routeName);
  } else {
    nav.pushNamed(routeName);
  }
}
