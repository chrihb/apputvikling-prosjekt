import 'package:flutter/material.dart';

// General purpose square button. Used in top bar
class SquareButton extends StatelessWidget {
  const SquareButton({super.key, required this.icon, this.onPressed});

  final Icon icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: scheme.surfaceContainerHigh,
            foregroundColor: scheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.zero,
            shadowColor: scheme.shadow.withValues(alpha: 0.3),
          ),
          child: icon,
        ),
      ),
    );
  }
}
