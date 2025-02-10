import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
