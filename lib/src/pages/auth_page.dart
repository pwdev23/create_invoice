import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart' show Store, Recipient;
import '../isar_service.dart';
import '../shared/center_circular.dart';
import 'edit_currency_page.dart' show EditCurrencyArgs;
import 'invoice_page.dart' show InvoiceArgs;

class AuthPage extends StatefulWidget {
  static const String routeName = '/';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _db = IsarService();
  late Store? _store;
  late Recipient? _recipient;

  @override
  void initState() {
    super.initState();
    _auth();
  }

  @override
  Widget build(BuildContext context) => Material(child: CenterCircular());

  Future<void> _initStore() async {
    final stores = await _db.findAllStores();
    final count = stores.length;
    if (count == 0) {
      _store = null;
      final store = Store()
        ..email = 'info@store.com'
        ..name = 'My store'
        ..bankName = ''
        ..accountNumber = ''
        ..accountHolderName = ''
        ..swiftCode = ''
        ..tax = 0
        ..thankNote = ''
        ..locale = ''
        ..symbol = ''
        ..color = 'white'
        ..address = ''
        ..phoneNumber = '';
      await _db.saveStore(store);
    } else {
      _store = stores[0];
    }
  }

  Future<void> _initRecipient() async {
    final count = await _db.countRecipients();
    if (count == 0) {
      _recipient = null;
      for (var i = 0; i < 2; i++) {
        final recipient = Recipient()
          ..name = 'My customer ${i + 1}'
          ..address = 'Planet earth'
          ..pinned = true;
        await _db.saveRecipient(recipient);
      }
    } else {
      _recipient = await _db.findPinnedRecipients();
    }
  }

  Future<void> _auth() async {
    final nav = Navigator.of(context);
    await _initStore();
    await _initRecipient();
    await Future.delayed(const Duration(seconds: 2));
    if (_store == null || _recipient == null) {
      _auth();
    } else {
      if (_store!.locale == '') {
        final editArgs = EditCurrencyArgs(
          isInitial: true,
          store: _store!,
          recipient: _recipient!,
        );
        nav.pushReplacementNamed('/edit-currency', arguments: editArgs);
      } else {
        final args = InvoiceArgs(_store!, _recipient!);
        nav.pushReplacementNamed('/invoice', arguments: args);
      }
    }
  }
}
