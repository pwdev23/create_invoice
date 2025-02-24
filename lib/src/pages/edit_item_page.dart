import '../common.dart';
import '../constants.dart';
import '../isar_collection/isar_collections.dart' show Item;
import '../isar_service.dart';

class EditItemPage extends StatefulWidget {
  static const routeName = '/edit-item';

  const EditItemPage({super.key, required this.item});

  final Item item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late Item _editedItem;
  final _db = IsarService();
  final _formKey = GlobalKey<FormState>();
  final _skuCon = TextEditingController();
  final _nameCon = TextEditingController();
  final _priceCon = TextEditingController();
  final _discCon = TextEditingController();
  bool _isPercent = false;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.item;
    _skuCon.text = widget.item.sku!;
    _nameCon.text = widget.item.name!;
    _priceCon.text = '${widget.item.price}';
    _discCon.text = '${widget.item.discount}';
    _isPercent = widget.item.isPercentage!;
  }

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
    final valid = _isValid(_formKey) && _nameCon.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editItem)),
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
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: valid ? () => _onEditItem() : null,
        disabledElevation: 0,
        backgroundColor: valid ? colors.primaryContainer : disabledColor,
        foregroundColor: valid ? colors.onPrimaryContainer : disabledColor,
        icon: Icon(Icons.done),
        label: Text(l10n.save),
      ),
    );
  }

  Future<void> _onEditItem() async {
    final nav = Navigator.of(context);
    final p = _priceCon.text.isEmpty ? 0.0 : double.parse(_priceCon.text);
    final d = _discCon.text.isEmpty ? 0.0 : double.parse(_discCon.text);
    _editedItem.sku = _skuCon.text.isEmpty ? '' : _skuCon.text.trim();
    _editedItem.name = _nameCon.text.isEmpty ? '' : _nameCon.text.trim();
    _editedItem.price = p;
    _editedItem.discount = d;
    _editedItem.isPercentage = _isPercent;
    await _db.updateItem(_editedItem);
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

class EditItemArgs {
  const EditItemArgs(this.item);

  final Item item;
}
