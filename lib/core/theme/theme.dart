import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Defines the app's theme, including colors and text styles for consistent UI
class AdminTheme {
  //static const Color sec = Color(0xFF6A1B9A);
  // Centralized color palette for the app
  static const colors = {
    'primary': Color(0xFF6A1B9A),
    'primaryDark': Color(0xFF4A148C),
    'accent': Color(0xFF9575CD),
    'secondary': Color(0xFFCE93D8),
    'success': Color(0xFF4CAF50),
    'background': Color(0xFFF3E5F5),
    'surface': Color(0xFFFFFFFF),
    'textPrimary': Color(0xFF311B92),
    'textSecondary': Color(0xFF5E35B1),
    'error': Color(0xFFD32F2F),
    'inputBackground': Color(0xFFF5F5F5),
    'gradientStart': Color(0xFF3F2B96),
    'gradientMid': Color(0xFF5E4AE3),
    'gradientEnd': Color(0xFF9F70FD),
    'signupGradientStart': Color(0xFFFF892C),
    'signupGradientMid': Color(0xFFFE9A0B),
    'signupGradientEnd': Color(0xFFF8DC65),
    'editIcon': Color(0xFF2196F3),
    'deleteIcon': Color(0xFFD32F2F),
  };

  // Text styles using Google Fonts for consistent typography
  static final textStyles = {
    'heading': GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
    'title': GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
    'body': GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal),
    'button': GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
    'caption': GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
  };

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors['background'],
      colorScheme: ColorScheme.light(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        error: colors['error']!,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: colors['textPrimary']!,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        headlineLarge: textStyles['heading']!.copyWith(color: colors['textPrimary']),
        titleMedium: textStyles['title']!.copyWith(color: colors['textPrimary']),
        bodyMedium: textStyles['body']!.copyWith(color: colors['textPrimary']),
        bodySmall: textStyles['caption']!.copyWith(color: colors['textSecondary']),
      ),
    );
  }
}