import 'package:intl/intl.dart';

import '../common.dart';
import '../isar_collection/isar_collections.dart' show Item;
import '../isar_service.dart';
import '../shared/shared.dart';
import 'edit_item_page.dart' show EditItemArgs;

class ItemPage extends StatefulWidget {
  static const routeName = '/item';

  const ItemPage({super.key, required this.locale, required this.symbol});

  final String locale;
  final String symbol;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final _db = IsarService();
  bool _skipLoading = false;
  final _ids = <int>[];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final formatted = NumberFormat.currency(
      locale: widget.locale,
      symbol: widget.symbol,
    );

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<List<Item>>(
          stream: _db.streamItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Text(l10n.nItem(0));
            } else {
              final count = snapshot.data != null ? snapshot.data!.length : 0;
              return Text(l10n.nItem(count));
            }
          },
        ),
        actions: [
          _ids.isEmpty
              ? TextButton.icon(
                  onPressed: () => _onAddItem(),
                  label: Text(l10n.addItem),
                  icon: Icon(Icons.add),
                )
              : TextButton.icon(
                  onPressed: () => _onDelete(_ids),
                  label: Text(l10n.delete),
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

          if (snapshot.hasError) return CenterText(text: l10n.failedToLoad);

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return CenterText(text: l10n.noData);
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

class ItemArgs {
  const ItemArgs(this.locale, this.symbol);

  final String locale;
  final String symbol;
}
