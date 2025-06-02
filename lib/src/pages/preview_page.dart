import 'dart:math';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../common.dart';
import '../isar_collection/isar_collections.dart';
import 'edit_store_state.dart' show loadImage;
import 'preview_state.dart';

class PreviewPage extends StatefulWidget {
  static const String routeName = '/preview';

  const PreviewPage({
    super.key,
    required this.store,
    required this.recipient,
    required this.items,
    required this.paid,
    required this.daysRange,
    required this.locale,
    required this.fileName,
  });

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;
  final int daysRange;
  final String locale;
  final String fileName;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _downloaded = false;
  Uint8List? _imgBytes;
  late Uint8List _pdfBytes;
  final _doc = pw.Document();
  String _dueDate = '';
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
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.preview, style: textTheme.bodySmall),
              Text(widget.fileName, style: textTheme.titleLarge),
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: PdfPreview(
                pdfFileName: '${widget.fileName}.pdf',
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                actionBarTheme: PdfActionBarTheme(
                  backgroundColor: colors.primary,
                  iconColor: colors.onPrimary,
                ),
                actions: kEnableDownload
                    ? [
                        IconButton(
                          onPressed: _downloaded
                              ? null
                              : () => _onDownload(_pdfBytes),
                          icon: Icon(Icons.save_alt),
                        ),
                      ]
                    : null,
                build: (_) => _doc.save(),
              ),
            ),
            const Divider(height: 0.0),
            _BackToHomeButton(
              onPressed: () => _onBackToHome(),
              title: l10n.backToHome,
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

  pw.Widget _buildHeader(pw.Context pwContext) {
    final l10n = AppLocalizations.of(context)!;
    final missing = missingSymbols.contains(widget.store.locale);
    final symbol = missing ? null : widget.store.symbol!;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: symbol,
    );
    final color = widget.store.color!;
    final n = _gT + _tax - widget.paid;
    final gT = max(0, n);

    return pw.TableHelper.fromTextArray(
      headerDecoration: pw.BoxDecoration(color: getColor(widget.store.color!)),
      border: pw.TableBorder.all(width: .5),
      cellHeight: 75,
      cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center},
      data: <List<dynamic>>[
        [
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20),
            child: pw.Text(
              l10n.invoice.toUpperCase(),
              style: pw.TextStyle(fontSize: 40, color: getTitleColor(color)),
            ),
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                '${l10n.amount}:',
                style: pw.TextStyle(color: getTitleColor(color)),
              ),
              pw.SizedBox(height: 4.0),
              pw.Text(
                formatted.format(gT),
                style: pw.TextStyle(
                  fontSize: 20,
                  color: getTitleColor(color),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  pw.Widget _buildSubheader(pw.Context pwContext) {
    final now = DateFormat.yMMMMd(widget.locale).format(DateTime.now());
    final l10n = AppLocalizations.of(context)!;
    final name = widget.recipient.name;
    final addr = widget.recipient.address!.replaceAll(',', '\n');

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
            '${l10n.billedTo}: $name\n$addr',
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
          ),
          pw.Text(
            '${l10n.date}: $now\n${l10n.dueDate}: $_dueDate',
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(pw.Context pwContext) {
    final l10n = AppLocalizations.of(context)!;
    final missing = missingSymbols.contains(widget.store.locale);
    final symbol = missing ? null : widget.store.symbol!;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: symbol,
    );
    final n = _gT + _tax - widget.paid;
    final leftOver = max(0, n);

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
          _buildPaymentDetails(pwContext),
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
                ['${l10n.subtotal}:', formatted.format(_sT)],
                ['${l10n.totalDiscount}:', '-${formatted.format(_tD)}'],
                ['${l10n.tax}:', formatted.format(_tax)],
                ['${l10n.grandTotal}:', formatted.format(_gT + _tax)],
                ['${l10n.paid}:', formatted.format(widget.paid)],
                ['${l10n.leftOver}:', formatted.format(leftOver)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentDetails(pw.Context pwContext) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: pw.Text(
        _getPaymentDetails(),
        style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildThankNote(pw.Context pwContext) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: .5)),
      child: pw.Text(
        widget.store.thankNote!,
        style: pw.TextStyle(lineSpacing: 8, fontSize: 8.0),
      ),
    );
  }

  pw.Widget _buildProfile(pw.Context pwContext) {
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
                right: pw.BorderSide(style: pw.BorderStyle.dashed, width: .5),
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
            _getProfiles(),
            style: pw.TextStyle(lineSpacing: 8, fontSize: 10),
            textAlign: pw.TextAlign.end,
          ),
        ],
      ),
    );
  }

  dynamic _buildItem(
    pw.Context pwContext,
    int row,
    int col,
    PurchaseItem item,
  ) {
    final i = col - 1;
    final t = item.item.value;
    final missing = missingSymbols.contains(widget.store.locale);
    final symbol = missing ? null : widget.store.symbol!;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: symbol,
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

  pw.Widget _buildItemTable(pw.Context pwContext, List<PurchaseItem> items) {
    final l10n = AppLocalizations.of(context)!;
    final color = widget.store.color;
    final headers = <String>[
      '#',
      'SKU',
      l10n.itemName,
      l10n.price,
      l10n.qty,
      'Total',
    ];

    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: .5),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: getColor(widget.store.color!)),
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
        color: getTitleColor(color!),
      ),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: List<String>.generate(headers.length, (col) => headers[col]),
      data: List<List<dynamic>>.generate(
        widget.items.length,
        (row) => List<dynamic>.generate(
          headers.length,
          (col) => col == 0
              ? '${row + 1}'
              : _buildItem(pwContext, row, col, items[row]),
        ),
      ),
    );
  }

  Future<void> _onDownload(Uint8List pdfBytes) async {
    final l10n = AppLocalizations.of(context)!;
    final msg = ScaffoldMessenger.of(context);
    final saved = l10n.successfullyDownloaded;
    await downloadPdf(
      widget.fileName,
      pdfBytes,
      (_) => msg.showSnackBar(SnackBar(content: Text(l10n.permissionDenied))),
      (_) {
        msg.showSnackBar(SnackBar(content: Text(saved)));
        setState(() => _downloaded = true);
      },
    );
  }

  String _getDueDate(int daysRange) {
    final dur = Duration(days: daysRange);
    final date = DateTime.now().add(dur);
    return DateFormat.yMMMMd(widget.locale).format(date);
  }

  String _getProfiles() {
    final split = [widget.store.name, widget.store.email];
    if (widget.store.address!.isNotEmpty) split.add(widget.store.address);
    if (widget.store.phoneNumber!.isNotEmpty) {
      split.add(widget.store.phoneNumber);
    }
    return split.join('\n');
  }

  String _getPaymentDetails() {
    final l10n = AppLocalizations.of(context)!;
    final split = [
      '${l10n.bank}: ${widget.store.bankName}',
      '${l10n.accountHolderName}: ${widget.store.accountHolderName}',
      '${l10n.accountNumber}: ${widget.store.accountNumber}',
    ];
    if (widget.store.swiftCode!.isNotEmpty) {
      split.add('${l10n.swiftCode}: ${widget.store.swiftCode}');
    }
    return split.join('\n');
  }
}

class PreviewArgs {
  const PreviewArgs(
    this.store,
    this.recipient,
    this.items,
    this.paid,
    this.daysRange,
    this.locale,
    this.fileName,
  );

  final Store store;
  final Recipient recipient;
  final List<PurchaseItem> items;
  final double paid;
  final int daysRange;
  final String locale;
  final String fileName;
}

class _BackToHomeButton extends StatelessWidget {
  const _BackToHomeButton({required this.onPressed, required this.title});

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
