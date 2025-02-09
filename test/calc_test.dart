import 'package:create_invoice/src/isar_collection/isar_collections.dart';
import 'package:create_invoice/src/pages/preview_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final item1 = Item()
    ..id = 0
    ..name = 'Item 1'
    ..price = 10
    ..discount = 0
    ..isPercentage = true;

  final item2 = Item()
    ..id = 1
    ..name = 'Item 2'
    ..price = 10
    ..discount = 50
    ..isPercentage = true;

  var purchaseItems = <PurchaseItem>[
    PurchaseItem()
      ..qty = 2
      ..item.value = item1,
    PurchaseItem()
      ..qty = 2
      ..item.value = item2,
  ];

  group('Calculations should be calculated correctly', () {
    test('Grand total should be calculated correctly', () {
      const tax = 11.0;
      double grandTotal = 0;
      grandTotal = calcGrandTotal(purchaseItems, tax);
      expect(grandTotal, 33.3);
    });

    test('Sub total should be calculated correctly', () {
      double grandTotal = 0;
      grandTotal = calcSubTotal(purchaseItems);
      expect(grandTotal, 30);
    });

    test('Total discount should be calculated correctly', () {
      final discount = calcTotalDiscount(purchaseItems);
      expect(discount, 5);
    });
  });
}
