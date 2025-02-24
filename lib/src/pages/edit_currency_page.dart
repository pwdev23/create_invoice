import '../common.dart';
import '../isar_collection/isar_collections.dart' show Store, Recipient;
import '../isar_service.dart';
import 'edit_currency_state.dart';
import 'invoice_page.dart' show InvoiceArgs;

class EditCurrencyPage extends StatefulWidget {
  static const routeName = '/edit-currency';

  const EditCurrencyPage({
    super.key,
    this.isInitial = false,
    required this.store,
    required this.recipient,
  });

  final bool isInitial;
  final Store store;
  final Recipient recipient;

  @override
  State<EditCurrencyPage> createState() => _EditCurrencyPageState();
}

class _EditCurrencyPageState extends State<EditCurrencyPage> {
  late Store _store;
  late Currency _curr;
  final _db = IsarService();

  @override
  void initState() {
    super.initState();
    _store = widget.store;
    _curr = getCurrency(widget.store.locale!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.isInitial ? l10n.selectCurrency : l10n.editCurrency;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        itemBuilder: (context, i) {
          final curr = Currency.values[i];
          final symbol = symbols[curr];
          final name = curr.name.replaceAll('_', '');
          final title = '${name.toUpperCase()} ($symbol)';

          return RadioListTile.adaptive(
            controlAffinity: ListTileControlAffinity.trailing,
            value: curr,
            groupValue: _curr,
            title: Text(title),
            onChanged: (v) => _onChanged(v!),
          );
        },
        separatorBuilder: (_, __) => Divider(height: 0.0),
        itemCount: Currency.values.length,
      ),
      floatingActionButton:
          widget.isInitial
              ? FloatingActionButton.extended(
                onPressed: () => _onContinue(),
                label: Text(l10n.cont),
                icon: Icon(Icons.arrow_forward),
              )
              : null,
    );
  }

  Future<void> _onContinue() async {
    final nav = Navigator.of(context);
    final shouldUpdateStore = _store.locale == '' || _store.symbol == '';
    if (_store.locale == '') _store.locale = getLocale(_curr);
    if (_store.symbol == '') _store.symbol = symbols[_curr];
    if (shouldUpdateStore) await _db.updateStore(_store);
    final args = InvoiceArgs(_store, widget.recipient);
    nav.pushReplacementNamed('/invoice', arguments: args);
  }

  Future<void> _onChanged(Currency currency) async {
    setState(() => _curr = currency);
    _store.locale = getLocale(currency);
    _store.symbol = symbols[currency];
    await _db.updateStore(_store);
  }
}

class EditCurrencyArgs {
  const EditCurrencyArgs({
    this.isInitial = false,
    required this.store,
    required this.recipient,
  });

  final bool isInitial;
  final Store store;
  final Recipient recipient;
}
