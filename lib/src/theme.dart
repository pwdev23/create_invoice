import 'package:flutter/material.dart';

const kSeedColor = Color(0xff687CE1);
const kContrastLevel = -0.5;

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
  ),
);

final pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

final theme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.light,
    contrastLevel: kContrastLevel,
    surface: Color(0xffffffff),
  ),
  scaffoldBackgroundColor: Color.fromRGBO(245, 245, 247, 1),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: Color(0xffffffff),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Color.fromRGBO(245, 245, 247, 1),
  ),
  inputDecorationTheme: inputDecorationTheme,
  listTileTheme: ListTileThemeData(tileColor: Color(0xffffffff)),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xffffffff)),
  pageTransitionsTheme: pageTransitionsTheme,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
    contrastLevel: kContrastLevel,
    surface: Color.fromRGBO(13, 17, 22, 1),
  ),
  scaffoldBackgroundColor: Color.fromRGBO(2, 4, 10, 1),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: Color.fromRGBO(13, 17, 22, 1),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Color.fromRGBO(2, 4, 10, 1)),
  inputDecorationTheme: inputDecorationTheme,
  listTileTheme: ListTileThemeData(tileColor: Color.fromRGBO(13, 17, 22, 1)),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color.fromRGBO(13, 17, 22, 1),
  ),
  pageTransitionsTheme: pageTransitionsTheme,
);
