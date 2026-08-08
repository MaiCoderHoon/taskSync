import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import 'gateway_screen.dart';
import '../co_lead/co_lead_dashboard_screen.dart';
import '../executive/executive_dashboard_screen.dart';

/// ─── JOIN SCREEN ──────────────────────────────────────────────────────────
/// 6-digit alphanumeric code entry for Co-Lead and Executive roles.

class JoinScreen extends StatefulWidget {
  final UserRole role;

  const JoinScreen({super.key, required this.role});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final List<TextEditingController> _ctrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _submitting = false;

  Color get _accent => widget.role == UserRole.coLead
      ? const Color(0xFF8FAADC)
      : const Color(0xFF8CC88C);

  String get _roleLabel =>
      widget.role == UserRole.coLead ? 'Co-Lead' : 'Executive';

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  void _onDigitChanged(int index, String val) {
    if (val.isEmpty) {
      // Backspace — move focus back
      if (index > 0) _nodes[index - 1].requestFocus();
      return;
    }
    // Advance focus
    if (index < 5) {
      _nodes[index + 1].requestFocus();
    } else {
      // Last digit filled — auto-submit
      _nodes[index].unfocus();
      _handleJoin();
    }
  }

  Future<void> _handleJoin() async {
    final code = _ctrls.map((c) => c.text).join();
    if (code.length < 6) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final dest = widget.role == UserRole.coLead
        ? const CoLeadDashboardScreen()
        : const ExecutiveDashboardScreen();

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: dest),
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (_) => false,
    );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: _accent,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                Text(
                  '${_roleLabel.toUpperCase()} ACCESS',
                  style: AppTextStyles.metaLabel.copyWith(
                    color: _accent.withOpacity(0.7),
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your\njoin code',
                  style: AppTextStyles.heroTitle.copyWith(
                    color: const Color(0xFFF0E8DF),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '6-digit code provided by your Lead',
                  style: AppTextStyles.categoryLabel.copyWith(
                    color: const Color(0x66F0E8DF),
                  ),
                ),
                const SizedBox(height: 48),

                // Code input row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return _CodeBox(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      accent: _accent,
                      onChanged: (val) => _onDigitChanged(i, val),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                if (_submitting)
                  Center(
                    child: CircularProgressIndicator(
                      color: _accent,
                      strokeWidth: 2,
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

// ── 6-digit box ───────────────────────────────────────────────────────────────

class _CodeBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accent;
  final ValueChanged<String> onChanged;

  const _CodeBox({
    required this.controller,
    required this.focusNode,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          LengthLimitingTextInputFormatter(1),
        ],
        style: TextStyle(
          fontFamily: 'DM Mono',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF0E8DF),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: controller.text.isNotEmpty
              ? accent.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: controller.text.isNotEmpty
                  ? accent
                  : Colors.white.withOpacity(0.10),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.10),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1.5),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
