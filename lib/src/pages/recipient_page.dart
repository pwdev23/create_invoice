import '../common.dart';
import '../isar_collection/isar_collections.dart' show Recipient;
import '../isar_service.dart';
import '../shared/shared.dart';
import 'edit_recipient.dart';

class RecipientPage extends StatefulWidget {
  static const routeName = '/recipient';

  const RecipientPage({super.key});

  @override
  State<RecipientPage> createState() => _RecipientPageState();
}

class _RecipientPageState extends State<RecipientPage> {
  final _db = IsarService();
  bool _skipLoading = false;
  final _ids = <int>[];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nav = Navigator.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recipient),
        actions: [
          _ids.isEmpty
              ? TextButton.icon(
                  onPressed: () => nav.pushNamed('/add-recipient'),
                  label: Text(l10n.addRecipient),
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
      body: StreamBuilder<List<Recipient>>(
        stream: _db.streamRecipients(),
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
                final ellipsis = TextStyle(overflow: TextOverflow.ellipsis);

                return ListTile(
                  title: Text(t.name!, style: ellipsis),
                  subtitle: Text(t.address!),
                  onTap: () => _onTap(t),
                  onLongPress: () => _onLongPressed(t.id),
                  trailing: Icon(Icons.edit),
                  tileColor: _ids.contains(t.id)
                      ? colors.primaryContainer
                      : colors.surface,
                );
              },
              separatorBuilder: (_, __) => Divider(height: 0.0),
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
    );
  }

  void _onTap(Recipient recipient) {
    if (_ids.isEmpty) {
      final nav = Navigator.of(context);
      final args = EditRecipientArgs(recipient);
      nav.pushNamed('/edit-recipient', arguments: args);
    } else {
      if (_ids.contains(recipient.id)) {
        _ids.remove(recipient.id);
      } else {
        _ids.add(recipient.id);
      }
      setState(() {});
    }
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

  Future<void> _onDelete(List<int> ids) async {
    await _db.deleteRecipients(ids);
    setState(() => _ids.clear());
  }
}
