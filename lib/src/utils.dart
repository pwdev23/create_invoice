import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

// Shorten of pushNamed without arguments
void push(BuildContext context, String routeName) {
  final nav = Navigator.of(context);
  nav.pushNamed(routeName);
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
