import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../isar_collection/isar_collections.dart';
import 'preview_state.dart';

const headers = ['#', 'SKU', 'Name', 'Price', 'Qty', 'Total'];

class PreviewPage extends StatefulWidget {
  static const String routeName = '/preview';

  const PreviewPage({super.key, required this.invoice});

  final Invoice invoice;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final doc = pw.Document();

  void _initializeDocument() {
    return doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.Container(
            padding: pw.EdgeInsets.all(30),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('To: ${widget.invoice.to}',
                    style: pw.TextStyle(lineSpacing: 8)),
                pw.Text(
                  'Invoice number: ${widget.invoice.id}\nDate:${widget.invoice.createdAt}',
                  style: pw.TextStyle(lineSpacing: 12),
                )
              ],
            ),
          ),
          _buildItemTable(context),
          _buildSummary(context)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _initializeDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: PdfPreview(
        pdfPreviewPageDecoration: null,
        build: (format) => doc.save(),
      ),
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.TableHelper.fromTextArray(
      cellHeight: 100,
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
      },
      data: <List<dynamic>>[
        [
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20),
            child: pw.Text(
              'INVOICE',
              style: pw.TextStyle(fontSize: 40),
            ),
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Amount:'),
              pw.Text('\$450', style: pw.TextStyle(fontSize: 20)),
            ],
          ),
        ]
      ],
    );
  }

  pw.Widget _buildSummary(pw.Context context) {
    return pw.TableHelper.fromTextArray(
      cellHeight: 40,
      border: null,
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(1),
      },
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerRight,
      },
      data: <List<dynamic>>[
        ['Grand total:', '99.99']
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 20.0),
      child: pw.Text(
        '800 Interchange Blvd.\nSuite 2501, Austin, TX 78721\nsupport@adventure-works.com',
        style: pw.TextStyle(lineSpacing: 8),
      ),
    );
  }

  dynamic _buildItem(pw.Context context, int row, int col, PurchaseItem item) {
    final i = col - 1;
    switch (i) {
      case 0:
        return item.item.value!.sku;
      case 1:
        return item.item.value!.name;
      case 2:
        return '${item.item.value!.price}';
      case 3:
        return item.qty;
      default:
        final p = item.item.value!.price!;
        final d = item.item.value!.discount!;
        final percent = item.item.value!.isPercentage!;
        final count = calcDiscount(p, d, percent);

        return item.item.value!.discount! == 0
            ? '${item.item.value!.price! * item.qty!}'
            : pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '${item.item.value!.price! * item.qty!}',
                    style: pw.TextStyle(
                        fontSize: 10,
                        decoration: pw.TextDecoration.lineThrough),
                  ),
                  pw.Text(
                    '${(count * item.qty!)}',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              );
    }
  }

  pw.Widget _buildItemTable(pw.Context context) {
    return pw.TableHelper.fromTextArray(
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        // color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        // color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        // color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            // color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        headers.length,
        (col) => headers[col],
      ),
      data: List<List<dynamic>>.generate(
        widget.invoice.purchaseItems.length,
        (row) => List<dynamic>.generate(
          headers.length,
          (col) => col == 0
              ? '${row + 1}'
              : _buildItem(
                  context,
                  row,
                  col,
                  (widget.invoice.purchaseItems.iterator as List)[row].item,
                ),
        ),
      ),
    );
  }
}

class PreviewArgs {
  const PreviewArgs(this.invoice);

  final Invoice invoice;
}
