import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';

class StorePage extends StatelessWidget {
  static const routeName = '/store';

  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = IsarService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        actions: [
          TextButton.icon(
            onPressed: () => onAddItem(context),
            label: Text('Add item'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: db.streamItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load'));
          }

          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (context, i) {
                final title = snapshot.data![i].name!;
                return ListTile(title: Text(title));
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: snapshot.data!.length,
            );
          }

          return Center(child: Text('No data'));
        },
      ),
    );
  }

  void onAddItem(BuildContext context) {
    final nav = Navigator.of(context);
    nav.popAndPushNamed('/add-item');
  }
}
