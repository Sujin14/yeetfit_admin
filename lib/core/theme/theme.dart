import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  static const colors = {
    'primary': Color(0xFF0288D1), // Vibrant blue
    'secondary': Color(0xFF388E3C), // Vibrant green
    'background': Color(0xFFF5F7FA),
    'surface': Color(0xFFFFFFFF),
    'textPrimary': Color(0xFF212121),
    'textSecondary': Color(0xFF757575),
    'error': Color(0xFFD32F2F),
    'accent': Color(0xFFFFA000), // Vibrant amber for highlights
  };

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
        onSecondary: Colors.white,
        onSurface: colors['textPrimary']!,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        headlineLarge: textStyles['heading']!.copyWith(
          color: colors['textPrimary'],
        ),
        titleMedium: textStyles['title']!.copyWith(
          color: colors['textPrimary'],
        ),
        bodyMedium: textStyles['body']!.copyWith(color: colors['textPrimary']),
        bodySmall: textStyles['caption']!.copyWith(
          color: colors['textSecondary'],
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        elevation: 2,
        titleTextStyle: textStyles['title']!.copyWith(
          color: colors['textPrimary'],
        ),
        iconTheme: IconThemeData(color: colors['textPrimary']),
      ),
    );
  }
}
