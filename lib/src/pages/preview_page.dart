import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../isar_collection/isar_collections.dart';
import 'edit_store_state.dart' show loadImage;
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
    required this.daysRange,
  });

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;
  final int daysRange;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _downloaded = false;
  Uint8List? _imgBytes;
  late Uint8List _pdfBytes;
  final _doc = pw.Document();
  String _dueDate = '';
  final _now = DateFormat.yMMMMd().format(DateTime.now());
  final _fName = 'INV_${DateFormat(kDateFormat).format(DateTime.now())}.pdf';
  double _tD = 0;
  double _sT = 0;
  double _tax = 0;
  double _gT = 0;

  Future<void> _onInit() async {
    await loadImage((v) => setState(() => _imgBytes = v));
    _dueDate = _getDueDate(widget.daysRange);
    _tD = calcTotalDiscount(widget.items);
    _sT = calcSubTotal(widget.items);
    _gT = _sT - _tD;
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
                pdfFileName: _fName,
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
        header: (context) => _buildProfile(context),
        build: (context) => [
          _buildHeader(context),
          _buildSubheader(context),
          _buildItemTable(context, items),
          _buildSummary(context),
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
      headerDecoration: pw.BoxDecoration(color: PdfColors.indigo300),
      border: pw.TableBorder.all(width: .5),
      cellHeight: 75,
      columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
      cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center},
      data: <List<dynamic>>[
        [
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20),
            child: pw.Text(
              'INVOICE',
              style: pw.TextStyle(fontSize: 40, color: PdfColors.white),
            ),
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Amount:', style: pw.TextStyle(color: PdfColors.white)),
              pw.SizedBox(height: 4.0),
              pw.Text(
                formatted.format(_gT + _tax - widget.paid),
                style: pw.TextStyle(
                  fontSize: 20,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }

  pw.Widget _buildSubheader(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(width: .5200),
          right: pw.BorderSide(width: .5200),
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
            'Date: $_now\nDue date: $_dueDate',
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

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(width: .5),
          right: pw.BorderSide(width: .5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildPaymentDetails(context),
          pw.SizedBox(
            width: 200,
            child: pw.TableHelper.fromTextArray(
              border: pw.TableBorder(
                left: pw.BorderSide(width: .5),
                horizontalInside: pw.BorderSide(width: .5),
              ),
              cellHeight: 20,
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerStyle: const pw.TextStyle(fontSize: 10),
              cellAlignments: {
                0: pw.Alignment.centerRight,
                1: pw.Alignment.centerRight,
              },
              data: <List<dynamic>>[
                ['Subtotal:', formatted.format(_sT)],
                ['Total discount:', '-${formatted.format(_tD)}'],
                ['Tax:', formatted.format(_tax)],
                ['Grand total:', formatted.format(_gT + _tax)],
                ['Paid:', formatted.format(widget.paid)],
                ['Left over:', formatted.format(_gT + _tax - widget.paid)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentDetails(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: pw.Text(
        'Bank: ${widget.store.bankName}\nAccount name: ${widget.store.accountHolderName}\nAccount number: ${widget.store.accountNumber}\nSwift code: ${widget.store.swiftCode}',
        style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildThankNote(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: .5),
      ),
      child: pw.Text(
        widget.store.thankNote!,
        style: pw.TextStyle(lineSpacing: 8, fontSize: 8.0),
      ),
    );
  }

  pw.Widget _buildProfile(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.only(right: 30),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: .5),
          right: pw.BorderSide(width: .5),
          left: pw.BorderSide(width: .5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Container(
            alignment: pw.Alignment.center,
            width: 128.0,
            height: 128.0,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(
                  style: pw.BorderStyle.dashed,
                  width: .5,
                ),
              ),
              image: _imgBytes != null
                  ? pw.DecorationImage(image: pw.MemoryImage(_imgBytes!))
                  : null,
            ),
            child: _imgBytes != null
                ? null
                : pw.Text(
                    getTextLogo(widget.store.name!),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
          ),
          pw.Text(
            '${widget.store.name}\n${widget.store.email}',
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
            textAlign: pw.TextAlign.end,
          ),
        ],
      ),
    );
  }

  dynamic _buildItem(pw.Context context, int row, int col, PurchaseItem item) {
    final i = col - 1;
    final t = item.item.value;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );

    switch (i) {
      case 0:
        return t!.sku;
      case 1:
        return t!.name;
      case 2:
        return formatted.format(t!.price);
      case 3:
        return item.qty;
      default:
        return formatted.format(t!.price! * item.qty!);
    }
  }

  pw.Widget _buildItemTable(pw.Context context, List<PurchaseItem> items) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: .5),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: PdfColors.indigo300),
      headerHeight: 25,
      cellHeight: 30,
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
        color: PdfColors.white,
      ),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: List<String>.generate(kHeaders.length, (col) => kHeaders[col]),
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

  Future<void> _onDownload(Uint8List pdfBytes) async {
    final msg = ScaffoldMessenger.of(context);
    await downloadPdf(pdfBytes);
    const str = 'File successfully downloaded';
    msg.showSnackBar(SnackBar(content: Text(str)));
    setState(() => _downloaded = true);
  }

  String _getDueDate(int daysRange) {
    final dur = Duration(days: daysRange);
    final date = DateTime.now().add(dur);
    return DateFormat.yMMMMd().format(date);
  }
}

class PreviewArgs {
  const PreviewArgs(
    this.store,
    this.recipient,
    this.items,
    this.paid,
    this.daysRange,
  );

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;
  final int daysRange;
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
