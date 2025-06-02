import 'package:create_invoice/src/enumerations.dart';
import 'package:create_invoice/src/pages/preview_state.dart' show getColor;
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart' show PdfColors;

void main() {
  test('getColor should return correct color', () {
    final str = InvoiceColor.indigo.name;
    final color = getColor(str);
    final isIndigo = color == PdfColors.indigo300;
    expect(isIndigo, true);
  });
}
