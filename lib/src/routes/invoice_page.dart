import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import 'invoice_state.dart';
import 'preview_page.dart' show PreviewArgs;

class InvoicePage extends StatefulWidget {
  static const String routeName = '/invoice';

  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final _db = IsarService();
  late Store? _store;
  final _recipient = Recipient()
    ..name = 'My customer'
    ..address = 'Padalarang';

  Future<void> _findFirstStore() async {
    _store = await _db.findFirstStore();
  }

  @override
  void initState() {
    super.initState();
    _findFirstStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To: ${_recipient.name}'),
        actions: [
          TextButton(
            onPressed: () => onManageStore(context),
            child: Text('Manage store'),
          )
        ],
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
                return ListTile(title: Text(title));
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: snapshot.data!.length,
            );
          }

          return Center(child: Text('No data'));
        },
      ),
      floatingActionButton: SpeedDial(
        children: [
          SpeedDialChild(
            label: 'Add item',
            onTap: () => _openStore(),
            child: Icon(Icons.add),
          ),
          SpeedDialChild(
            label: 'Create invoice',
            child: Icon(Icons.upload_file),
            onTap: () => _onCreateInvoice(),
          )
        ],
        child: Icon(Icons.edit),
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
}
