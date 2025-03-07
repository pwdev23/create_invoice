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

  group('calcSubTotal should be calculated correctly', () {
    test('Sub total should be calculated correctly', () {
      double subTotal = 0;
      subTotal = calcSubTotal(purchaseItems);
      expect(subTotal, 40);
    });

    test('calcTotalDiscount should be calculated correctly', () {
      final discount = calcTotalDiscount(purchaseItems);
      expect(discount, 5);
    });
  });
}
