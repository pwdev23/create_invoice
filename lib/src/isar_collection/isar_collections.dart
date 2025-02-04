import 'package:isar/isar.dart';

part 'isar_collections.g.dart';

@collection
class Store {
  Id id = Isar.autoIncrement;
  String? name;
  String? email;
}

@collection
class Item {
  Id id = Isar.autoIncrement;
  String? sku;
  String? name;
  double? price;
  double? discount;
  bool? isPercentage;
}

@collection
class PurchaseItem {
  Id id = Isar.autoIncrement;
  final item = IsarLink<Item>();
  int? qty;
}

@collection
class Invoice {
  Id id = Isar.autoIncrement;
  String? storeName;
  String? storeEmail;
  String? to;
  final purchaseItems = IsarLinks<PurchaseItem>();
  DateTime? createdAt;
}

@collection
class Recipient {
  Id id = Isar.autoIncrement;
  String? name;
  String? address;
}
