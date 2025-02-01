import 'package:flutter/material.dart';

import 'routes/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => AuthPage());
    case '/add-item':
      return MaterialPageRoute(builder: (_) => AddItemPage());
    case '/invoice':
      return MaterialPageRoute(builder: (_) => InvoicePage());
    case '/preview':
      final args = settings.arguments as PreviewArgs;
      return MaterialPageRoute(
          builder: (_) => PreviewPage(invoice: args.invoice));
    case '/store':
      return MaterialPageRoute(builder: (_) => StorePage());
    default:
      return MaterialPageRoute(
        builder: (_) => ErrorPage(route: settings.name!),
      );
  }
}
