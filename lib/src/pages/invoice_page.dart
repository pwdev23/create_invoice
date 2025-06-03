import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../common.dart';
import '../constants.dart';
import '../enumerations.dart';
import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import '../shared/empty_indicator.dart';
import '../shared/shared.dart';
import '../utils.dart';
import 'edit_store_page.dart' show EditStoreArgs;
import 'invoice_state.dart';
import 'preview_page.dart' show PreviewArgs;
import 'preview_state.dart' show kDateFormat;
import 'set_language_page.dart' show SetLanguageArgs;
import 'item_page.dart' show ItemArgs;

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
  final _range = TextEditingController();
  late InvoiceColor _color;

  @override
  void initState() {
    super.initState();
    _color = InvoiceColor.values.firstWhere(
      (e) => e.name == widget.store.color,
      orElse: () => InvoiceColor.indigo,
    );
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final formatted = NumberFormat.currency(
      locale: widget.store.locale,
      symbol: widget.store.symbol,
    );

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: _RecipientButton(
          leadingText: l10n.billedTo,
          recipientName: _to.name!,
          onPressed: () => _onRecipient(),
        ),
        actions: [
          if (_ids.isNotEmpty)
            IconButton(
              onPressed: () => _onDelete(
                _db,
                _ids,
              ).then((_) => setState(() => _ids.clear())),
              icon: Icon(Icons.delete, color: colors.error),
              tooltip: l10n.delete,
              style: IconButton.styleFrom(foregroundColor: colors.error),
            ),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                _StoreInfo(
                  name: widget.store.name!,
                  email: widget.store.email!,
                ),
                ListTile(
                  tileColor: colors.surface,
                  style: ListTileStyle.drawer,
                  onTap: () => _onManageStore(),
                  title: Text(l10n.manageStore),
                  leading: Icon(Icons.store),
                ),
                ListTile(
                  tileColor: colors.surface,
                  style: ListTileStyle.drawer,
                  onTap: () => _onManageItem(),
                  title: Text(l10n.nItem(0)),
                  leading: Icon(Icons.inbox),
                ),
                ListTile(
                  tileColor: colors.surface,
                  style: ListTileStyle.drawer,
                  onTap: () => push(context, '/recipient', true),
                  title: Text(l10n.recipient),
                  leading: Icon(Icons.people),
                ),
                ListTile(
                  tileColor: colors.surface,
                  style: ListTileStyle.drawer,
                  onTap: () => _onSettingLanguage(locale),
                  title: Text(l10n.languageSettings),
                  leading: Icon(Icons.translate),
                ),
                const Divider(height: 0.0),
                ListTile(
                  tileColor: colors.surface,
                  style: ListTileStyle.drawer,
                  onTap: () => onLaunchUrl(kPrivacy),
                  title: Text(l10n.privacyPolicy),
                  trailing: Icon(Icons.open_in_new),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              color: colors.surface,
              child: Text(
                getVersionText(kVersion, l10n.version, l10n.build),
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<PurchaseItem>>(
        stream: _db.streamPurchaseItems(),
        builder: (context, snapshot) {
          final waiting = snapshot.connectionState == ConnectionState.waiting;
          if (!_skipLoading && waiting) return CenterCircular();

          if (snapshot.hasError) return CenterText(text: l10n.failedToLoad);

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return EmptyIndicator(message: l10n.noData);
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        childMarginTop: 16,
        tooltip: 'Actions',
        heroTag: 'speed-dial-actions-hero-tag',
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            onTap: () => _oAddItem(),
            label: l10n.addItem,
            shape: const CircleBorder(),
          ),
          SpeedDialChild(
            child: Icon(Icons.edit_note_outlined),
            onTap: () => _onProceed(),
            label: l10n.fillInvoiceDetails,
            shape: const CircleBorder(),
          ),
        ],
      ),
    );
  }

  Future<void> _onProceed() async {
    final items = await _db.findAllPurchaseItems();
    if (items.isEmpty) {
      _onEmpty();
    } else {
      _onOpenDetailsForm(items);
    }
  }

  Future<void> _oAddItem() async {
    final nav = Navigator.of(context);
    final items = await _db.findAllItems();
    if (items.isEmpty) {
      final args = ItemArgs(widget.store.locale!, widget.store.symbol!);
      nav.pushNamed('/item', arguments: args);
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
                final ellipsis = TextStyle(overflow: TextOverflow.ellipsis);

                return ListTile(
                  title: Text(title, style: ellipsis),
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
    final l10n = AppLocalizations.of(context)!;
    final nav = Navigator.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat(kDateFormat, locale);
    final f = 'INV_${dateFormat.format(DateTime.now())}';
    final n = _paid.text.isEmpty ? 0.0 : double.parse(_paid.text);
    _editedStore.bankName = _bank.text.trim();
    _editedStore.accountNumber = _accNum.text.trim();
    _editedStore.accountHolderName = _accName.text.trim();
    _editedStore.swiftCode = _code.text.isEmpty ? '' : _code.text.trim();
    final tax = _tax.text.isEmpty ? 0 : double.parse(_tax.text);
    _editedStore.tax = tax.toDouble();
    final range = _range.text.isEmpty ? 1 : extractNumbers(_range.text);
    _editedStore.color = _color.name;
    if (_editedStore.thankNote!.isEmpty) {
      _editedStore.thankNote = l10n.thankNote;
    }
    await _db.updateStore(_editedStore);
    final args = PreviewArgs(_editedStore, _to, items, n, range, locale, f);
    nav.pushNamed('/preview', arguments: args);
  }

  void _onOpenDetailsForm(List<PurchaseItem> items) {
    final l10n = AppLocalizations.of(context)!;
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
                Header(title: l10n.invoiceDetails),
                _PaddedRow(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _paid,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '0',
                          label: Text(l10n.paid),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: TextFormField(
                        controller: _range,
                        decoration: InputDecoration(
                          hintText: '1',
                          label: Text(l10n.dueDateRange),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                _DividerText(text: l10n.paymentDetails),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _bank,
                    decoration: InputDecoration(
                      hintText: 'My money bank',
                      label: Text(l10n.bank),
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
                      label: Text(l10n.accountNumber),
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
                      hintText: l10n.randomPerson,
                      label: Text(l10n.accountHolderName),
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
                      label: Text(l10n.swiftCode),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                _DividerText(text: '${l10n.tax} (${l10n.inPercent})'),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _tax,
                    decoration: InputDecoration(hintText: '0'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                _DividerText(text: 'Color'),
                SingleChildScrollView(
                  padding: kPx,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(InvoiceColor.values.length, (i) {
                      final color = InvoiceColor.values[i];
                      final borderColor = color == InvoiceColor.white
                          ? Colors.black12
                          : Colors.transparent;
                      return _ColorDot(
                        onPressed: () => setState(() => _color = color),
                        fillColor: getInvoiceColor(color)!,
                        selected: _color == color,
                        inactiveBorderColor: borderColor,
                        activeBorderColor: Colors.blue,
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton.icon(
                    onPressed:
                        _bank.text.isEmpty ||
                            _accNum.text.isEmpty ||
                            _accName.text.isEmpty
                        ? null
                        : () => _onCreateInvoice(items),
                    label: Text(l10n.appTitle),
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
    final l10n = AppLocalizations.of(context)!;
    final msg = ScaffoldMessenger.of(context);
    msg.showSnackBar(SnackBar(content: Text(l10n.noPurchaseItem)));
  }

  void _openQtyControl(PurchaseItem purchaseItem) {
    final l10n = AppLocalizations.of(context)!;

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
                        child: Text(l10n.save),
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
                final subtitle = recipients[i].address!;
                final ellipsis = TextStyle(overflow: TextOverflow.ellipsis);

                return ListTile(
                  title: Text(title, style: ellipsis),
                  subtitle: Text(subtitle, style: ellipsis),
                  trailing: _TrailingIcon(),
                  onTap: () => _onPinRecipient(recipients[i]),
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

  Future<void> _onPinRecipient(Recipient recipient) async {
    final nav = Navigator.of(context);
    if (_to.id != recipient.id) await _db.swapPinnedRecipient(_to, recipient);
    setState(() => _to = recipient);
    nav.pop();
  }

  void _onManageStore() {
    final nav = Navigator.of(context);
    final args = EditStoreArgs(widget.store);
    nav.popAndPushNamed('/edit-store', arguments: args);
  }

  void _onManageItem() {
    final nav = Navigator.of(context);
    final args = ItemArgs(widget.store.locale!, widget.store.symbol!);
    nav.popAndPushNamed('/item', arguments: args);
  }

  void _onSettingLanguage(String locale) {
    final nav = Navigator.of(context);
    final args = SetLanguageArgs(locale);
    nav.popAndPushNamed('/languages', arguments: args);
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
    final width = MediaQuery.of(context).size.width;
    final minMax = BoxConstraints(minWidth: 88.0, maxWidth: width * 0.4);

    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
                    style: textTheme.bodySmall!.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
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
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  overflow: TextOverflow.ellipsis,
                ),
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
          children: [TextSpan(text: email)],
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
    return Transform.flip(flipX: true, child: Icon(Icons.arrow_outward));
  }
}

class _PaddedRow extends StatelessWidget {
  const _PaddedRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPx,
      child: Row(children: children),
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PaddedText(
      text: text,
      style: textTheme.titleMedium,
      left: 16,
      top: 20,
      right: 16,
      bottom: 12,
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.onPressed,
    required this.fillColor,
    required this.selected,
    this.activeBorderColor = Colors.blue,
    this.inactiveBorderColor = Colors.transparent,
  });

  final VoidCallback onPressed;
  final Color fillColor;
  final bool selected;
  final Color activeBorderColor;
  final Color inactiveBorderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(
            width: 3.0,
            color: selected ? activeBorderColor : inactiveBorderColor,
          ),
        ),
        backgroundColor: fillColor,
      ),
      onPressed: onPressed,
      child: const SizedBox.shrink(),
    );
  }
}
