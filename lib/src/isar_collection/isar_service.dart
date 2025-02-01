import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_collections.dart';

class IsarService {
  late Future<Isar> isarDb;

  IsarService() {
    isarDb = openDb();
  }

  Future<void> saveStore(Store store) async {
    final db = await isarDb;
    await db.writeTxn(() async => db.stores.put(store));
  }

  Future<List<Store>> findAllStores() async {
    final db = await isarDb;
    final stores = db.stores.where().findAll();
    return stores;
  }

  Future<void> updateStore(Store editedStore) async {
    final id = editedStore.id;
    final db = await isarDb;
    final store = await db.stores.get(id);
    store!.email = editedStore.email;
    store.name = editedStore.name;
    await db.stores.put(store);
  }

  Future<void> saveItem(Item item) async {
    final db = await isarDb;
    await db.writeTxn(() async => db.items.put(item));
  }

  Future<void> deleteItem(List<int> ids) async {
    final db = await isarDb;
    await db.items.deleteAll(ids);
  }

  Future<void> updateItem(Item editedItem) async {
    final id = editedItem.id;
    final db = await isarDb;
    final item = await db.items.get(id);
    item!.sku = editedItem.sku!;
    item.name = editedItem.name!;
    item.price = editedItem.price!;
    item.discount = editedItem.discount!;
    item.isPercentage = editedItem.isPercentage!;
    await db.items.put(item);
  }

  Stream<List<Item>> streamItems() async* {
    final db = await isarDb;
    yield* db.items.where().watch(fireImmediately: true);
  }

  Future<void> savePurchaseItem(PurchaseItem purchaseItem) async {
    final db = await isarDb;
    db.writeTxnSync<int>(() => db.purchaseItems.putSync(purchaseItem));
  }

  Future<void> deletePurchaseItem(List<int> ids) async {
    final db = await isarDb;
    await db.purchaseItems.deleteAll(ids);
  }

  Future<void> updatePurchaseItem(PurchaseItem editedPurchaseItem) async {
    final id = editedPurchaseItem.id;
    final db = await isarDb;
    final purchaseItem = await db.purchaseItems.get(id);
    purchaseItem!.qty = editedPurchaseItem.qty;
    await db.purchaseItems.put(purchaseItem);
  }

  Stream<List<PurchaseItem>> streamPurchaseItems() async* {
    final db = await isarDb;
    yield* db.purchaseItems.where().watch(fireImmediately: true);
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      final schemas = <CollectionSchema<dynamic>>[
        StoreSchema,
        InvoiceSchema,
        ItemSchema,
        PurchaseItemSchema
      ];

      return await Isar.open(schemas, directory: dir.path, inspector: true);
    }

    return Future.value(Isar.getInstance());
  }
}
