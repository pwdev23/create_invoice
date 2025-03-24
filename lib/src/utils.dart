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

String getVersionText(
  String version,
  String versionLeadingText,
  String buildLeadingText,
) {
  final s = version.split('+');
  return '$versionLeadingText ${s[0]} $buildLeadingText(${s[1]})';
}
