import 'package:flutter/material.dart';

// Shorten of pushNamed without arguments
void push(BuildContext context, String routeName) {
  final nav = Navigator.of(context);
  nav.pushNamed(routeName);
}
