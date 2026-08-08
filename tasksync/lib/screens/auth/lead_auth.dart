import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../lead/lead_dashboard_screen.dart';
import '../../widgets/bouncing_wrapper.dart';

/// ─── LEAD AUTH SCREEN ─────────────────────────────────────────────────────
/// Integration Token + Database ID entry with Test Connection flow.

class LeadAuthScreen extends StatefulWidget {
  const LeadAuthScreen({super.key});

  @override
  State<LeadAuthScreen> createState() => _LeadAuthScreenState();
}

class _LeadAuthScreenState extends State<LeadAuthScreen> {
  final _tokenCtrl = TextEditingController();
  final _dbIdCtrl = TextEditingController();
  bool _testing = false;
  _ConnStatus _status = _ConnStatus.idle;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _dbIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (_tokenCtrl.text.trim().isEmpty || _dbIdCtrl.text.trim().isEmpty) {
      setState(() => _status = _ConnStatus.error);
      return;
    }
    setState(() {
      _testing = true;
      _status = _ConnStatus.idle;
    });
    await Future.delayed(const Duration(milliseconds: 1800));
    setState(() {
      _testing = false;
      _status = _ConnStatus.success;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: const LeadDashboardScreen(),
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1410), Color(0xFF231B14)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back button
                _BackButton(onTap: () => Navigator.of(context).pop()),
                const SizedBox(height: 40),

                // Title
                Text(
                  'LEAD ACCESS',
                  style: AppTextStyles.metaLabel.copyWith(
                    color: const Color(0xFFC9A98A),
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Connect your\nNotion workspace',
                  style: AppTextStyles.heroTitle.copyWith(
                    color: const Color(0xFFF0E8DF),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),

                // Token field
                _AuthField(
                  label: 'Internal Integration Token',
                  placeholder: 'ntn_••••••••••••••••••••••••••••••',
                  controller: _tokenCtrl,
                  obscure: true,
                ),
                const SizedBox(height: 16),

                // DB ID field
                _AuthField(
                  label: 'Database ID',
                  placeholder: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                  controller: _dbIdCtrl,
                  obscure: false,
                ),
                const SizedBox(height: 12),

                // Status messages
                if (_status == _ConnStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '⚠  Please fill both fields',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: const Color(0xFFE07070),
                      ),
                    ),
                  ),
                if (_status == _ConnStatus.success)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '✓  Connection successful — entering workspace…',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: const Color(0xFF8CC88C),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // CTA button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _testing ? null : _testConnection,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _testing
                            ? const Color(0xFFC9A98A).withValues(alpha: 0.4)
                            : const Color(0xFFC9A98A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _testing ? 'Testing connection…' : 'Test Connection →',
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
          ),
        ),
      ),
    );
  }
}

enum _ConnStatus { idle, error, success }

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BouncingWrapper(
      onTap: onTap,
      child: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFC9A98A),
        size: 24,
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool obscure;

  const _AuthField({
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.metaLabel.copyWith(
            color: const Color(0xB3C9A98A),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: AppTextStyles.meetLink.copyWith(
              color: const Color(0xFFF0E8DF),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.meetLink.copyWith(
                color: Colors.white.withValues(alpha: 0.20),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
