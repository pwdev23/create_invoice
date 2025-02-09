import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import '../shared/shared.dart';
import '../utils.dart';
import 'preview_page.dart' show PreviewArgs;
import 'store_page.dart' show StoreArgs;

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
  late Store _editedStore;
  late Recipient _to;
  bool _skipLoading = false;
  final _db = IsarService();
  final _ids = <int>[];
  int _qty = 0;
  final _paid = TextEditingController();
  final _bank = TextEditingController();
  final _accNum = TextEditingController();
  final _accName = TextEditingController();
  final _code = TextEditingController();
  final _tax = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedStore = widget.store;
    _to = widget.recipient;
  }

  @override
  void dispose() {
    _paid.dispose();
    _bank.dispose();
    _accNum.dispose();
    _accName.dispose();
    _code.dispose();
    _tax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = widget.store.name![0];
    final colors = Theme.of(context).colorScheme;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );

    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colors.surfaceTint,
              foregroundColor: colors.surface,
              shape: CircleBorder(),
            ),
            onPressed: () => _key.currentState!.openDrawer(),
            child: Text(avatar.toUpperCase()),
          ),
        ),
        title: _RecipientButton(
          leadingText: 'Billed to',
          recipientName: _to.name!,
          onPressed: () => _onRecipient(),
        ),
        actions: [
          _ids.isEmpty
              ? TextButton.icon(
                  onPressed: () => _oAddItem(),
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
              onTap: () => _onManageStore(),
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
                      : PriceTexts(
                          item: item,
                          locale: widget.store.locale!,
                          symbol: widget.store.symbol!,
                        ),
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
        onPressed: () => _onProceed(),
        label: Text('Proceed'),
      ),
    );
  }

  Future<void> _onProceed() async {
    final msg = ScaffoldMessenger.of(context);
    final granted = await requestPermission();
    if (granted) {
      final items = await _db.findAllPurchaseItems();
      if (items.isEmpty) {
        _onEmpty();
      } else {
        _onOpenDetailsForm(items);
      }
    } else {
      const str = 'Permission denied';
      msg.showSnackBar(SnackBar(content: Text(str)));
    }
  }

  Future<void> _oAddItem() async {
    final nav = Navigator.of(context);
    final items = await _db.findAllItems();
    if (items.isEmpty) {
      final args = StoreArgs(widget.store.locale!, widget.store.symbol!);
      nav.pushNamed('/store', arguments: args);
    } else {
      _openItemSheet(items);
    }
  }

  void _openItemSheet(List<Item> items) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      backgroundColor: colors.surface,
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.separated(
              padding: EdgeInsets.only(top: kToolbarHeight),
              itemBuilder: (context, i) {
                final title = items[i].name!;
                return ListTile(
                  title: Text(title),
                  trailing: _TrailingIcon(),
                  onTap: () => _onAddPurchaseItem(_db, items[i]),
                );
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: items.length,
            ),
            BottomSheetScrollHeader(),
          ],
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

  Future<void> _onCreateInvoice(List<PurchaseItem> items) async {
    final nav = Navigator.of(context);
    final n = _paid.text.isEmpty ? 0.0 : double.parse(_paid.text);
    _editedStore.bankName = _bank.text.trim();
    _editedStore.accountNumber = _accNum.text.trim();
    _editedStore.accountHolderName = _accName.text.trim();
    _editedStore.swiftCode = _code.text.isEmpty ? '' : _code.text.trim();
    final tax = _tax.text.isEmpty ? 0 : double.parse(_tax.text);
    _editedStore.tax = tax.toDouble();
    await _db.updateStore(_editedStore);
    final args = PreviewArgs(_editedStore, _to, items, n);
    nav.pushNamed('/preview', arguments: args);
  }

  void _onOpenDetailsForm(List<PurchaseItem> items) {
    final textTheme = Theme.of(context).textTheme;
    _bank.text = widget.store.bankName!;
    _accNum.text = widget.store.accountNumber!;
    _accName.text = widget.store.accountHolderName!;
    _code.text = widget.store.swiftCode!;
    _tax.text = widget.store.tax! == 0.0 ? '' : '${widget.store.tax!}';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return _ScrollableFormWithPadding(
              children: [
                Header(title: 'Invoice details'),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _paid,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: '0',
                      label: Text('Paid'),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    'Payment details',
                    style: textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _bank,
                    decoration: InputDecoration(
                      hintText: 'My money bank',
                      label: Text('Bank name'),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _accNum,
                    decoration: InputDecoration(
                      hintText: '1231231231',
                      label: Text('Account number'),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _accName,
                    decoration: InputDecoration(
                      hintText: 'Joe Taslim',
                      label: Text('Account holder name'),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _code,
                    decoration: InputDecoration(
                      hintText: 'ABCDEFGH',
                      label: Text('Swift code'),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    'Tax',
                    style: textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _tax,
                    decoration: InputDecoration(
                      hintText: '0',
                      label: Text('Tax'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Text(
                    'In percent',
                    style: textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton.icon(
                    onPressed: _bank.text.isEmpty ||
                            _accNum.text.isEmpty ||
                            _accName.text.isEmpty
                        ? null
                        : () => _onCreateInvoice(items),
                    label: Text('Create invoice'),
                    icon: Icon(Icons.upload_file),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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

  Future<void> _onRecipient() async {
    final nav = Navigator.of(context);
    final recipients = await _db.findAllRecipients();
    if (recipients.length < 2) {
      nav.pushNamed('/recipient');
    } else {
      _onOpenRecipients(recipients);
    }
  }

  void _onOpenRecipients(List<Recipient> recipients) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      backgroundColor: colors.surface,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.separated(
              padding: EdgeInsets.only(top: kToolbarHeight),
              itemBuilder: (context, i) {
                final title = recipients[i].name!;
                return ListTile(
                  title: Text(title),
                  trailing: _TrailingIcon(),
                  onTap: () => _onChooseRecipient(recipients[i]),
                );
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: recipients.length,
            ),
            BottomSheetScrollHeader(),
          ],
        );
      },
    );
  }

  Future<void> _onChooseRecipient(Recipient recipient) async {
    final nav = Navigator.of(context);
    if (_to.id != recipient.id) {
      _to.pinned = false;
      await _db.updateRecipient(_to);
      recipient.pinned = true;
      await _db.updateRecipient(recipient);
      setState(() => _to = recipient);
    }
    nav.pop();
  }

  void _onManageStore() {
    final nav = Navigator.of(context);
    final args = StoreArgs(widget.store.locale!, widget.store.symbol!);
    nav.pushNamed('/store', arguments: args);
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

class _ScrollableFormWithPadding extends StatelessWidget {
  const _ScrollableFormWithPadding({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            spacing: 0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon();

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: true,
      child: Icon(
        Icons.arrow_outward,
      ),
    );
  }
}
