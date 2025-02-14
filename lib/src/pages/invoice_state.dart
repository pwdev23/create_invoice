import 'package:flutter/material.dart' show Color, Colors;

enum InvoiceColor {
  white,
  blueGrey,
  grey,
  brown,
  pink,
  purple,
  deepPurple,
  indigo,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lightGreen,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  red,
}

int extractNumbers(String input) {
  String numbers = input.replaceAll(RegExp(r'\D'), '');
  return numbers.isNotEmpty ? int.parse(numbers) : 0;
}

Color? getInvoiceColor(InvoiceColor color) {
  switch (color) {
    case InvoiceColor.blueGrey:
      return Colors.blueGrey[300];
    case InvoiceColor.grey:
      return Colors.grey[300];
    case InvoiceColor.brown:
      return Colors.brown[300];
    case InvoiceColor.pink:
      return Colors.pink[300];
    case InvoiceColor.purple:
      return Colors.purple[300];
    case InvoiceColor.deepPurple:
      return Colors.deepPurple[300];
    case InvoiceColor.indigo:
      return Colors.indigo[300];
    case InvoiceColor.blue:
      return Colors.blue[300];
    case InvoiceColor.lightBlue:
      return Colors.lightBlue[300];
    case InvoiceColor.cyan:
      return Colors.cyan[300];
    case InvoiceColor.teal:
      return Colors.teal[300];
    case InvoiceColor.green:
      return Colors.green[300];
    case InvoiceColor.lightGreen:
      return Colors.lightGreen[300];
    case InvoiceColor.lime:
      return Colors.lime[300];
    case InvoiceColor.yellow:
      return Colors.yellow[300];
    case InvoiceColor.amber:
      return Colors.amber[300];
    case InvoiceColor.orange:
      return Colors.orange[300];
    case InvoiceColor.deepOrange:
      return Colors.deepOrange[300];
    case InvoiceColor.red:
      return Colors.red[300];
    default:
      return Colors.white;
  }
}
