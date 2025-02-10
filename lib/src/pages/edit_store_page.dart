import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Store;
import '../isar_service.dart';
import '../shared/bottom_sheet_scroll_header.dart';
import '../shared/dashed_border_container.dart';
import '../shared/padded_text.dart';
import 'edit_currency_state.dart';
import 'edit_store_state.dart';
import 'preview_state.dart' show getTextLogo;

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
  final _note = TextEditingController();
  late Currency _curr;
  var _action = LogoAction.update;

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImage((v) => setState(() => _imageBytes = v));
    });
    _editedStore = widget.store;
    _email.text = widget.store.email!;
    _name.text = widget.store.name!;
    _note.text = widget.store.thankNote!;
    _curr = getCurrency(widget.store.locale!);
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;
    final textTheme = Theme.of(context).textTheme;
    final alertStyle =
        textTheme.bodySmall!.copyWith(color: colors.onTertiaryContainer);
    final textBold = TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit store info'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            _DividerText(text: 'Logo'),
            Padding(
              padding: kPx,
              child: _CompanyLogoButton(
                bytes: _imageBytes,
                name: widget.store.name!,
                action: _imageBytes != null
                    ? PopupMenuButton<LogoAction>(
                        initialValue: _action,
                        onSelected: (v) => _onSelected(v),
                        iconColor: colors.primary,
                        itemBuilder: (context) => <PopupMenuEntry<LogoAction>>[
                          const PopupMenuItem<LogoAction>(
                            value: LogoAction.update,
                            child: Text('Update'),
                          ),
                          const PopupMenuItem<LogoAction>(
                            value: LogoAction.delete,
                            child: Text('Remove'),
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () => _onPickImage(),
                        icon: Icon(Icons.edit, color: colors.primary),
                      ),
              ),
            ),
            _AlertTextBox(
              margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
              backgroundColor: colors.tertiaryContainer,
              iconColor: colors.onTertiaryContainer,
              icon: Icons.info_outline,
              child: Text.rich(
                style: alertStyle,
                TextSpan(
                  text: kLogoHelp1,
                  children: [
                    TextSpan(text: kLogoHelp2, style: textBold),
                    TextSpan(text: kLogoHelp3),
                  ],
                ),
              ),
            ),
            _DividerText(text: 'Main'),
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
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
            _CurrencyButton(
              title: getName(_curr),
              onPressed: () => _onEditCurrency(),
            ),
            _DividerText(text: 'Tank note'),
            Padding(
              padding: kPx,
              child: TextFormField(
                controller: _note,
                decoration: InputDecoration(
                  hintText: 'Thank you for your business!',
                  label: Text('Thank note'),
                ),
                keyboardType: TextInputType.text,
                maxLines: 8,
                minLines: 2,
                onChanged: (v) => setState(() {}),
              ),
            ),
            SizedBox(height: kToolbarHeight * 2),
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
    _editedStore.thankNote = _note.text.isEmpty ? kNote : _note.text.trim();
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

  Future<void> _onPickImage() async {
    await pickImage((v) => setState(() => _imageBytes = v));
  }

  Future<void> _onDelete() async {
    await removeImage();
    setState(() => _imageBytes = null);
  }

  Future<void> _onSelected(LogoAction action) async {
    switch (action) {
      case LogoAction.update:
        await _onPickImage().then((_) => setState(() => _action = action));
        break;
      default:
        await _onDelete().then((_) => setState(() => _action = action));
    }
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
              child: Icon(
                Icons.arrow_drop_down_outlined,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyLogoButton extends StatelessWidget {
  const _CompanyLogoButton({
    required this.action,
    this.bytes,
    required this.name,
  });

  final String name;
  final Uint8List? bytes;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DashedBorderContainer(
              color: colors.outline,
              strokeWidth: 1,
              dashSpace: bytes != null ? 0.0 : 3.0,
              dashWidth: 5.0,
              borderRadius: 6.0,
              child: Container(
                alignment: Alignment.center,
                width: 128.0,
                height: 128.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  image: bytes != null
                      ? DecorationImage(image: MemoryImage(bytes!))
                      : null,
                ),
                child: bytes != null
                    ? null
                    : Text(
                        getTextLogo(name),
                        style: textTheme.displaySmall,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: action,
          ),
        ],
      ),
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

class _AlertTextBox extends StatelessWidget {
  const _AlertTextBox({
    required this.backgroundColor,
    required this.icon,
    required this.child,
    required this.iconColor,
    this.margin,
  });

  final Color backgroundColor;
  final Widget child;
  final IconData icon;
  final Color iconColor;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Row(
        spacing: 12.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          Expanded(child: child),
        ],
      ),
    );
  }
}
