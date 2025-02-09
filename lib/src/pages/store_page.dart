import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../isar_collection/isar_collections.dart' show Store, Item;
import '../isar_service.dart';
import '../shared/shared.dart';
import 'edit_item_page.dart' show EditItemArgs;
import 'edit_store_page.dart' show EditStoreArgs;

class StorePage extends StatefulWidget {
  static const routeName = '/store';

  const StorePage({super.key, required this.locale, required this.symbol});

  final String locale;
  final String symbol;

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final _db = IsarService();
  bool _skipLoading = false;
  final _ids = <int>[];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final formatted = NumberFormat.currency(
      locale: widget.locale,
      symbol: widget.symbol,
    );

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<List<Store>>(
          stream: _db.streamStores(),
          builder: (context, snapshot) {
            final waiting = snapshot.connectionState == ConnectionState.waiting;
            if (!_skipLoading && waiting) return SizedBox.shrink();

            if (snapshot.hasError) return SizedBox.shrink();

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            } else {
              final s = snapshot.data![0];
              return _StoreInfoButton(
                email: s.email!,
                name: s.name!,
                onPressed: () => _onEditStoreInfo(s),
              );
            }
          },
        ),
        actions: [
          _ids.isEmpty
              ? TextButton.icon(
                  onPressed: () => _onAddItem(),
                  label: Text('Add item'),
                  icon: Icon(Icons.add),
                )
              : TextButton.icon(
                  onPressed: () => _onDelete(_ids),
                  label: Text('Delete'),
                  icon: Icon(Icons.delete, color: colors.error),
                  style: TextButton.styleFrom(foregroundColor: colors.error),
                ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: _db.streamItems(),
        builder: (context, snapshot) {
          final waiting = snapshot.connectionState == ConnectionState.waiting;
          if (!_skipLoading && waiting) return CenterCircular();

          if (snapshot.hasError) return CenterText(text: 'Failed to load');

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return CenterText(text: 'No data');
          } else {
            return ListView.separated(
              itemBuilder: (context, i) {
                if (!_skipLoading) _skipLoading = true;
                final t = snapshot.data![i];
                final title = t.name;
                final id = t.id;

                return ListTile(
                  title: Text(title!),
                  isThreeLine: t.discount! > 0,
                  subtitle: t.discount == 0
                      ? Text(formatted.format(t.price))
                      : PriceTexts(
                          item: t,
                          locale: widget.locale,
                          symbol: widget.symbol,
                        ),
                  trailing: _TrailingIcon(),
                  onTap: () => _onTap(t),
                  onLongPress: () => _onLongPressed(id),
                  tileColor: _ids.contains(id)
                      ? colors.primaryContainer
                      : colors.surface,
                );
              },
              separatorBuilder: (context, _) => Divider(height: 0),
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
    );
  }

  void _onAddItem() {
    final nav = Navigator.of(context);
    nav.pushNamed('/add-item');
  }

  void _onLongPressed(int id) {
    if (_ids.isEmpty) {
      _ids.add(id);
    } else {
      _ids.clear();
      _ids.add(id);
    }
    setState(() {});
  }

  void _onTap(Item item) {
    if (_ids.isEmpty) {
      final nav = Navigator.of(context);
      final args = EditItemArgs(item);
      nav.pushNamed('/edit-item', arguments: args);
    } else {
      if (_ids.contains(item.id)) {
        _ids.remove(item.id);
      } else {
        _ids.add(item.id);
      }
      setState(() {});
    }
  }

  Future<void> _onDelete(List<int> ids) async {
    await _db.deleteItems(ids);
    setState(() => _ids.clear());
  }

  void _onEditStoreInfo(Store store) {
    final nav = Navigator.of(context);
    final args = EditStoreArgs(store);
    nav.pushNamed('/edit-store', arguments: args);
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.edit),
      ],
    );
  }
}

class _StoreInfoButton extends StatelessWidget {
  const _StoreInfoButton(
      {required this.onPressed, required this.email, required this.name});

  final VoidCallback onPressed;
  final String email;
  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final minMax = BoxConstraints(minWidth: 88.0, maxWidth: double.infinity);

    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: ConstrainedBox(
          constraints: minMax,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                email,
                style: textTheme.bodySmall,
              ),
              Text(
                name,
                style: TextStyle(color: colors.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreArgs {
  const StoreArgs(this.locale, this.symbol);

  final String locale;
  final String symbol;
}
