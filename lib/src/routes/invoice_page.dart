import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import '../utils.dart';
import 'preview_page.dart' show PreviewArgs;

class InvoicePage extends StatefulWidget {
  static const String routeName = '/invoice';

  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _db = IsarService();
  Store? _store = Store()
    ..name = ''
    ..email = '';
  final _recipient = Recipient()
    ..name = 'My customer'
    ..address = 'Padalarang';

  Future<void> _findFirstStore() async {
    _store = await _db.findFirstStore();
  }

  @override
  void initState() {
    super.initState();
    _findFirstStore().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _store!.name!.isNotEmpty ? _store!.name![0] : '';
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              shape: CircleBorder(),
            ),
            onPressed: () => _key.currentState!.openDrawer(),
            child: Text(avatar.toUpperCase()),
          ),
        ),
        title: _RecipientButton(
          leadingText: 'To',
          recipientName: 'My customer',
          onPressed: () {},
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _openStore(),
            icon: Icon(Icons.add),
            label: Text('Add item'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 180.0,
              color: colors.primaryContainer,
              alignment: Alignment.bottomLeft,
              child: Text.rich(
                style: TextStyle(color: colors.onPrimaryContainer),
                TextSpan(
                  text: '${_store!.name}\n',
                  children: [
                    TextSpan(text: _store!.email),
                  ],
                ),
              ),
            ),
            ListTile(
              style: ListTileStyle.drawer,
              onTap: () => push(context, '/store'),
              title: Text('Manage store'),
              leading: Icon(Icons.inbox),
            )
          ],
        ),
      ),
      body: StreamBuilder<List<PurchaseItem>>(
        stream: _db.streamPurchaseItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load'));
          }

          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (context, i) {
                final title = snapshot.data![i].item.value!.name!;
                final qty = snapshot.data![i].qty;
                final id = snapshot.data![i].id;
                return ListTile(
                  onTap: () => _openQtyControl(),
                  title: Text(title),
                  subtitle: Text('Purchase item ID: $id'),
                  trailing: _Qty(qty: qty!),
                );
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: snapshot.data!.length,
            );
          }

          return Center(child: Text('No data'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onCreateInvoice(),
        icon: Icon(Icons.upload_file),
        label: Text('Create invoice'),
      ),
    );
  }

  void _openStore() {
    final db = IsarService();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<List<Item>>(
          stream: db.streamItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Failed to load'));
            }

            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, i) {
                  final title = snapshot.data![i].name!;
                  return ListTile(
                    title: Text(title),
                    trailing: Transform.flip(
                      flipX: true,
                      child: Icon(
                        Icons.arrow_outward,
                      ),
                    ),
                    onTap: () => _onAddPurchaseItem(db, snapshot.data![i]),
                  );
                },
                separatorBuilder: (context, _) => Divider(height: 0),
                itemCount: snapshot.data!.length,
              );
            }

            return Center(child: Text('No data'));
          },
        );
      },
    );
  }

  Future<void> _onAddPurchaseItem(IsarService isar, Item item) async {
    final purchaseItem = PurchaseItem()
      ..item.value = item
      ..qty = 1;
    await isar.savePurchaseItem(purchaseItem);
  }

  Future<void> _onCreateInvoice() async {
    final nav = Navigator.of(context);
    final items = await _db.findAllPurchaseItems();
    final arguments = PreviewArgs(_store!, _recipient, items);
    nav.pushNamed('/preview', arguments: arguments);
  }

  void _openQtyControl() {
    // TODO: implement qty control
  }
}

class _RecipientButton extends StatelessWidget {
  const _RecipientButton({
    required this.onPressed,
    this.leadingText = 'To',
    this.recipientName = 'Recipient',
  });

  final VoidCallback onPressed;
  final String leadingText;
  final String recipientName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4.0,
              children: [
                Text(
                  leadingText,
                  style: textTheme.bodySmall,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: colors.surfaceTint,
                ),
              ],
            ),
            Text(
              recipientName,
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _Qty extends StatelessWidget {
  const _Qty({required this.qty});

  final int qty;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.primaryContainer,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 2.0,
        ),
        child: Text('$qty'),
      ),
    );
  }
}
