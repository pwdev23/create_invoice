import 'package:flutter/material.dart';

class BottomSheetScrollHeader extends StatelessWidget {
  const BottomSheetScrollHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 8.0),
      width: double.infinity,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.surface,
            colors.surface,
            colors.surface,
            colors.surface.withAlpha(0),
          ],
        ),
      ),
      child: _ScrollHandle(color: colors.outline),
    );
  }
}

class _ScrollHandle extends StatelessWidget {
  const _ScrollHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: color,
      ),
    );
  }
}
