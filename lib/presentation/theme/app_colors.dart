import 'package:flutter/material.dart';

/// Deep indigo/violet dark-first color palette for MemAI.
abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF161522);
  static const Color surfaceVariant = Color(0xFF222034);
  static const Color cardBackground = Color(0xFF1D1B2E);

  // Primary / Accent
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryLight = Color(0xFFB388FF);
  static const Color primaryDark = Color(0xFF651FFF);

  // Secondary
  static const Color secondary = Color(0xFF00E5FF);
  static const Color secondaryVariant = Color(0xFF00B8D4);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFE);
  static const Color textSecondary = Color(0xFFA7A9BE);
  static const Color textMuted = Color(0xFF62667F);

  // Status
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
  static const Color processing = Color(0xFF7C4DFF);

  // Shimmer / Borders
  static const Color border = Color(0xFF2E2C44);
  static const Color shimmerBase = Color(0xFF1D1B2E);
  static const Color shimmerHighlight = Color(0xFF2E2C44);
}
