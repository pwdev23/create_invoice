import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart' show Store, Recipient;
import '../isar_service.dart';
import '../shared/center_circular.dart';
import 'edit_currency_page.dart' show EditCurrencyArgs;
import 'invoice_page.dart' show InvoiceArgs;

const note =
    'Thank you for your business! Please complete the remaining balance by the due date to avoid late fees. If you have any questions, feel free to contact us.';

class AuthPage extends StatefulWidget {
  static const String routeName = '/';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _db = IsarService();
  late List<Store> _stores;
  late List<Recipient> _recipients;

  @override
  void initState() {
    super.initState();
    _auth();
  }

  @override
  Widget build(BuildContext context) => Material(child: CenterCircular());

  Future<void> _initStore() async {
    _stores = await _db.findAllStores();
    final count = _stores.length;
    if (count == 0) {
      final store = Store()
        ..email = 'info@store.com'
        ..name = 'My store'
        ..bankName = ''
        ..accountNumber = ''
        ..swiftCode = ''
        ..tax = 0
        ..thankNote = note
        ..locale = ''
        ..symbol = '';
      await _db.saveStore(store);
    }
  }

  Future<void> _initRecipient() async {
    _recipients = await _db.findAllRecipients();
    final count = _recipients.length;
    if (count == 0) {
      final recipient = Recipient()
        ..name = 'My customer'
        ..address = 'Planet earth';
      await _db.saveRecipient(recipient);
    }
  }

  Future<void> _auth() async {
    final nav = Navigator.of(context);
    await _initStore();
    await _initRecipient();
    await Future.delayed(const Duration(seconds: 2));
    if (_stores.isEmpty || _recipients.isEmpty) {
      _auth();
    } else {
      if (_stores[0].locale == '') {
        final editArgs = EditCurrencyArgs(
          isInitial: true,
          store: _stores[0],
          recipient: _recipients[0],
        );
        nav.pushReplacementNamed('/edit-currency', arguments: editArgs);
      } else {
        final args = InvoiceArgs(_stores[0], _recipients[0]);
        nav.pushReplacementNamed('/invoice', arguments: args);
      }
    }
  }
}
