import 'package:flutter/material.dart';

class CenterCircular extends StatelessWidget {
  const CenterCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
