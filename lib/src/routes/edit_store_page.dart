import 'package:flutter/material.dart';

import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Store;
import '../isar_service.dart';

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

  @override
  void initState() {
    super.initState();
    _editedStore = widget.store;
    _email.text = widget.store.email!;
    _name.text = widget.store.name!;
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
      ),
    );
  }

  Future<void> _onSave() async {
    final nav = Navigator.of(context);
    _editedStore.name = _name.text.trim();
    _editedStore.email = _email.text.trim();
    await _db.updateStore(_editedStore);
    nav.pushNamedAndRemoveUntil('/', (_) => false);
  }
}

class EditStoreArgs {
  const EditStoreArgs(this.store);

  final Store store;
}
