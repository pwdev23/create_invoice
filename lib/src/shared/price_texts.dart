import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../isar_collection/isar_collections.dart' show Item;
import '../routes/preview_state.dart';

class PriceTexts extends StatelessWidget {
  const PriceTexts({
    super.key,
    required this.item,
    required this.locale,
    required this.symbol,
  });

  final Item item;
  final String locale;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final calc = calcDiscount(item.price!, item.discount!, item.isPercentage!);
    final colors = Theme.of(context).colorScheme;
    final formatted = NumberFormat.currency(locale: locale, symbol: symbol);

    return Text.rich(
      TextSpan(
        text: '${formatted.format(item.price)}\n',
        style: TextStyle(decoration: TextDecoration.lineThrough),
        children: [
          TextSpan(
            text: formatted.format(calc),
            style: TextStyle(
              color: colors.onSurface,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
