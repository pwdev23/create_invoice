import 'package:flutter/material.dart';
import 'package:create_invoice/src/routes/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => HomePage());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text.rich(
              TextSpan(
                text: 'No route defined for: ',
                children: [
                  TextSpan(
                    text: '${settings.name}',
                    style: const TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}
