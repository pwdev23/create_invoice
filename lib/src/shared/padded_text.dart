import 'package:flutter/material.dart';

class PaddedText extends StatelessWidget {
  const PaddedText({
    super.key,
    required this.text,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.style,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Text(text, style: style),
    );
  }
}
