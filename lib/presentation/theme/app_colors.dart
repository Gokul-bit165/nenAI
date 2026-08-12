import 'package:flutter/material.dart';

/// Fresh, clean, light-first color palette for NENAI with pastel cluster tints and vibrant accents.
abstract class AppColors {
  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Brand Accents
  static const Color primary = Color(0xFF6A45B2); // Deep Purple
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryTint = Color(0xFFEDE9FE);
  static const Color primaryDark = Color(0xFF533391);

  static const Color accentGreen = Color(0xFF22C55E); // Fresh Emerald Green
  static const Color accentGreenDark = Color(0xFF16A34A);
  static const Color accentGreenLight = Color(0xFFDCFCE7);

  static const Color secondary = Color(0xFF06B6D4); // Vibrant Teal
  static const Color secondaryVariant = Color(0xFF0D9488);
  static const Color secondaryLight = Color(0xFFCCFBF1);

  // Pastel Cluster Palettes
  static const Color clusterTech = Color(0xFF7C3AED);
  static const Color clusterTechBg = Color(0xFFEDE9FE);

  static const Color clusterProjects = Color(0xFF16A34A);
  static const Color clusterProjectsBg = Color(0xFFDCFCE7);

  static const Color clusterAi = Color(0xFF0284C7);
  static const Color clusterAiBg = Color(0xFFE0F2FE);

  static const Color clusterPersonal = Color(0xFFDB2777);
  static const Color clusterPersonalBg = Color(0xFFFCE7F3);

  static const Color clusterBooks = Color(0xFF0D9488);
  static const Color clusterBooksBg = Color(0xFFCCFBF1);

  static const Color clusterIdeas = Color(0xFFD97706);
  static const Color clusterIdeasBg = Color(0xFFFEF3C7);

  // Summary & Callout Cards
  static const Color summaryCardBg = Color(0xFFFEF9EE);
  static const Color summaryCardBorder = Color(0xFFFDE68A);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color processing = Color(0xFFF59E0B);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color shimmerBase = Color(0xFFF1F5F9);
  static const Color shimmerHighlight = Color(0xFFE2E8F0);
}
