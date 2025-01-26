import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: onCreatePdf,
          child: Text('Create PDF'),
        ),
      ),
    );
  }

  Future<void> onCreatePdf() async {}
}
