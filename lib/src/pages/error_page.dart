import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  static const String routeName = '/error';

  const ErrorPage({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text.rich(
          TextSpan(
            text: 'No route defined for: ',
            children: [
              TextSpan(
                text: route,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
