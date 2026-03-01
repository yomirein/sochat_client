import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color outline;
  final Color surface;
  final Color foreground;
  final Color textPrimary;
  final Color textSecondary;
  final Color positive;
  final Color caution;
  final Color critical;
  final Color primary;
  final Color contrastColor;

  const AppColors({
    required this.background,
    required this.outline,
    required this.surface,
    required this.foreground,
    required this.textPrimary,
    required this.textSecondary,
    required this.positive,
    required this.caution,
    required this.critical,
    required this.primary,
    required this.contrastColor,
  });

  @override
  AppColors copyWith({
    Color? background,
    Color? outline,
    Color? surface,
    Color? foreground,
    Color? textPrimary,
    Color? textSecondary,
    Color? positive,
    Color? caution,
    Color? critical,
    Color? primary,
    Color? contrastColor,
  }) {
    return AppColors(
      background: background ?? this.background,
      outline: outline ?? this.outline,
      surface: surface ?? this.surface,
      foreground: foreground ?? this.foreground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      positive: positive ?? this.positive,
      caution: caution ?? this.caution,
      critical: critical ?? this.critical,
      primary: primary ?? this.primary,
      contrastColor: contrastColor ?? this.contrastColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      caution: Color.lerp(caution, other.caution, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      contrastColor: Color.lerp(contrastColor, other.contrastColor, t)!,
    );
  }
}