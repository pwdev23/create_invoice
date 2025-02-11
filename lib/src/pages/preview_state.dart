import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' show PdfColors, PdfColor;
import 'package:permission_handler/permission_handler.dart';

import '../isar_collection/isar_collections.dart' show PurchaseItem;

const kDateFormat = 'yyyyMMdd-HHmmss';

double calcTax(double tax, double grandTotal) {
  final f = tax / 100;
  return grandTotal * f;
}

double calcDiscount(double price, double discount, bool isPercent) {
  final d = isPercent ? discount / 100 : discount;
  return isPercent ? price - (price * d) : price - d;
}

double calcSubTotal(List<PurchaseItem> items) {
  double total = 0;

  for (var e in items) {
    total += e.item.value!.price! * e.qty!;
  }

  return total;
}

double calcTotalDiscount(List<PurchaseItem> items) {
  double total = 0;

  for (var e in items) {
    final t = e.item.value;
    if (t!.discount! > 0) {
      if (t.isPercentage!) {
        final f = t.discount! / 100;
        final n = t.price! * f;
        total += n;
      } else {
        total += t.discount!;
      }
    }
  }

  return total;
}

Future<void> downloadPdf(Uint8List pdfBytes) async {
  // Check and request storage permission
  if (await Permission.manageExternalStorage.request().isGranted) {
    // Get the public Downloads directory (or app's document directory)
    final directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()) {
      debugPrint("Directory does not exist, creating...");
      try {
        await directory.create(recursive: true);
      } catch (e) {
        debugPrint("Failed to create directory: $e");
        return;
      }
    }

    final now = DateTime.now();
    final date = DateFormat('yyyyMMdd-HHmmss').format(now);
    // File path
    final filePath = '${directory.path}/INV_$date.pdf';
    final file = File(filePath);

    try {
      // Write the PDF
      await file.writeAsBytes(pdfBytes);
      debugPrint("PDF saved at $filePath");
    } catch (e) {
      debugPrint("Failed to save PDF: $e");
    }
  } else {
    debugPrint("Permission denied.");
  }
}

Future<bool> requestPermission() async {
  return await Permission.manageExternalStorage.request().isGranted;
}

String getTextLogo(String name) {
  final split = name.split(' ');
  if (split.length > 1) {
    return '${split[0][0]}${split[1][0]}'.toUpperCase();
  } else {
    return name[0].toUpperCase();
  }
}

PdfColor? getColor(String color) {
  switch (color) {
    case 'blueGrey':
      return PdfColors.blueGrey300;
    case 'grey':
      return PdfColors.grey300;
    case 'brown':
      return PdfColors.brown300;
    case 'pink':
      return PdfColors.pink300;
    case 'purple':
      return PdfColors.purple300;
    case 'deepPurple':
      return PdfColors.deepPurple300;
    case 'indigo':
      return PdfColors.indigo300;
    case 'blue':
      return PdfColors.blue300;
    case 'lightBlue':
      return PdfColors.lightBlue300;
    case 'cyan':
      return PdfColors.cyan300;
    case 'teal':
      return PdfColors.teal300;
    case 'green':
      return PdfColors.green300;
    case 'lightGreen':
      return PdfColors.lightGreen300;
    case 'lime':
      return PdfColors.lime300;
    case 'yellow':
      return PdfColors.yellow300;
    case 'amber':
      return PdfColors.amber300;
    case 'orange':
      return PdfColors.orange300;
    case 'deepOrange':
      return PdfColors.deepOrange300;
    case 'red':
      return PdfColors.red300;
    default:
      return null;
  }
}

PdfColor getTitleColor(String color) {
  switch (color) {
    case 'blueGrey':
    case 'brown':
    case 'purple':
    case 'indigo':
    case 'blue':
    case 'teal':
    case 'green':
      return PdfColors.white;

    case 'grey':
    case 'deepPurple':
    case 'pink':
    case 'cyan':
    case 'lightBlue':
    case 'lightGreen':
    case 'lime':
    case 'yellow':
    case 'amber':
    case 'orange':
    case 'deepOrange':
    case 'red':
      return PdfColors.black;

    default:
      return PdfColors.black;
  }
}
