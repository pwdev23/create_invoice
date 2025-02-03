import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_collection/isar_collections.dart';

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

  Future<Store?> findFirstStore() async {
    final db = await isarDb;
    final store = db.stores.where().findFirst();
    return store;
  }

  Future<void> updateStore(Store editedStore) async {
    final db = await isarDb;
    final id = editedStore.id;
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
    final db = await isarDb;
    final id = editedItem.id;
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

  Future<void> deletePurchaseItems(List<int> ids) async {
    final db = await isarDb;
    await db.writeTxn(() async {
      await db.purchaseItems.deleteAll(ids);
    });
  }

  Future<void> updatePurchaseItem(PurchaseItem editedPurchaseItem) async {
    final db = await isarDb;
    await db.writeTxn(() async {
      final purchaseItem = await db.purchaseItems.get(editedPurchaseItem.id);
      purchaseItem!.qty = editedPurchaseItem.qty;
      await db.purchaseItems.put(purchaseItem);
    });
  }

  Future<void> savePurchaseItem(PurchaseItem purchaseItem) async {
    final db = await isarDb;

    final itemsToCompare = await db.purchaseItems
        .filter()
        .item((v) => v.idEqualTo(purchaseItem.item.value!.id))
        .findAll();

    final count = itemsToCompare.length;

    if (count == 0) {
      db.writeTxnSync<int>(() => db.purchaseItems.putSync(purchaseItem));
    } else {
      final qtyAddedItem = itemsToCompare[0];
      qtyAddedItem.qty = qtyAddedItem.qty! + 1;
      await db.writeTxn(() async => await db.purchaseItems.put(qtyAddedItem));
    }
  }

  Stream<List<PurchaseItem>> streamPurchaseItems() async* {
    final db = await isarDb;
    yield* db.purchaseItems.where().watch(fireImmediately: true);
  }

  Future<List<PurchaseItem>> findAllPurchaseItems() async {
    final db = await isarDb;
    return db.purchaseItems.where().findAll();
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
