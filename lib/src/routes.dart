import 'package:flutter/material.dart';

import 'routes/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case '/add-item':
      return MaterialPageRoute(builder: (_) => const AddItemPage());
    case '/invoice':
      return MaterialPageRoute(builder: (_) => const InvoicePage());
    case '/preview':
      final args = settings.arguments as PreviewArgs;
      return MaterialPageRoute(
        builder: (_) => PreviewPage(
          recipient: args.recipient,
          store: args.store,
          items: args.items,
        ),
      );
    case '/store':
      return MaterialPageRoute(builder: (_) => const StorePage());
    default:
      return MaterialPageRoute(
        builder: (_) => ErrorPage(route: settings.name!),
      );
  }
}
