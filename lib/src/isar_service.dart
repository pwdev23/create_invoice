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
    await db.writeTxn(() async {
      final store = await db.stores.get(id);
      store!.email = editedStore.email;
      store.name = editedStore.name;
      store.bankName = editedStore.bankName;
      store.accountNumber = editedStore.accountNumber;
      store.accountHolderName = editedStore.accountHolderName;
      store.swiftCode = editedStore.swiftCode;
      store.tax = editedStore.tax;
      store.thankNote = editedStore.thankNote;
      store.locale = editedStore.locale;
      store.symbol = editedStore.symbol;
      await db.stores.put(store);
    });
  }

  Stream<List<Store>> streamStores() async* {
    final db = await isarDb;
    yield* db.stores.where().watch(fireImmediately: true);
  }

  Future<void> saveItem(Item item) async {
    final db = await isarDb;
    await db.writeTxn(() async => db.items.put(item));
  }

  Future<void> deleteItems(List<int> ids) async {
    final db = await isarDb;
    await db.writeTxn(() async {
      await db.items.deleteAll(ids);
    });
  }

  Future<void> updateItem(Item editedItem) async {
    final db = await isarDb;
    final id = editedItem.id;
    await db.writeTxn(() async {
      final item = await db.items.get(id);
      item!.sku = editedItem.sku!;
      item.name = editedItem.name!;
      item.price = editedItem.price!;
      item.discount = editedItem.discount!;
      item.isPercentage = editedItem.isPercentage!;
      await db.items.put(item);
    });
  }

  Stream<List<Item>> streamItems() async* {
    final db = await isarDb;
    yield* db.items.where().watch(fireImmediately: true);
  }

  Future<List<Item>> findAllItems() async {
    final db = await isarDb;
    final items = db.items.where().findAll();
    return items;
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
    return await db.purchaseItems.where().findAll();
  }

  Future<List<Recipient>> findAllRecipients() async {
    final db = await isarDb;
    return await db.recipients.where().findAll();
  }

  Future<Recipient?> findPinnedRecipients() async {
    final db = await isarDb;
    return await db.recipients.filter().pinnedEqualTo(true).findFirst();
  }

  Future<int> countRecipients() async {
    final db = await isarDb;
    return await db.recipients.count();
  }

  Future<void> saveRecipient(Recipient recipient) async {
    final db = await isarDb;
    await db.writeTxn(() async => db.recipients.put(recipient));
  }

  Stream<List<Recipient>> streamRecipients() async* {
    final db = await isarDb;
    yield* db.recipients.where().watch(fireImmediately: true);
  }

  Future<void> updateRecipient(Recipient editedRecipient) async {
    final db = await isarDb;
    await db.writeTxn(() async {
      final recipient = await db.recipients.get(editedRecipient.id);
      recipient!.name = editedRecipient.name;
      recipient.address = editedRecipient.address;
      recipient.pinned = editedRecipient.pinned;
      await db.recipients.put(recipient);
    });
  }

  Future<void> deleteRecipients(List<int> ids) async {
    final db = await isarDb;
    await db.writeTxn(() async {
      await db.recipients.deleteAll(ids);
    });
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      final schemas = <CollectionSchema<dynamic>>[
        StoreSchema,
        InvoiceSchema,
        ItemSchema,
        PurchaseItemSchema,
        RecipientSchema
      ];

      return await Isar.open(schemas, directory: dir.path, inspector: true);
    }

    return Future.value(Isar.getInstance());
  }
}
