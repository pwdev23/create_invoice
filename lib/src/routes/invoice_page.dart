import 'package:flutter/material.dart';

import '../isar_collection/isar_collections.dart';
import '../isar_collection/isar_service.dart';
import 'invoice_state.dart';

class InvoicePage extends StatelessWidget {
  static const String routeName = '/invoice';

  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = IsarService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        actions: [
          TextButton(
            onPressed: () => onManageStore(context),
            child: Text('Manage store'),
          )
        ],
      ),
      body: StreamBuilder<List<PurchaseItem>>(
        stream: db.streamPurchaseItems(),
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
                final title = snapshot.data![i].item.value!.name!;
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
}
