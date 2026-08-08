import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasksync/data/mock_repository.dart';
import 'package:tasksync/theme/theme.dart';
import 'package:tasksync/widgets/avatar_widget.dart';
import 'package:tasksync/screens/auth/gateway_screen.dart';
import 'package:tasksync/data/app_state.dart';

/// Personal focus list sorted by nearest deadline.
/// Each card has a live countdown + swipe-to-complete slider.

class ExecutiveDashboardScreen extends StatefulWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  State<ExecutiveDashboardScreen> createState() =>
      _ExecutiveDashboardScreenState();
}

class _ExecutiveDashboardScreenState extends State<ExecutiveDashboardScreen> {
  void _completeTask(String id) {
    HapticFeedback.heavyImpact();
    AppStateScope.of(context).completeTask(id);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = AppStateScope.of(context)
        .tasks
        .where((t) => t.status == TaskStatus.todo)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    const accent = Color(0xFF8CC88C);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [Color(0xFF0F1A0F), Color(0xFF0C140C), Color(0xFF0A120A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    const AvatarWidget(
                      person: MockRepository.deksha,
                      size: 36,
                      bordered: true,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MockRepository.deksha.name,
                            style: AppTextStyles.userName.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          Text(
                            'EXECUTIVE',
                            style: AppTextStyles.metaLabel.copyWith(
                              color: accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const GatewayScreen(),
                        ),
                        (r) => false,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          'EXIT',
                          style: AppTextStyles.metaLabel.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //  Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.heroTitle.copyWith(
                        color: AppColors.textLight,
                        fontSize: 32,
                      ),
                      children: [
                        const TextSpan(text: 'Your\n'),
                        TextSpan(
                          text: 'Focus List',
                          style: AppTextStyles.heroTitle.copyWith(
                            color: accent,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nearest Deadline ke Hisab se · ${tasks.length} active hai!!!',
                    style: AppTextStyles.categoryLabel.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: tasks.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'All tasks complete!',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 350 + i * 70),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, child) => Opacity(
                              opacity: v,
                              child: Transform.translate(
                                offset: Offset(0, 14 * (1 - v)),
                                child: child,
                              ),
                            ),
                            child: _ExecTaskCard(
                              task: tasks[i],
                              onComplete: () => _completeTask(tasks[i].id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Task card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ExecTaskCard extends StatelessWidget {
  final AppTask task;
  final VoidCallback onComplete;

  const _ExecTaskCard({required this.task, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: category + countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.project.toUpperCase()} Â· ${task.page.toUpperCase()}',
                    style: AppTextStyles.metaLabel.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DEADLINE',
                    style: AppTextStyles.metaLabel.copyWith(
                      color: const Color(0xFF8CC88C).withValues(alpha: 0.6),
                      letterSpacing: 1,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _CountdownTimer(deadline: task.deadline),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Task title
          Text(
            task.title,
            style: AppTextStyles.heroTitle.copyWith(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
          const SizedBox(height: 16),

          // Swipe to complete
          Center(child: _SwipeToComplete(onComplete: onComplete)),
        ],
      ),
    );
  }
}

// â”€â”€ Live countdown timer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CountdownTimer extends StatefulWidget {
  final DateTime deadline;
  const _CountdownTimer({required this.deadline});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.deadline.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _remaining = widget.deadline.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = _remaining.isNegative;
    final h = _remaining.inHours.abs();
    final m = (_remaining.inMinutes % 60).abs();

    final label = isOverdue ? 'OVERDUE' : '${h}h ${m}m';
    final color = isOverdue
        ? const Color(0xFFE07070)
        : h < 3
        ? const Color(0xFFE0A870)
        : const Color(0xFF8CC88C);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.metaLabel.copyWith(
            color: color,
            letterSpacing: 0.5,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Swipe-to-complete slider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SwipeToComplete extends StatefulWidget {
  final VoidCallback onComplete;
  const _SwipeToComplete({required this.onComplete});

  @override
  State<_SwipeToComplete> createState() => _SwipeToCompleteState();
}

class _SwipeToCompleteState extends State<_SwipeToComplete>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  late AnimationController _springCtrl;
  late Animation<double> _springAnim;

  static const double _trackWidth = 260;
  static const double _thumbWidth = 48;
  static const double _maxDrag = _trackWidth - _thumbWidth - 8;

  @override
  void initState() {
    super.initState();
    _springCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _springCtrl.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() {
      _dragX = (_dragX + d.delta.dx).clamp(0.0, _maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails _) {
    if (_dragX >= _maxDrag * 0.95) {
      widget.onComplete();
    } else {
      // Spring back
      final startVal = _dragX;
      _springAnim = Tween<double>(begin: startVal, end: 0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut),
      )..addListener(() => setState(() => _dragX = _springAnim.value));
      _springCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = _dragX / _maxDrag;
    const accent = Color(0xFF8CC88C);

    return SizedBox(
      width: _trackWidth,
      height: 48,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Track
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
          ),

          // Fill
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            width: _thumbWidth + _dragX + 8,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15 + pct * 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
          ),

          // Label
          Center(
            child: Text(
              'SLIDE TO CONFIRM',
              style: AppTextStyles.metaLabel.copyWith(
                color: Colors.white.withValues(alpha: 0.25 + pct * 0.4),
                letterSpacing: 2,
                fontSize: 10,
              ),
            ),
          ),

          // Thumb
          Positioned(
            left: 4 + _dragX,
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _thumbWidth,
                height: 40,
                decoration: BoxDecoration(
                  color: pct > 0.9 ? accent : const Color(0xFFC9A98A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (pct > 0.9 ? accent : const Color(0xFFC9A98A))
                          .withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  pct > 0.9 ? Icons.check_rounded : Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
