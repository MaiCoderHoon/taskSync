import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../data/models/project_model.dart';
import '../../data/mock_repository.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/project_card.dart';
import '../../widgets/bouncing_wrapper.dart';
import 'project_detail_screen.dart';
import 'package:tasksync/screens/auth/gateway_screen.dart';
import 'package:tasksync/data/app_state.dart';

/// LEAD DASHBOARD SCREEN

class LeadDashboardScreen extends StatefulWidget {
  const LeadDashboardScreen({super.key});

  @override
  State<LeadDashboardScreen> createState() => _LeadDashboardScreenState();
}

class _LeadDashboardScreenState extends State<LeadDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  String _filter = 'Ongoing';

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<Project> _getFilteredProjects(BuildContext context) {
    final all = AppStateScope.of(context).projects;
    if (_filter == 'All') return all;
    return all.where((p) => p.status == _filter).toList();
  }

  void _onProjectTap(Project project) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: ProjectDetailScreen(
            detail: MockRepository.websiteBuilderDetail,
            project: project,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showAddProjectSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddProjectSheet(
        onConfirm: (newProject) {
          AppStateScope.of(context).addProject(newProject);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${newProject.title}" added to Ongoing'),
              backgroundColor: const Color(0xFFC9A98A),
            ),
          );
        },
      ),
    );
  }

  // ── Build helpers ──────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const AvatarWidget(
            person: MockRepository.currentUser,
            size: 36,
            bordered: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              MockRepository.currentUser.name,
              style: AppTextStyles.userName.copyWith(
                color: const Color.fromARGB(255, 197, 189, 181),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const GatewayScreen()),
              (r) => false,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
    );
  }

  Widget _buildHeroTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      child: Text(
        'We Master\nProjects with\nManagement',
        style: AppTextStyles.heroTitle.copyWith(
          color: const Color.fromARGB(255, 180, 173, 167),
        ),
      ),
    );
  }

  Widget _buildFilterBar(int ongoingCount, int allCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        children: [
          // Filter pills
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _FilterPill(
                    label: 'Ongoing',
                    count: ongoingCount,
                    icon: '⏳',
                    isActive: _filter == 'Ongoing',
                    onTap: () => setState(() => _filter = 'Ongoing'),
                  ),
                  const SizedBox(width: 10),
                  _FilterPill(
                    label: 'All',
                    count: allCount,
                    icon: '📋',
                    isActive: _filter == 'All',
                    onTap: () => setState(() => _filter = 'All'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Add button
          _FilterIconButton(
            icon: Icons.add,
            size: 22,
            color: const Color.fromARGB(255, 156, 150, 146),
            onTap: () => _showAddProjectSheet(context),
          ),
        ],
      ),
    );
  }

  // ── Main build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final projects = _getFilteredProjects(context);
    final allProjects = AppStateScope.of(context).projects;
    final ongoingCount = allProjects.where((p) => p.status == 'Ongoing').length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeCtrl,
            child: RefreshIndicator(
              color: AppColors.textDark,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Top bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildTopBar(),
                    ),
                  ),

                  // Hero title
                  SliverToBoxAdapter(child: _buildHeroTitle()),

                  // Filter bar
                  SliverToBoxAdapter(child: _buildFilterBar(ongoingCount, allProjects.length)),

                  // Project cards
                  if (projects.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📭', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 16),
                            Text(
                              'No projects found',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      sliver: SliverList.separated(
                        itemCount: projects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          return TweenAnimationBuilder<double>(
                            key: ValueKey(projects[i].id),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + i * 80),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 16 * (1 - value)),
                                child: child,
                              ),
                            ),
                            child: ProjectCard(
                              project: projects[i],
                              onTap: () => _onProjectTap(projects[i]),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Local button helpers ───────────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  final String label;
  final int count;
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.count,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.pillBg : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isActive
                ? const Color.fromARGB(26, 171, 161, 161)
                : Colors.transparent,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF5A2814).withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              '$label ($count)',
              style: AppTextStyles.pillText.copyWith(
                color: isActive
                    ? const Color.fromARGB(255, 156, 150, 146)
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onTap;

  const _FilterIconButton({
    required this.icon,
    required this.size,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWrapper(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.pillBg,
          border: Border.all(color: AppColors.pillBorder),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A2814).withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}

class _AddProjectSheet extends StatefulWidget {
  final void Function(Project newProject) onConfirm;

  const _AddProjectSheet({required this.onConfirm});

  @override
  State<_AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends State<_AddProjectSheet> {
  final _titleCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final title = _titleCtrl.text.trim().isEmpty
        ? 'Untitled Project'
        : _titleCtrl.text.trim();
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final newProject = Project(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: 'New Project',
      status: 'Ongoing',
      priority: 'High',
      date: 'Today',
      completion: 0,
      color: const Color(0xFFC9A98A),
      cardType: CardType.glass,
      people: [MockRepository.currentUser],
    );

    widget.onConfirm(newProject);
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
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'NEW PROJECT',
              style: AppTextStyles.metaLabel.copyWith(
                color: const Color(0xFFC9A98A).withValues(alpha: 0.7),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
              ),
              child: TextField(
                controller: _titleCtrl,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.textLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter project title…',
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
                        color: Colors.white.withValues(alpha: 0.06),
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
                            ? const Color(0xFFC9A98A).withValues(alpha: 0.4)
                            : const Color(0xFFC9A98A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _submitting ? 'Creating…' : 'Create Project',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: const Color(0xFF1A1410),
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
