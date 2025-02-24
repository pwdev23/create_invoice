import '../common.dart';
import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Recipient;
import '../isar_service.dart';

class EditRecipient extends StatefulWidget {
  static const routeName = '/edit-recipient';

  const EditRecipient({super.key, required this.recipient});

  final Recipient recipient;

  @override
  State<EditRecipient> createState() => _EditRecipientState();
}

class _EditRecipientState extends State<EditRecipient> {
  late Recipient _recipient;
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _addr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.recipient.name!;
    _addr.text = widget.recipient.address!;
  }

  @override
  void dispose() {
    _name.dispose();
    _addr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editRecipient)),
      body: SingleChildScrollView(
        child: Container(
          color: colors.surface,
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: l10n.randomPerson,
                      label: Text(l10n.name),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _addr,
                    decoration: InputDecoration(
                      hintText: 'Planet earth',
                      label: Text(l10n.address),
                    ),
                    keyboardType: TextInputType.streetAddress,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _name.text.isEmpty || _addr.text.isEmpty ? null : _onSave,
        disabledElevation: 0,
        backgroundColor:
            _name.text.isEmpty || _addr.text.isEmpty
                ? disabledColor
                : colors.primaryContainer,
        foregroundColor:
            _name.text.isEmpty || _addr.text.isEmpty
                ? disabledColor
                : colors.onPrimaryContainer,
        label: Text(l10n.save),
        icon: Icon(Icons.done),
      ),
    );
  }

  Future<void> _onSave() async {
    final nav = Navigator.of(context);
    _recipient = widget.recipient;
    _recipient.name = _name.text.trim();
    _recipient.address = _addr.text.trim();
    await _db.updateRecipient(_recipient);
    nav.pop();
  }
}

class EditRecipientArgs {
  const EditRecipientArgs(this.recipient);

  final Recipient recipient;
}
