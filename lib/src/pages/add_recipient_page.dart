import 'package:flutter/material.dart';

import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Recipient;
import '../isar_service.dart';

class AddRecipientPage extends StatefulWidget {
  static const routeName = '/add-recipient';

  const AddRecipientPage({super.key});

  @override
  State<AddRecipientPage> createState() => _AddRecipientPageState();
}

class _AddRecipientPageState extends State<AddRecipientPage> {
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _addr = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _addr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add recipient'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.shrink(),
            Padding(
              padding: kPx,
              child: TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  hintText: 'Budi Arie',
                  label: Text('Name'),
                ),
                keyboardType: TextInputType.name,
                onChanged: (v) => setState(() {}),
              ),
            ),
            Padding(
              padding: kPx,
              child: TextFormField(
                controller: _addr,
                decoration: InputDecoration(
                  hintText: 'Planet earth',
                  label: Text('Address'),
                ),
                keyboardType: TextInputType.streetAddress,
                onChanged: (v) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _name.text.isEmpty || _addr.text.isEmpty ? null : _onSave,
        disabledElevation: 0,
        backgroundColor: _name.text.isEmpty || _addr.text.isEmpty
            ? disabledColor
            : colors.primaryContainer,
        foregroundColor: _name.text.isEmpty || _addr.text.isEmpty
            ? disabledColor
            : colors.onPrimaryContainer,
        label: Text('Add recipient'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Future<void> _onSave() async {
    final nav = Navigator.of(context);
    var recipient = Recipient()
      ..name = _name.text.trim()
      ..address = _addr.text.trim()
      ..pinned = false;
    await _db.saveRecipient(recipient);
    nav.pop();
  }
}
