import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_collection/isar_service.dart';

class AddItemPage extends StatefulWidget {
  static const routeName = '/add-item';

  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _skuCon = TextEditingController();
  final _nameCon = TextEditingController();
  final _priceCon = TextEditingController();
  final _discCon = TextEditingController();
  bool _isPercent = false;

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    final colors = Theme.of(context).colorScheme;

    const hP = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: hP,
              child: TextFormField(
                controller: _skuCon,
                decoration: InputDecoration(
                  hintText: 'SKU',
                  labelText: 'SKU',
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
            Padding(
              padding: hP,
              child: TextFormField(
                controller: _nameCon,
                decoration: InputDecoration(
                  labelText: 'Item name',
                  hintText: 'Item name',
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
            Padding(
              padding: hP,
              child: TextFormField(
                controller: _priceCon,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: '5.0',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() {}),
              ),
            ),
            Padding(
              padding: hP,
              child: TextFormField(
                controller: _discCon,
                decoration: InputDecoration(
                  labelText: 'Discount',
                  hintText: '0.0',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() {}),
              ),
            ),
            SwitchListTile.adaptive(
              title: Text('Use percentage'),
              value: _isPercent,
              onChanged: (v) => setState(() => _isPercent = v),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isValid(_formKey) && _nameCon.text.isNotEmpty
            ? () => _onAddItem()
            : null,
        disabledElevation: 0,
        backgroundColor:
            _nameCon.text.isNotEmpty ? colors.primaryContainer : disabledColor,
        foregroundColor: _nameCon.text.isNotEmpty
            ? colors.onPrimaryContainer
            : disabledColor,
        icon: Icon(Icons.add),
        label: Text('Add item'),
      ),
    );
  }

  Future<void> _onAddItem() async {
    final p = _priceCon.text.isEmpty ? 0.0 : double.parse(_priceCon.text);
    final d = _discCon.text.isEmpty ? 0.0 : double.parse(_discCon.text);
    final item = Item()
      ..sku = _skuCon.text.isEmpty ? '' : _skuCon.text.trim()
      ..name = _nameCon.text.isEmpty ? '' : _nameCon.text.trim()
      ..price = p
      ..discount = d
      ..isPercentage = _isPercent;
    await _db.saveItem(item);
    _onSaved();
  }

  void _onSaved() {
    final nav = Navigator.of(context);
    nav.popAndPushNamed('/store');
  }

  bool _isValid(GlobalKey<FormState> key) {
    return key.currentState != null
        ? key.currentState!.validate()
            ? true
            : false
        : false;
  }
}
