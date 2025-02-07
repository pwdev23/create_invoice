import 'package:flutter/material.dart';

const kSeedColor = Color(0xff687CE1);
const kContrastLevel = -0.5;

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
  ),
);

final theme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.light,
    contrastLevel: kContrastLevel,
  ),
  inputDecorationTheme: inputDecorationTheme,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
    contrastLevel: kContrastLevel,
  ),
  inputDecorationTheme: inputDecorationTheme,
);
