import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryColor = Color(0xFFFFECB3);
  static const Color secondaryColor = Color(0xFFFFDEB8);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53935);
  static const Color onPrimaryColor = Color(0xFF8D6E63);
  static const Color onSecondaryColor = Color(0xFF8D6E63);
  static const Color onBackgroundColor = Color(0xFF212121);
  static const Color onSurfaceColor = Color(0xFF212121);
  static const Color onErrorColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFFFFECB3); // Warmer gold
  static const Color darkSecondaryColor = Color(0xFFFFDEB8); // Amber accent
  static const Color darkBackgroundColor = Color(0xFF121212); // True dark
  static const Color darkSurfaceColor = Color(0xFF1E1E1E); // Dark surface
  static const Color darkErrorColor = Color(0xFFCF6679);
  static const Color darkOnPrimaryColor = Color(0xFF000000);
  static const Color darkOnSecondaryColor = Color(0xFF000000);
  static const Color darkOnBackgroundColor = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceColor = Color(0xFFE0E0E0);
  static const Color darkOnErrorColor = Color(0xFF000000);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textDisabledColor = Color(0xFFBDBDBD);

  // Dark Text Colors
  static const Color darkTextPrimaryColor = Color(0xFFE0E0E0);
  static const Color darkTextSecondaryColor = Color(0xFFB0B0B0);
  static const Color darkTextDisabledColor = Color(0xFF555555);

  // Font Families
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Roboto';

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onSurface: onSurfaceColor,
      onError: onErrorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onPrimaryColor,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: textSecondaryColor,
      ),
      hintStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: textDisabledColor,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 1),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkSurfaceColor,
      error: darkErrorColor,
      onPrimary: darkOnPrimaryColor,
      onSecondary: darkOnSecondaryColor,
      onSurface: darkOnSurfaceColor,
      onError: darkOnErrorColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
    ),

    // Text Theme for Dark Mode
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: darkTextPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: darkTextPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: darkTextPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkTextPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkTextPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: darkTextPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: darkTextSecondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: darkTextSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkTextPrimaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkTextSecondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkTextSecondaryColor,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkOnPrimaryColor,
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkErrorColor),
      ),
      fillColor: darkSurfaceColor,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: darkTextSecondaryColor,
      ),
      hintStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: darkTextDisabledColor,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: darkSurfaceColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF404040),
      thickness: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: darkTextSecondaryColor, size: 24),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: darkTextSecondaryColor,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
