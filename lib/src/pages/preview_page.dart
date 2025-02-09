import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../isar_collection/isar_collections.dart';
import '../utils.dart';
import 'preview_state.dart';

const kHeaders = ['#', 'SKU', 'Name', 'Price', 'Qty', 'Total'];

class PreviewPage extends StatefulWidget {
  static const String routeName = '/preview';

  const PreviewPage({
    super.key,
    required this.store,
    required this.recipient,
    required this.items,
    required this.paid,
  });

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _downloaded = false;
  late Uint8List _pdfBytes;
  final _doc = pw.Document();
  final _yMMMMd = DateFormat.yMMMMd().format(DateTime.now());
  final _fileName = 'INV_${DateFormat(kDateFormat).format(DateTime.now())}';
  double _tD = 0;
  double _sT = 0;
  double _tax = 0;
  double _gT = 0;

  Future<void> _onInit() async {
    _tD = calcTotalDiscount(widget.items);
    _sT = calcSubTotal(widget.items);
    _gT = calcGrandTotal(widget.items, widget.store.tax!);
    _tax = calcTax(widget.store.tax!, _gT);
    await _buildPages(widget.items);
  }

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  void dispose() {
    _pdfBytes = Uint8List(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Preview'),
        ),
        body: Column(
          children: [
            Flexible(
              child: PdfPreview(
                pdfFileName: _fileName,
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                actionBarTheme: PdfActionBarTheme(
                  backgroundColor: colors.primary,
                  iconColor: colors.onPrimary,
                ),
                actions: [
                  IconButton(
                    onPressed:
                        _downloaded ? null : () => _onDownload(_pdfBytes),
                    icon: Icon(Icons.save_alt),
                  ),
                ],
                build: (_) => _doc.save(),
              ),
            ),
            const Divider(height: 0.0),
            _BackToHomeButton(
              onPressed: () => _onBackToHome(),
              title: 'Back to home',
            ),
          ],
        ),
      ),
    );
  }

  void _onBackToHome() {
    final nav = Navigator.of(context);
    nav.pushNamedAndRemoveUntil('/', (_) => false);
  }

  Future<void> _buildPages(List<PurchaseItem> items) async {
    _doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSubheader(context),
          _buildItemTable(context, items),
          _buildSummary(context),
          _buildPaymentDetails(context),
          _buildThankNote(context),
        ],
      ),
    );

    _pdfBytes = await _doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );

    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder(
        top: pw.BorderSide(width: .5),
        right: pw.BorderSide(width: .5),
        bottom: pw.BorderSide(width: .5),
        left: pw.BorderSide(width: .5),
        verticalInside: pw.BorderSide(width: .5),
      ),
      cellHeight: 100,
      columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
      cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center},
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
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Amount:'),
              pw.SizedBox(height: 4.0),
              pw.Text(
                formatted.format(_gT - widget.paid),
                style: pw.TextStyle(fontSize: 20),
              ),
            ],
          ),
        ]
      ],
    );
  }

  pw.Widget _buildSubheader(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(width: .5),
          right: pw.BorderSide(width: .5),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Billed to: ${widget.recipient.name}\n${widget.recipient.address}',
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
          ),
          pw.Text(
            'Number: n\nDate: $_yMMMMd',
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
          )
        ],
      ),
    );
  }

  pw.Widget _buildSummary(pw.Context context) {
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );

    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder(
        top: pw.BorderSide.none,
        right: pw.BorderSide(width: .5),
        bottom: pw.BorderSide(width: .5),
        left: pw.BorderSide(width: .5),
        horizontalInside: pw.BorderSide(width: .5),
      ),
      cellHeight: 20,
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerStyle: const pw.TextStyle(fontSize: 10),
      columnWidths: {0: pw.FlexColumnWidth(3), 1: pw.FlexColumnWidth(1)},
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerRight,
      },
      data: <List<dynamic>>[
        ['Subtotal:', formatted.format(_sT)],
        ['Total discount:', '-${formatted.format(_tD)}'],
        ['Tax:', '$_tax%'],
        ['Grand total:', formatted.format(_gT)],
        ['Paid:', formatted.format(widget.paid)],
        ['Left over:', formatted.format(_gT - widget.paid)],
      ],
    );
  }

  pw.Widget _buildPaymentDetails(pw.Context context) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(width: .5),
          right: pw.BorderSide(width: .5),
        ),
      ),
      child: pw.Text(
        'Bank: ${widget.store.bankName}\nAccount name: ${widget.store.accountHolderName}\nAccount number: ${widget.store.accountNumber}\nSwift code: ${widget.store.swiftCode}',
        style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildThankNote(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: .5),
      ),
      child: pw.Text(
        widget.store.thankNote!,
        style: pw.TextStyle(lineSpacing: 8, fontSize: 8.0),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 20.0),
      child: pw.Text(
        '${widget.store.name}\n${widget.store.email}',
        style: pw.TextStyle(lineSpacing: 8),
        textAlign: pw.TextAlign.end,
      ),
    );
  }

  dynamic _buildItem(pw.Context context, int row, int col, PurchaseItem item) {
    final i = col - 1;
    final t = item.item.value;

    switch (i) {
      case 0:
        return t!.sku;
      case 1:
        return t!.name;
      case 2:
        return _buildPriceTexts(item, true);
      case 3:
        return item.qty;
      default:
        return _buildPriceTexts(item, false);
    }
  }

  pw.Widget _buildItemTable(pw.Context context, List<PurchaseItem> items) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: .5),
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
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        kHeaders.length,
        (col) => kHeaders[col],
      ),
      data: List<List<dynamic>>.generate(
        widget.items.length,
        (row) => List<dynamic>.generate(
          kHeaders.length,
          (col) => col == 0
              ? '${row + 1}'
              : _buildItem(context, row, col, items[row]),
        ),
      ),
    );
  }

  dynamic _buildPriceTexts(PurchaseItem item, bool single) {
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );
    final t = item.item.value;
    final c = calcDiscount(t!.price!, t.discount!, t.isPercentage!);
    final qty = single ? 1 : item.qty!;

    return t.discount == 0
        ? formatted.format(t.price)
        : pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                formatted.format(t.price! * qty),
                style: pw.TextStyle(
                  fontSize: 10,
                  decoration: pw.TextDecoration.lineThrough,
                ),
              ),
              pw.Text(
                formatted.format(c * qty),
                style: pw.TextStyle(fontSize: 10),
              ),
            ],
          );
  }

  Future<void> _onDownload(Uint8List pdfBytes) async {
    final msg = ScaffoldMessenger.of(context);
    await downloadPdf(pdfBytes);
    const str = 'File successfully downloaded';
    msg.showSnackBar(SnackBar(content: Text(str)));
    setState(() => _downloaded = true);
  }
}

class PreviewArgs {
  const PreviewArgs(this.store, this.recipient, this.items, this.paid);

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;
}

class _BackToHomeButton extends StatelessWidget {
  const _BackToHomeButton({
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: kToolbarHeight,
      width: double.infinity,
      child: RawMaterialButton(
        fillColor: colors.surfaceTint,
        onPressed: onPressed,
        elevation: 0.0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Text(
          title,
          style: textTheme.titleMedium!.copyWith(color: colors.surface),
        ),
      ),
    );
  }
}
