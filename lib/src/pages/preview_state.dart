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
  double total = 0;

  for (var e in items) {
    total += e.item.value!.price! * e.qty!;
  }

  return total;
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
