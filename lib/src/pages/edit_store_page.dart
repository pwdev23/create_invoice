import 'package:flutter/material.dart';

import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Store;
import '../isar_service.dart';
import '../shared/bottom_sheet_scroll_header.dart';
import 'edit_currency_state.dart';

class EditStorePage extends StatefulWidget {
  static const routeName = '/edit-store';

  const EditStorePage({super.key, required this.store});

  final Store store;

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  late Store _editedStore;
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  late Currency _curr;

  @override
  void initState() {
    super.initState();
    _editedStore = widget.store;
    _email.text = widget.store.email!;
    _name.text = widget.store.name!;
    _curr = getCurrency(widget.store.locale!);
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit store info'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(),
            Padding(
              padding: kPx,
              child: TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  hintText: 'My store name',
                  label: Text('Store name'),
                ),
                keyboardType: TextInputType.name,
                onChanged: (v) => setState(() {}),
              ),
            ),
            Padding(
              padding: kPx,
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: 'info@mystore.com',
                  label: Text('Email'),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => setState(() {}),
              ),
            ),
            _CurrencyButton(
              title: getName(_curr),
              onPressed: () => _onEditCurrency(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _name.text.isEmpty || _email.text.isEmpty ? null : _onSave,
        disabledElevation: 0,
        backgroundColor: _name.text.isEmpty || _email.text.isEmpty
            ? disabledColor
            : colors.primaryContainer,
        foregroundColor: _name.text.isEmpty || _email.text.isEmpty
            ? disabledColor
            : colors.onPrimaryContainer,
        label: Text('Save'),
        icon: Icon(Icons.done),
      ),
    );
  }

  Future<void> _onSave() async {
    final nav = Navigator.of(context);
    _editedStore.name = _name.text.trim();
    _editedStore.email = _email.text.trim();
    _editedStore.locale = getLocale(_curr);
    _editedStore.symbol = getSymbol(_curr);
    await _db.updateStore(_editedStore);
    nav.pushNamedAndRemoveUntil('/', (_) => false);
  }

  void _onEditCurrency() {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      backgroundColor: colors.surface,
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        return Column(
          children: [
            BottomSheetScrollHeader(),
            ...List.generate(
              Currency.values.length,
              (i) => ListTile(
                title: Text(getName(Currency.values[i])),
                subtitle: Text(getSymbol(Currency.values[i])),
                onTap: () => _onSelectCurrency(Currency.values[i]),
              ),
            )
          ],
        );
      },
    );
  }

  void _onSelectCurrency(Currency currency) {
    final nav = Navigator.of(context);
    setState(() => _curr = currency);
    nav.pop();
  }
}

class EditStoreArgs {
  const EditStoreArgs(this.store);

  final Store store;
}

class _CurrencyButton extends StatelessWidget {
  const _CurrencyButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: kPx,
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(color: colors.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(title, style: textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.arrow_drop_down_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
