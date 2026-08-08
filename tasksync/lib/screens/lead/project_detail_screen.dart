import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../data/models/project_model.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/gradient_background.dart';

/// â”€â”€â”€ PROJECT DETAIL SCREEN â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ProjectDetailScreen extends StatefulWidget {
  final ProjectDetail detail;
  final String projectTitle;

  const ProjectDetailScreen({
    super.key,
    required this.detail,
    required this.projectTitle,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatCtrl = TextEditingController();
  late List<ChatMessage> _chatMessages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _chatMessages = List.from(widget.detail.chat);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _chatCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chatMessages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: 'Jonas Khanwald',
          message: text,
          time: TimeOfDay.now().format(context),
        ),
      );
    });
    _chatCtrl.clear();
  }

  // â”€â”€ Build sections â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GlassPillButton(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 24,
              color: AppColors.textDark,
            ),
          ),
          const _GlassPillButton(
            child: const Icon(
              Icons.search_rounded,
              size: 18,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.projectTitle,
            style: AppTextStyles.screenTitle.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Created by',
                style: AppTextStyles.metaLabel.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
              const SizedBox(width: 6),
              AvatarWidget(person: widget.detail.createdBy, size: 18),
              const SizedBox(width: 6),
              Text(
                widget.detail.createdBy.name,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.textMid,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.textMutedDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Date card â€” strong white glass
            Expanded(
              child: _WhiteGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: AppTextStyles.metaLabel.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.detail.dateDay,
                      style: AppTextStyles.dateNumber.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.detail.dateMonth,
                      style: AppTextStyles.monthLabel.copyWith(
                        color: AppColors.textMid,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // People card â€” semi glass
            Expanded(
              child: _SemiGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'People',
                      style: AppTextStyles.metaLabel.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                    ),
                    const Spacer(),
                    AvatarStack(people: widget.detail.people, size: 36, max: 4),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMutedDark,
                        ),
                        children: [
                          TextSpan(
                            text: '${widget.detail.people.length}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(text: ' people at this meeting'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetLink() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.95),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5A2814).withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.videocam_rounded,
                  color: Color(0xFF34A853),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.detail.meetLink,
                    style: AppTextStyles.meetLink.copyWith(
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.detail.meetLink),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied!')),
                    );
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.10)),
                    ),
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: AppColors.textMid,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: TabBar(
          controller: _tabController,
          padding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColors.tabActiveBg,
            borderRadius: BorderRadius.circular(99),
          ),
          dividerColor: Colors.transparent,
          labelStyle: AppTextStyles.tabLabelActive,
          unselectedLabelStyle: AppTextStyles.tabLabel,
          labelColor: AppColors.textDark,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Goals'),
            Tab(text: 'Chat'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.detail.goals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final goal = widget.detail.goals[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 350 + i * 60),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 14 * (1 - value)),
              child: child,
            ),
          ),
          child: _GoalTile(goal: goal),
        );
      },
    );
  }

  Widget _buildChatTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      child: Column(
        children: [
          ...(_chatMessages.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ChatBubble(message: m),
            ),
          )),
          const SizedBox(height: 8),
          // Chat input
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.70),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _chatCtrl,
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write a messageâ€¦',
                      hintStyle: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.textMutedDark,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textDark,
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // â”€â”€ Main build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(child: _buildNavBar()),
              SliverToBoxAdapter(child: _buildTitleSection()),
              SliverToBoxAdapter(child: _buildInfoGrid()),
              SliverToBoxAdapter(child: _buildMeetLink()),
              SliverToBoxAdapter(child: _buildTabBar()),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                // Goals tab
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildGoalsTab(),
                ),
                // Chat tab
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildChatTab(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ Local sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _GlassPillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _GlassPillButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.52)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _WhiteGlassCard extends StatelessWidget {
  final Widget child;

  const _WhiteGlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.92),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5A2814).withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SemiGlassCard extends StatelessWidget {
  final Widget child;

  const _SemiGlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.72),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5A2814).withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final Goal goal;

  const _GoalTile({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.cardGoal,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              goal.num,
              style: AppTextStyles.goalNumber.copyWith(
                color: Colors.white.withValues(alpha: 0.32),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: AppTextStyles.goalTitle.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  goal.page,
                  style: AppTextStyles.categoryLabel.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AvatarWidget(
          person: Person(id: '', name: message.author),
          size: 28,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.cardGoal,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.author,
                      style: AppTextStyles.chatTime.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Â· ${message.time}',
                      style: AppTextStyles.chatTime.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.message,
                  style: AppTextStyles.chatMessage.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

