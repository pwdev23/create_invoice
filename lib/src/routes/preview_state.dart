import '../isar_collection/isar_collections.dart' show PurchaseItem;

double calcDiscount(double price, double discount, bool isPercent) {
  final d = isPercent ? discount / 100 : discount;
  return isPercent ? price - (price * d) : price - d;
}

double calcGrandTotal(List<PurchaseItem> items) {
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
