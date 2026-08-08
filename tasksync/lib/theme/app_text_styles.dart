import 'package:flutter/material.dart';

/// ─── TASKSYNC TEXT STYLES ─────────────────────────────────────────────────
/// Font families: Fraunces (display) · DM Sans (body) · DM Mono (mono)
/// Add to pubspec.yaml:
///   google_fonts: ^6.2.1

class AppTextStyles {
  AppTextStyles._();

  // ── Display (Fraunces) ────────────────────────────────────────────────────

  /// Hero title — "Mastering Projects with Management"
  static const TextStyle heroTitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 44,
    fontWeight: FontWeight.w900,
    height: 1.03,
    letterSpacing: -1.5,
  );

  /// Section/screen title — "Website Builder"
  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 44,
    fontWeight: FontWeight.w900,
    height: 1.03,
    letterSpacing: -1.5,
  );

  /// Date number large
  static const TextStyle dateNumber = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 44,
    fontWeight: FontWeight.w900,
    height: 1.0,
  );

  // ── Body (DM Sans) ────────────────────────────────────────────────────────

  /// Card title
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Person name in top bar
  static const TextStyle userName = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  /// Meta value (date, status)
  static const TextStyle metaValue = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Meta value regular weight
  static const TextStyle metaValueRegular = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Goal item title
  static const TextStyle goalTitle = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Body small
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  /// Body regular
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  /// Tab label
  static const TextStyle tabLabel = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Tab label active
  static const TextStyle tabLabelActive = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Month label
  static const TextStyle monthLabel = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  // ── Mono (DM Mono) ────────────────────────────────────────────────────────

  /// Meta label (Date / Status / Priority)
  static const TextStyle metaLabel = TextStyle(
    fontFamily: 'DM Mono',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  );

  /// Category / chip text
  static const TextStyle categoryLabel = TextStyle(
    fontFamily: 'DM Mono',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Meet link
  static const TextStyle meetLink = TextStyle(
    fontFamily: 'DM Mono',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Goal number
  static const TextStyle goalNumber = TextStyle(
    fontFamily: 'DM Mono',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
  );

  /// Filter pill text
  static const TextStyle pillText = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Priority badge
  static const TextStyle priorityLabel = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  /// Chat timestamp
  static const TextStyle chatTime = TextStyle(
    fontFamily: 'DM Mono',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Chat message
  static const TextStyle chatMessage = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
}
