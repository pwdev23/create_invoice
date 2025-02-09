import 'package:flutter/material.dart';

const kSeedColor = Color(0xff687CE1);
const kContrastLevel = -0.5;

final appBarTheme = AppBarTheme(centerTitle: false);

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
  appBarTheme: appBarTheme,
  inputDecorationTheme: inputDecorationTheme,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
    contrastLevel: kContrastLevel,
  ),
  appBarTheme: appBarTheme,
  inputDecorationTheme: inputDecorationTheme,
);
