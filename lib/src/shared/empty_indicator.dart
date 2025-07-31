import 'package:flutter/material.dart';

class EmptyIndicator extends StatelessWidget {
  const EmptyIndicator({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;
    final asset = isDark ? 'img/inbox-dark-1.webp' : 'img/inbox-light-1.webp';

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(asset, width: 192.0),
          Text(message, style: textTheme.labelLarge),
        ],
      ),
    );
  }
}
