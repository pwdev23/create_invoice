import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class EmptyIndicator extends StatelessWidget {
  const EmptyIndicator({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final platformBrightness = MediaQuery.of(context).platformBrightness;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          platformBrightness == Brightness.dark
              ? _SizedRiveAnimation(asset: 'img/inbox_dark.riv')
              : _SizedRiveAnimation(asset: 'img/inbox_light.riv'),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Text(message, style: textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}

class _SizedRiveAnimation extends StatelessWidget {
  const _SizedRiveAnimation({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      asset,
      fit: BoxFit.cover,
      useArtboardSize: true,
      alignment: Alignment.center,
    );
  }
}
