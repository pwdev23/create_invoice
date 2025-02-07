import 'package:flutter/material.dart';

import '../constants.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      padding: kPx,
      height: kToolbarHeight * 1.5,
      child: Text(title, style: textTheme.titleLarge),
    );
  }
}
