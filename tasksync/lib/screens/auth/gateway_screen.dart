import 'package:flutter/material.dart';
import 'package:tasksync/theme/theme.dart';
import 'package:tasksync/screens/auth/lead_auth.dart';
import 'package:tasksync/screens/auth/join_screen.dart';

/// ─── GATEWAY SCREEN ───────────────────────────────────────────────────────
/// Entry point — user picks their role (Lead / Co-Lead / Executive).

enum UserRole { lead, coLead, executive }

class GatewayScreen extends StatelessWidget {
  const GatewayScreen({super.key});

  static const _roles = [
    _RoleOption(
      role: UserRole.lead,
      icon: '◈',
      label: 'Project Lead',
      desc: 'Manage workspace & oversee all projects',
      accent: Color(0xFFC9906A),
    ),
    _RoleOption(
      role: UserRole.coLead,
      icon: '◇',
      label: 'Co-Lead',
      desc: 'Audit completed tasks & give feedback',
      accent: Color(0xFF8FAADC),
    ),
    _RoleOption(
      role: UserRole.executive,
      icon: '◉',
      label: 'Executive',
      desc: 'View & execute your assigned tasks',
      accent: Color(0xFF8CC88C),
    ),
  ];

  void _handleSelect(BuildContext context, UserRole role) {
    if (role == UserRole.lead) {
      Navigator.of(context).push(_fadeRoute(const LeadAuthScreen()));
    } else {
      Navigator.of(context).push(_fadeRoute(JoinScreen(role: role)));
    }
  }

  PageRoute _fadeRoute(Widget screen) => PageRouteBuilder(
    pageBuilder: (_, animation, __) =>
        FadeTransition(opacity: animation, child: screen),
    transitionDuration: const Duration(milliseconds: 280),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [Color(0xFF1A1410), Color(0xFF231B14), Color(0xFF1A1410)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // ── Header ──
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: child,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TASKSYNC',
                        style: AppTextStyles.metaLabel.copyWith(
                          color: const Color(0xFFC9A98A),
                          letterSpacing: 6,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.heroTitle.copyWith(
                            color: const Color(0xFFF0E8DF),
                            fontSize: 38,
                            fontWeight: FontWeight.w300,
                          ),
                          children: [
                            const TextSpan(text: 'Who are\n'),
                            TextSpan(
                              text: 'you',
                              style: AppTextStyles.heroTitle.copyWith(
                                color: const Color(0xFFC9A98A),
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(text: ' today?'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select your access level to continue',
                        style: AppTextStyles.metaLabel.copyWith(
                          color: const Color(0x66F0E8DF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 56),

                // ── Role cards ──
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _roles.asMap().entries.map((e) {
                      final i = e.key;
                      final option = e.value;
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 500 + i * 80),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, child) => Opacity(
                          opacity: v,
                          child: Transform.translate(
                            offset: Offset(0, 16 * (1 - v)),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RoleCard(
                            option: option,
                            onTap: () => _handleSelect(context, option.role),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Role option data ───────────────────────────────────────────────────────────

class _RoleOption {
  final UserRole role;
  final String icon;
  final String label;
  final String desc;
  final Color accent;

  const _RoleOption({
    required this.role,
    required this.icon,
    required this.label,
    required this.desc,
    required this.accent,
  });
}

// ── Role card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatefulWidget {
  final _RoleOption option;
  final VoidCallback onTap;

  const _RoleCard({required this.option, required this.onTap});

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.option.accent.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.option.accent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Text(
                widget.option.icon,
                style: TextStyle(fontSize: 22, color: widget.option.accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.option.label,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: const Color(0xFFF0E8DF),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.option.desc,
                      style: AppTextStyles.categoryLabel.copyWith(
                        color: const Color(0x66F0E8DF),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.20),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
