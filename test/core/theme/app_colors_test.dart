import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:primeview/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('background color is dark navy', () {
      expect(AppColors.background, const Color(0xFF0A0E1A));
    });

    test('primary color is indigo-blue', () {
      expect(AppColors.primary, const Color(0xFF4A6CF7));
    });

    test('accent color is warm amber', () {
      expect(AppColors.accent, const Color(0xFFF59E0B));
    });

    test('error color is red', () {
      expect(AppColors.error, const Color(0xFFEF4444));
    });

    test('success color is green', () {
      expect(AppColors.success, const Color(0xFF10B981));
    });

    test('text colors have correct hierarchy', () {
      expect(AppColors.textPrimary, const Color(0xFFFFFFFF));
      expect(AppColors.textSecondary, const Color(0xFFB0B8CC));
      expect(AppColors.textMuted, const Color(0xFF6B7390));
    });

    test('surface colors form dark theme palette', () {
      expect(AppColors.surface, const Color(0xFF131725));
      expect(AppColors.surfaceLight, const Color(0xFF1C2138));
      expect(AppColors.cardBackground, const Color(0xFF161B2E));
    });

    test('primary has light and dark variants', () {
      expect(AppColors.primaryDark, const Color(0xFF3B5DE7));
      expect(AppColors.primaryLight, const Color(0xFF6B89FF));
    });

    test('accent has light variant', () {
      expect(AppColors.accentLight, const Color(0xFFFBBF24));
    });

    test('overlay is semi-transparent black', () {
      expect(AppColors.overlay, const Color(0x80000000));
    });

    test('gradients are defined', () {
      expect(AppColors.heroGradient, isA<LinearGradient>());
      expect(AppColors.heroOverlay, isA<LinearGradient>());
      expect(AppColors.premiumGradient, isA<LinearGradient>());
    });

    test('premium gradient has correct colors', () {
      expect(AppColors.premiumGradient.colors, [
        const Color(0xFF4A6CF7),
        const Color(0xFF6B89FF),
      ]);
    });
  });
}
