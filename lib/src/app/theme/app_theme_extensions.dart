import 'package:flutter/material.dart';

extension AppThemeContext on BuildContext {
  // Colors
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
  Color get primaryContainerColor =>
      Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainerColor =>
      Theme.of(this).colorScheme.onPrimaryContainer;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get onSecondaryColor => Theme.of(this).colorScheme.onSecondary;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get surfaceDimColor => Theme.of(this).colorScheme.surfaceDim;
  Color get surfaceContainerLowestColor =>
      Theme.of(this).colorScheme.surfaceContainerLowest;
  Color get surfaceContainerLowColor =>
      Theme.of(this).colorScheme.surfaceContainerLow;
  Color get surfaceContainerColor =>
      Theme.of(this).colorScheme.surfaceContainer;
  Color get surfaceContainerHighColor =>
      Theme.of(this).colorScheme.surfaceContainerHigh;
  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;
  Color get onSurfaceVariantColor =>
      Theme.of(this).colorScheme.onSurfaceVariant;
  Color get outlineColor => Theme.of(this).colorScheme.outline;
  Color get outlineVariantColor => Theme.of(this).colorScheme.outlineVariant;
  Color get errorColor => Theme.of(this).colorScheme.error;
  Color get onErrorColor => Theme.of(this).colorScheme.onError;
  Color get errorContainerColor => Theme.of(this).colorScheme.errorContainer;

  // Custom brand colors
  Color get brandGold => const Color(0xFFC5A059);
  Color get brandGoldLight => const Color(0xFFC5A059).withOpacity(0.1);
  Color get brandGoldBorder => const Color(0xFFC5A059).withOpacity(0.4);

  // Semantic colors
  Color get successColor => const Color(0xFF059669);
  Color get successLightColor => const Color(0xFFD1FAE5);
  Color get warningColor => const Color(0xFFD97706);
  Color get warningLightColor => const Color(0xFFFEF3C7);
}

extension CustomColors on ColorScheme {
  Color get brandGold => const Color(0xFFC5A059);
  Color get brandGoldLight => const Color(0xFFC5A059).withOpacity(0.1);
  Color get brandGoldBorder => const Color(0xFFC5A059).withOpacity(0.4);
  Color get successColor => const Color(0xFF059669);
  Color get successLightColor => const Color(0xFFD1FAE5);
  Color get warningColor => const Color(0xFFD97706);
  Color get warningLightColor => const Color(0xFFFEF3C7);
}
