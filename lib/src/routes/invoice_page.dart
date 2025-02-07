import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import '../shared/shared.dart';
import '../utils.dart';
import 'invoice_state.dart';
import 'preview_page.dart' show PreviewArgs;

class InvoicePage extends StatefulWidget {
  static const String routeName = '/invoice';

  const InvoicePage({super.key, required this.store, required this.recipient});

  final Store store;
  final Recipient recipient;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Recipient _to;
  bool _skipLoading = false;
  final _db = IsarService();
  final _ids = <int>[];
  int _qty = 0;

  @override
  void initState() {
    super.initState();
    _to = widget.recipient;
  }

  @override
  Widget build(BuildContext context) {
    final avatar = widget.store.name![0];
    final colors = Theme.of(context).colorScheme;
    final formatted = NumberFormat.currency(locale: kLocale, symbol: kSymbol);

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
          recipientName: _to.name!,
          onPressed: () => _onOpenRecipient(),
        ),
        actions: [
          _ids.isEmpty
              ? TextButton.icon(
                  onPressed: () => _openStore(),
                  icon: Icon(Icons.add),
                  label: Text('Add item'),
                )
              : TextButton.icon(
                  onPressed: () => _onDelete(_db, _ids)
                      .then((_) => setState(() => _ids.clear())),
                  icon: Icon(Icons.delete, color: colors.error),
                  label: Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: colors.error),
                ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            _StoreInfo(name: widget.store.name!, email: widget.store.email!),
            ListTile(
              style: ListTileStyle.drawer,
              onTap: () => push(context, '/store'),
              title: Text('Manage store'),
              leading: Icon(Icons.inbox),
            ),
            Divider(height: 0.0),
            ListTile(
              style: ListTileStyle.drawer,
              onTap: () => push(context, '/recipient'),
              title: Text('Recipient'),
              leading: Icon(Icons.people),
            )
          ],
        ),
      ),
      body: StreamBuilder<List<PurchaseItem>>(
        stream: _db.streamPurchaseItems(),
        builder: (context, snapshot) {
          final waiting = snapshot.connectionState == ConnectionState.waiting;
          if (!_skipLoading && waiting) return CenterCircular();

          if (snapshot.hasError) return CenterText(text: 'Failed to load');

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return CenterText(text: 'No data');
          } else {
            return ListView.separated(
              itemBuilder: (context, i) {
                if (!_skipLoading) _skipLoading = true;
                final title = snapshot.data![i].item.value!.name!;
                final qty = snapshot.data![i].qty;
                final id = snapshot.data![i].id;
                final item = snapshot.data![i].item.value;

                return ListTile(
                  onTap: () => _openQtyControl(snapshot.data![i]),
                  onLongPress: () => setState(() => _ids.add(id)),
                  title: Text(title),
                  trailing: _Qty(qty: qty!),
                  tileColor: _ids.contains(id)
                      ? colors.primaryContainer
                      : colors.surface,
                  isThreeLine: item!.discount! > 0,
                  subtitle: item.discount == 0
                      ? Text(formatted.format(item.price))
                      : PriceTexts(item: item),
                );
              },
              separatorBuilder: (_, __) => Divider(height: 0),
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: () => _onCreateInvoice(),
        icon: Icon(Icons.upload_file),
        label: Text('Create invoice'),
      ),
    );
  }

  void _openStore() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<List<Item>>(
          stream: _db.streamItems(),
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
                    onTap: () => _onAddPurchaseItem(_db, snapshot.data![i]),
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
    final msg = ScaffoldMessenger.of(context);
    final granted = await requestPermission();
    if (granted) {
      final items = await _db.findAllPurchaseItems();
      if (items.isEmpty) {
        _onEmpty();
      } else {
        final arguments = PreviewArgs(widget.store, widget.recipient, items);
        nav.pushNamed('/preview', arguments: arguments);
      }
    } else {
      const str = 'Permission denied';
      msg.showSnackBar(SnackBar(content: Text(str)));
    }
  }

  void _onEmpty() {
    final msg = ScaffoldMessenger.of(context);
    const str = 'Can\'t proceed, there\'s no purchase item';
    msg.showSnackBar(SnackBar(content: Text(str)));
  }

  void _openQtyControl(PurchaseItem purchaseItem) {
    setState(() => _qty = purchaseItem.qty!);
    if (_ids.contains(purchaseItem.id)) {
      setState(() => _ids.remove(purchaseItem.id));
    } else if (_ids.isNotEmpty) {
      setState(() => _ids.add(purchaseItem.id));
    } else {
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            final textTheme = Theme.of(context).textTheme;
            final colors = Theme.of(context).colorScheme;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 16.0),
                      child: TextButton(
                        onPressed: () => _onSaveQty(purchaseItem),
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
                Text('$_qty', style: textTheme.displayMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.onPrimaryContainer,
                      ),
                      onPressed: _qty > 1
                          ? () => setState(() => _qty = _qty - 1)
                          : () {},
                      icon: Icon(Icons.remove),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.onPrimaryContainer,
                      ),
                      onPressed: () => setState(() => _qty = _qty + 1),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: kToolbarHeight),
              ],
            );
          },
        ),
      );
    }
  }

  Future<void> _onDelete(IsarService isar, List<int> ids) async {
    await isar.deletePurchaseItems(ids);
  }

  Future<void> _onSaveQty(PurchaseItem purchaseItem) async {
    purchaseItem.qty = _qty;
    await _db.updatePurchaseItem(purchaseItem);
    _closeQtyControl();
  }

  void _closeQtyControl() {
    final nav = Navigator.of(context);
    nav.pop();
  }

  Future<void> _onOpenRecipient() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<List<Recipient>>(
          stream: _db.streamRecipients(),
          builder: (context, snapshot) {
            final waiting = snapshot.connectionState == ConnectionState.waiting;
            if (waiting) return CenterCircular();

            if (snapshot.hasError) return CenterText(text: 'Failed to load');

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return CenterText(text: 'No data');
            } else {
              return ListView.separated(
                itemBuilder: (context, i) {
                  final r = snapshot.data![i];

                  return ListTile(
                    title: Text(r.name!),
                    onTap: () => _onChooseRecipient(r),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 0.0),
                itemCount: snapshot.data!.length,
              );
            }
          },
        );
      },
    );
  }

  void _onChooseRecipient(Recipient recipient) {
    final nav = Navigator.of(context);
    if (_to.id != recipient.id) setState(() => _to = recipient);
    nav.pop();
  }
}

class InvoiceArgs {
  const InvoiceArgs(this.store, this.recipient);

  final Store store;
  final Recipient recipient;
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
    final minMax = BoxConstraints(minWidth: 88.0, maxWidth: double.infinity);

    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: ConstrainedBox(
          constraints: minMax,
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
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
        ),
      ],
    );
  }
}

class _StoreInfo extends StatelessWidget {
  const _StoreInfo({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 180.0,
      color: colors.primaryContainer,
      alignment: Alignment.bottomLeft,
      child: Text.rich(
        style: TextStyle(color: colors.onPrimaryContainer),
        TextSpan(
          text: '$name\n',
          children: [
            TextSpan(text: email),
          ],
        ),
      ),
    );
  }
}
