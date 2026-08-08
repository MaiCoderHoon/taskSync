import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../data/models/project_model.dart';
import '../../data/mock_repository.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/project_card.dart';
import 'project_detail_screen.dart';

/// ─── LEAD DASHBOARD SCREEN ────────────────────────────────────────────────

class LeadDashboardScreen extends StatefulWidget {
  const LeadDashboardScreen({super.key});

  @override
  State<LeadDashboardScreen> createState() => _LeadDashboardScreenState();
}

class _LeadDashboardScreenState extends State<LeadDashboardScreen>
    with SingleTickerProviderStateMixin {
  final List<Project> _projects = MockRepository.projects;
  late AnimationController _fadeCtrl;

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

  int get _ongoingCount => _projects.where((p) => p.status == 'Ongoing').length;

  void _onProjectTap(Project project) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: ProjectDetailScreen(
            detail: MockRepository.websiteBuilderDetail,
            projectTitle: project.title,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // ── Build helpers ──────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AvatarWidget(
            person: MockRepository.currentUser,
            size: 36,
            bordered: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              MockRepository.currentUser.name,
              style: AppTextStyles.userName.copyWith(color: AppColors.textDark),
            ),
          ),
          // Bell
          _NavIconButton(icon: Icons.notifications_outlined),
          const SizedBox(width: 8),
          // Search
          _NavIconButton(icon: Icons.search),
        ],
      ),
    );
  }

  Widget _buildHeroTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      child: Text(
        'Mastering\nProjects with\nManagement',
        style: AppTextStyles.heroTitle.copyWith(color: AppColors.textDark),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        children: [
          // Status pill
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: AppColors.pillBorder),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5A2814).withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('⏳', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    'Ongoing ($_ongoingCount)',
                    style: AppTextStyles.pillText.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.textMutedDark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Add button
          _FilterIconButton(icon: Icons.add, size: 22),
          const SizedBox(width: 8),

          // Menu button
          _FilterIconButton(icon: Icons.menu_rounded, size: 18),
        ],
      ),
    );
  }

  // ── Main build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
                  SliverToBoxAdapter(child: _buildFilterBar()),

                  // Project cards
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    sliver: SliverList.separated(
                      itemCount: _projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
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
                            project: _projects[i],
                            onTap: () => _onProjectTap(_projects[i]),
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

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  const _NavIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.30),
        border: Border.all(color: Colors.white.withOpacity(0.52)),
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  const _FilterIconButton({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pillBg,
        border: Border.all(color: AppColors.pillBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A2814).withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: size, color: AppColors.textDark),
    );
  }
}
