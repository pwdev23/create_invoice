import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';
import 'invoice_page.dart' show InvoiceArgs;

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
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> _initStore() async {
    _stores = await _db.findAllStores();
    final count = _stores.length;
    if (count == 0) {
      final store = Store()
        ..email = 'info@store.com'
        ..name = 'My store';
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
    await _initStore();
    await _initRecipient();
    await Future.delayed(const Duration(seconds: 2));
    if (_stores.isEmpty || _recipients.isEmpty) {
      _auth();
    } else {
      _toHome();
    }
  }

  void _toHome() {
    final nav = Navigator.of(context);
    final args = InvoiceArgs(_stores[0], _recipients[0]);
    nav.pushReplacementNamed('/invoice', arguments: args);
  }
}
