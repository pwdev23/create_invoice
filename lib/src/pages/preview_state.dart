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
  double grandTotal = 0;

  for (var e in items) {
    final t = e.item.value;
    final d = t!.discount!;
    final p = t.isPercentage!;
    final price =
        d > 0 ? calcDiscount(t.price!, d, p) * e.qty! : t.price! * e.qty!;
    grandTotal += price;
  }

  return grandTotal;
}

double calcGrandTotal(List<PurchaseItem> items, double tax) {
  double grandTotal = 0;

  for (var e in items) {
    final t = e.item.value;
    final d = t!.discount!;
    final p = t.isPercentage!;
    final price =
        d > 0 ? calcDiscount(t.price!, d, p) * e.qty! : t.price! * e.qty!;
    grandTotal += price;
  }

  final f = tax / 100;
  final a = grandTotal * f;

  return grandTotal + a;
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
