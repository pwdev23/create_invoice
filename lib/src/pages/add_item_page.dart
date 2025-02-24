import '../common.dart';
import '../constants.dart';
import '../isar_collection/isar_collections.dart';
import '../isar_service.dart';

class AddItemPage extends StatefulWidget {
  static const routeName = '/add-item';

  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _skuCon = TextEditingController();
  final _nameCon = TextEditingController();
  final _priceCon = TextEditingController();
  final _discCon = TextEditingController();
  bool _isPercent = true;

  @override
  void dispose() {
    _skuCon.dispose();
    _nameCon.dispose();
    _priceCon.dispose();
    _discCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disabledColor = Theme.of(context).disabledColor;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addItem)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: kToolbarHeight * 2),
          color: colors.surface,
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16.0,
              children: [
                SizedBox.shrink(),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _nameCon,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: l10n.itemName,
                      hintText: l10n.itemName,
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _skuCon,
                    decoration: InputDecoration(
                      hintText: 'SKU',
                      labelText: 'SKU',
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _priceCon,
                    decoration: InputDecoration(
                      labelText: l10n.price,
                      hintText: '5.0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: kPx,
                  child: TextFormField(
                    controller: _discCon,
                    decoration: InputDecoration(
                      labelText: l10n.discount,
                      hintText: '0.0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                SwitchListTile.adaptive(
                  title: Text(l10n.usePercentage),
                  value: _isPercent,
                  onChanged: (v) => setState(() => _isPercent = v),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            _isValid(_formKey) && _nameCon.text.isNotEmpty
                ? () => _onAddItem()
                : null,
        disabledElevation: 0,
        backgroundColor:
            _nameCon.text.isNotEmpty ? colors.primaryContainer : disabledColor,
        foregroundColor:
            _nameCon.text.isNotEmpty
                ? colors.onPrimaryContainer
                : disabledColor,
        icon: Icon(Icons.add),
        label: Text(l10n.addItem),
      ),
    );
  }

  Future<void> _onAddItem() async {
    final p = _priceCon.text.isEmpty ? 0.0 : double.parse(_priceCon.text);
    final d = _discCon.text.isEmpty ? 0.0 : double.parse(_discCon.text);
    final item =
        Item()
          ..sku = _skuCon.text.isEmpty ? '' : _skuCon.text.trim()
          ..name = _nameCon.text.isEmpty ? '' : _nameCon.text.trim()
          ..price = p
          ..discount = d
          ..isPercentage = _isPercent;
    await _db.saveItem(item);
    _onSaved();
  }

  void _onSaved() {
    final nav = Navigator.of(context);
    nav.pop();
  }

  bool _isValid(GlobalKey<FormState> key) {
    return key.currentState != null
        ? key.currentState!.validate()
            ? true
            : false
        : false;
  }
}
