import 'package:flutter/material.dart';

const kSeedColor = Color(0xff687CE1);
const kContrastLevel = -0.5;

final theme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.light,
    contrastLevel: kContrastLevel,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
    contrastLevel: kContrastLevel,
  ),
);
