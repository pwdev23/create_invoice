import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';

class AuthPage extends StatefulWidget {
  static const String routeName = '/';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _db = IsarService();

  @override
  void initState() {
    super.initState();
    _auth().then((_) => _toHome());
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
    final stores = await _db.findAllStores();
    final count = stores.length;
    if (count == 0) {
      final store = Store()
        ..email = 'info@store.com'
        ..name = 'My store';
      await _db.saveStore(store);
    }
  }

  Future<void> _auth() async {
    await _initStore();
    await Future.delayed(const Duration(seconds: 2));
  }

  void _toHome() {
    final nav = Navigator.of(context);
    nav.pushReplacementNamed('/invoice');
  }
}
