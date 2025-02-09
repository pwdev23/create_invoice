import 'package:flutter/material.dart';

import 'pages/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case '/add-item':
      return MaterialPageRoute(builder: (_) => const AddItemPage());
    case '/add-recipient':
      return MaterialPageRoute(builder: (_) => const AddRecipientPage());
    case '/invoice':
      final args = settings.arguments as InvoiceArgs;
      return MaterialPageRoute(
        builder: (_) => InvoicePage(
          store: args.store,
          recipient: args.recipient,
        ),
      );
    case '/preview':
      final args = settings.arguments as PreviewArgs;
      return MaterialPageRoute(
        builder: (_) => PreviewPage(
          recipient: args.recipient,
          store: args.store,
          items: args.items,
          paid: args.paid,
          daysRange: args.daysRange,
        ),
      );
    case '/edit-currency':
      final args = settings.arguments as EditCurrencyArgs;
      return MaterialPageRoute(
        builder: (_) => EditCurrencyPage(
          isInitial: args.isInitial,
          store: args.store,
          recipient: args.recipient,
        ),
      );
    case '/edit-recipient':
      final args = settings.arguments as EditRecipientArgs;
      return MaterialPageRoute(
          builder: (_) => EditRecipient(recipient: args.recipient));
    case '/edit-item':
      final args = settings.arguments as EditItemArgs;
      return MaterialPageRoute(builder: (_) => EditItemPage(item: args.item));
    case '/edit-store':
      final args = settings.arguments as EditStoreArgs;
      return MaterialPageRoute(
          builder: (_) => EditStorePage(store: args.store));
    case '/store':
      final args = settings.arguments as StoreArgs;
      return MaterialPageRoute(
        builder: (_) => StorePage(
          locale: args.locale,
          symbol: args.symbol,
        ),
      );
    case '/recipient':
      return MaterialPageRoute(builder: (_) => const RecipientPage());
    default:
      return MaterialPageRoute(
        builder: (_) => ErrorPage(route: settings.name!),
      );
  }
}
