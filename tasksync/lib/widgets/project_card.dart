import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tasksync/data/models/project_model.dart';
import 'package:tasksync/theme/theme.dart';
import 'package:tasksync/widgets/avatar_widget.dart';
import 'package:tasksync/widgets/badge_widgets.dart';

/// ─── PROJECT CARD ─────────────────────────────────────────────────────────
/// Routes to GlassProjectCard or DarkProjectCard based on [project.cardType].

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return switch (project.cardType) {
      CardType.glass => GlassProjectCard(project: project, onTap: onTap),
      CardType.dark => DarkProjectCard(project: project, onTap: onTap),
    };
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

/// Project initial badge (colored square with letter)
class _InitialBadge extends StatelessWidget {
  final Project project;

  const _InitialBadge({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: project.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: project.color.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        project.title[0],
        style: const TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Card header row: initial badge + title/category + edit icon
class _CardHeader extends StatelessWidget {
  final Project project;
  final bool dark;

  const _CardHeader({required this.project, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InitialBadge(project: project),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: AppTextStyles.cardTitle.copyWith(
                  color: dark ? AppColors.textLight : AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                project.category,
                style: AppTextStyles.categoryLabel.copyWith(
                  color: dark ? AppColors.textMuted : AppColors.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.edit_outlined,
          size: 16,
          color: dark ? AppColors.textMuted : AppColors.textMutedDark,
        ),
      ],
    );
  }
}

/// Meta row: Date / Status / Priority
class _CardMeta extends StatelessWidget {
  final Project project;
  final bool dark;

  const _CardMeta({required this.project, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MetaColumn(
          label: 'Date',
          dark: dark,
          child: Text(
            project.date,
            style: AppTextStyles.metaValue.copyWith(
              color: dark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 22),
        MetaColumn(
          label: 'Status',
          dark: dark,
          child: Text(
            project.status,
            style: AppTextStyles.metaValueRegular.copyWith(
              color: dark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 22),
        MetaColumn(
          label: 'Priority',
          dark: dark,
          child: PriorityLabel(priority: project.priority),
        ),
      ],
    );
  }
}

/// Thin progress bar
class _ProgressBar extends StatelessWidget {
  final int completion;
  final bool dark;

  const _ProgressBar({required this.completion, required this.dark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: completion / 100,
        minHeight: 3,
        backgroundColor: dark
            ? Colors.white.withOpacity(0.10)
            : Colors.black.withOpacity(0.12),
        valueColor: AlwaysStoppedAnimation<Color>(
          dark
              ? Colors.white.withOpacity(0.50)
              : Colors.black.withOpacity(0.38),
        ),
      ),
    );
  }
}

/// Footer row: avatar stack + people count + call btn + more btn
class _CardFooter extends StatelessWidget {
  final Project project;
  final bool dark;

  const _CardFooter({required this.project, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar stack
        AvatarStack(people: project.people, size: 25, max: 3),
        const SizedBox(width: 10),

        // Count label
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: dark ? AppColors.textMuted : AppColors.textMutedDark,
              ),
              children: [
                TextSpan(
                  text: '${project.people.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' people in this project'),
              ],
            ),
          ),
        ),

        // Call button
        _ActionButton(
          dark: dark,
          child: const Icon(
            Icons.phone_outlined,
            size: 16,
            color: AppColors.accentGreen,
          ),
          circular: true,
          bgColor: AppColors.accentGreenBg,
          borderColor: AppColors.callBtnBorder,
        ),
        const SizedBox(width: 8),

        // More button
        _ActionButton(
          dark: dark,
          child: Text(
            '›  ›  ›',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              color: dark ? AppColors.textMuted : AppColors.textMutedDark,
            ),
          ),
          circular: false,
          bgColor: dark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.07),
          borderColor: dark
              ? Colors.white.withOpacity(0.10)
              : Colors.black.withOpacity(0.10),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Widget child;
  final bool dark;
  final bool circular;
  final Color bgColor;
  final Color borderColor;

  const _ActionButton({
    required this.child,
    required this.dark,
    required this.circular,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: circular
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 10),
      width: circular ? 36 : null,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(circular ? 99 : 99),
        border: Border.all(color: borderColor),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// GLASS PROJECT CARD
// ═══════════════════════════════════════════════════════════════════════════════

class GlassProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;

  const GlassProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  State<GlassProjectCard> createState() => _GlassProjectCardState();
}

class _GlassProjectCardState extends State<GlassProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevation = Tween<double>(
      begin: 0,
      end: -3,
    ).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _elevation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _elevation.value),
          child: child,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardGlass,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.cardGlassBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5A2814).withOpacity(0.16),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(project: widget.project, dark: false),
                    const SizedBox(height: 14),
                    _CardMeta(project: widget.project, dark: false),
                    const SizedBox(height: 10),
                    _ProgressBar(
                      completion: widget.project.completion,
                      dark: false,
                    ),
                    const SizedBox(height: 10),
                    _CardFooter(project: widget.project, dark: false),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DARK PROJECT CARD
// ═══════════════════════════════════════════════════════════════════════════════

class DarkProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;

  const DarkProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  State<DarkProjectCard> createState() => _DarkProjectCardState();
}

class _DarkProjectCardState extends State<DarkProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevation = Tween<double>(
      begin: 0,
      end: -3,
    ).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _elevation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _elevation.value),
          child: child,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardDarkBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(project: widget.project, dark: true),
                    const SizedBox(height: 14),
                    _CardMeta(project: widget.project, dark: true),
                    const SizedBox(height: 10),
                    _ProgressBar(
                      completion: widget.project.completion,
                      dark: true,
                    ),
                    const SizedBox(height: 10),
                    _CardFooter(project: widget.project, dark: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
