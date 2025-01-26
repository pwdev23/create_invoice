import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// FIXME: The following code is not working as expected.
Future<void> onCreatePdf() async {
  // Check for storage permission
  if (await Permission.manageExternalStorage.request().isGranted) {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"), // PDF content
          );
        },
      ),
    );

    // Get the external storage directory
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      debugPrint("External storage directory is null");
      return;
    }

    final outputDir = Directory('${directory.path}/MyAppFiles');
    if (!(await outputDir.exists())) {
      await outputDir.create(recursive: true);
    }

    // File path
    final filePath = '${outputDir.path}/example.pdf';
    final file = File(filePath);

    // Write the PDF
    await file.writeAsBytes(await pdf.save());
    debugPrint("PDF saved at $filePath");
  } else {
    debugPrint("Permission denied.");
  }
}
