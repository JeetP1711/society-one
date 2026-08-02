import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF16A34A); // Modern Green
  static const Color primaryDark = Color(0xFF15803D);
  static const Color primaryLight = Color(0xFF86EFAC);

  // Secondary & Accents
  static const Color secondary = Color(0xFF2563EB); // Vibrant Blue
  static const Color secondaryDark = Color(0xFF1D4ED8);
  static const Color secondaryLight = Color(0xFF93C5FD);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // Priority Colors
  static const Color urgent = Color(0xFFDC2626);
  static const Color high = Color(0xFFEA580C);
  static const Color medium = Color(0xFFD97706);
  static const Color low = Color(0xFF16A34A);

  // Light Neutral Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Neutral Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Glassmorphism overlays
  static Color glassLight = Colors.white.withOpacity(0.7);
  static Color glassDark = const Color(0xFF1E293B).withOpacity(0.7);
  static Color glassBorderLight = Colors.white.withOpacity(0.4);
  static Color glassBorderDark = Colors.white.withOpacity(0.1);
}
