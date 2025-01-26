import 'package:flutter/material.dart';

import '../utils.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onDownloadAsPdf,
        child: Icon(Icons.save),
      ),
    );
  }
}
