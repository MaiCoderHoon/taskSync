import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tasksync/theme/theme.dart';
import '../../data/models/project_model.dart';
import '../../data/mock_repository.dart';
import '../../widgets/avatar_widget.dart';

/// ─── CO-LEAD DASHBOARD SCREEN ─────────────────────────────────────────────
/// Audit queue: lists all Done tasks, search, reopen with feedback sheet.

// Mock done tasks
final _doneTasks = [
  _Task(
    id: 't4',
    title: 'Typography audit',
    project: 'Logo Guideline',
    assignee: MockRepository.ana,
  ),
  _Task(
    id: 't5',
    title: 'Prototype animations',
    project: 'Mobile App',
    assignee: MockRepository.deksha,
  ),
  _Task(
    id: 't6',
    title: 'Icon set draft',
    project: 'Website Builder',
    assignee: MockRepository.kush,
  ),
  _Task(
    id: 't7',
    title: 'Colour palette',
    project: 'Finance landing',
    assignee: MockRepository.guna,
  ),
  _Task(
    id: 't8',
    title: 'Component library',
    project: 'Website Builder',
    assignee: MockRepository.ana,
  ),
];

class _Task {
  final String id;
  final String title;
  final String project;
  final Person assignee;
  _Task({
    required this.id,
    required this.title,
    required this.project,
    required this.assignee,
  });
}

class CoLeadDashboardScreen extends StatefulWidget {
  const CoLeadDashboardScreen({super.key});

  @override
  State<CoLeadDashboardScreen> createState() => _CoLeadDashboardScreenState();
}

class _CoLeadDashboardScreenState extends State<CoLeadDashboardScreen> {
  final _searchCtrl = TextEditingController();
  List<_Task> _tasks = List.from(_doneTasks);
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Task> get _filtered => _tasks.where((t) {
    if (_query.isEmpty) return true;
    return t.title.toLowerCase().contains(_query) ||
        t.assignee.name.toLowerCase().contains(_query);
  }).toList();

  void _showReopenSheet(_Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReopenSheet(
        task: task,
        onConfirm: (feedback) {
          setState(() => _tasks.removeWhere((t) => t.id == task.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${task.title}" moved to Revision Needed'),
              backgroundColor: const Color(0xFF8FAADC),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF8FAADC);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.48, 1.0],
            colors: [Color(0xFF101420), Color(0xFF0E1219), Color(0xFF0A0E14)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    AvatarWidget(
                      person: const Person(id: 'cl', name: 'Co Lead'),
                      size: 36,
                      bordered: true,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Audit Queue',
                            style: AppTextStyles.userName.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          Text(
                            'CO-LEAD',
                            style: AppTextStyles.metaLabel.copyWith(
                              color: accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
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

              // ── Title ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.heroTitle.copyWith(
                        color: AppColors.textLight,
                        fontSize: 32,
                      ),
                      children: [
                        const TextSpan(text: 'Done &\n'),
                        TextSpan(
                          text: 'Awaiting Review',
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

              // ── Search bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.textLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by task or person…',
                      hintStyle: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Count label ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'STATUS = DONE · ${_filtered.length} TASKS',
                    style: AppTextStyles.metaLabel.copyWith(
                      color: accent.withOpacity(0.6),
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              // ── Task list ──
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No matching tasks',
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final task = _filtered[i];
                          return _AuditTile(
                            task: task,
                            onReopen: () => _showReopenSheet(task),
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

// ── Audit tile ────────────────────────────────────────────────────────────────

class _AuditTile extends StatelessWidget {
  final _Task task;
  final VoidCallback onReopen;

  const _AuditTile({required this.task, required this.onReopen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          AvatarWidget(person: task.assignee, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${task.assignee.name} · ${task.project}',
                  style: AppTextStyles.categoryLabel.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onReopen,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0A870).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE0A870).withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                '↩ Reopen',
                style: AppTextStyles.metaLabel.copyWith(
                  color: const Color(0xFFE0A870),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reopen bottom sheet ───────────────────────────────────────────────────────

class _ReopenSheet extends StatefulWidget {
  final _Task task;
  final void Function(String feedback) onConfirm;

  const _ReopenSheet({required this.task, required this.onConfirm});

  @override
  State<_ReopenSheet> createState() => _ReopenSheetState();
}

class _ReopenSheetState extends State<_ReopenSheet> {
  final _feedbackCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    widget.onConfirm(_feedbackCtrl.text);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF161C28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'RE-OPEN TASK',
              style: AppTextStyles.metaLabel.copyWith(
                color: const Color(0xFF8FAADC).withOpacity(0.7),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.title,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textLight,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'REVISION FEEDBACK',
              style: AppTextStyles.metaLabel.copyWith(
                color: const Color(0xFF8FAADC).withOpacity(0.7),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.10)),
              ),
              child: TextField(
                controller: _feedbackCtrl,
                maxLines: 4,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.textLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Describe what needs revision…',
                  hintStyle: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _submitting ? null : _confirm,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _submitting
                            ? const Color(0xFF8FAADC).withOpacity(0.4)
                            : const Color(0xFF8FAADC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _submitting ? 'Patching Notion…' : 'Confirm Re-open',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: const Color(0xFF0E1219),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
