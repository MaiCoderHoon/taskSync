import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// ─── GRADIENT BACKGROUND ──────────────────────────────────────────────────
/// Wraps a screen with the warm rose-brown gradient used across
/// all Lead & Detail screens.

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.48, 1.0],
          colors: [
            AppColors.bgGradientStart,
            AppColors.bgGradientMid,
            AppColors.bgGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}
