import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// ─── PRIORITY LABEL ───────────────────────────────────────────────────────

class PriorityLabel extends StatelessWidget {
  final String priority;

  const PriorityLabel({super.key, required this.priority});

  Color get _color {
    switch (priority) {
      case 'High':
        return AppColors.priorityHigh;
      case 'Medium':
        return AppColors.priorityMedium;
      case 'Low':
        return AppColors.priorityLow;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      priority,
      style: AppTextStyles.priorityLabel.copyWith(color: _color),
    );
  }
}

/// ─── META COLUMN ──────────────────────────────────────────────────────────
/// Label + value stacked vertically. [dark] switches text colors for
/// use on dark cards vs glass cards.

class MetaColumn extends StatelessWidget {
  final String label;
  final Widget child;
  final bool dark;

  const MetaColumn({
    super.key,
    required this.label,
    required this.child,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.metaLabel.copyWith(
            color: dark ? AppColors.textMuted : AppColors.textMutedDark,
          ),
        ),
        const SizedBox(height: 2),
        child,
      ],
    );
  }
}

/// ─── ICON PILL BUTTON ─────────────────────────────────────────────────────
/// Round icon button used in the filter bar and nav bar.

class IconPillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double size;
  final bool glass; // glass (light) vs opaque dark

  const IconPillButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 40,
    this.glass = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: glass ? const Color(0x4DFFFFFF) : const Color(0x33FFFFFF),
          border: Border.all(
            color: glass ? const Color(0x80FFFFFF) : const Color(0x40FFFFFF),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
