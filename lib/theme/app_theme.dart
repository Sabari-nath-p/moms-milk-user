import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors

  // Custom Palette
  static const Color primaryColor = Color(0xFFF69173); // Warm Coral
  static const Color secondaryColor = Color(0xFFD66EAB); // Tender Rose
  static const Color backgroundColor = Color(0xFF3F2F39); // Deep Charcoal
  static const Color surfaceColor = Color(0xFFF9F1EF); // Soft Cream
  static const Color errorColor = Color(0xFFE53935);
  static const Color onPrimaryColor = Color(
    0xFFF9F1EF,
  ); // Soft Cream for text on accent
  static const Color onSecondaryColor = Color(
    0xFFF9F1EF,
  ); // Soft Cream for text on accent
  static const Color onBackgroundColor = Color(
    0xFFF9F1EF,
  ); // Soft Cream for text on dark
  static const Color onSurfaceColor = Color(
    0xFF3F2F39,
  ); // Deep Charcoal for text on light
  static const Color onErrorColor = Color(0xFFF9F1EF);

  // Dark Theme Colors (same palette, but swap background/surface)
  static const Color darkPrimaryColor = Color(0xFFF69173); // Warm Coral
  static const Color darkSecondaryColor = Color(0xFFD66EAB); // Tender Rose
  static const Color darkBackgroundColor = Color(0xFF3F2F39); // Deep Charcoal
  static const Color darkSurfaceColor = Color(0xFFF9F1EF); // Soft Cream
  static const Color darkErrorColor = Color(0xFFE53935);
  static const Color darkOnPrimaryColor = Color(0xFFF9F1EF);
  static const Color darkOnSecondaryColor = Color(0xFFF9F1EF);
  static const Color darkOnBackgroundColor = Color(0xFFF9F1EF);
  static const Color darkOnSurfaceColor = Color(0xFF3F2F39);
  static const Color darkOnErrorColor = Color(0xFFF9F1EF);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFFF9F1EF); // Soft Cream
  static const Color textSecondaryColor =
      Colors.white12; //Color(0xFFD66EAB); // Tender Rose
  static const Color textDisabledColor = Color(0xFFBDBDBD);

  // Dark Text Colors
  static const Color darkTextPrimaryColor = Color(0xFFF9F1EF); // Soft Cream
  static const Color darkTextSecondaryColor = Color(0xFFD66EAB); // Tender Rose
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
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onBackground: onBackgroundColor,
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
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      error: darkErrorColor,
      onPrimary: darkOnPrimaryColor,
      onSecondary: darkOnSecondaryColor,
      onBackground: darkOnBackgroundColor,
      onSurface: darkOnSurfaceColor,
      onError: darkOnErrorColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,

    // Ensure all card backgrounds use Soft Cream
    cardColor: darkSurfaceColor,
    canvasColor: darkBackgroundColor,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor, // Deep Charcoal
      foregroundColor: darkOnBackgroundColor, // Soft Cream
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnBackgroundColor, // Soft Cream
      ),
    ),

    // Text Theme for Dark Mode
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: darkOnBackgroundColor, // Soft Cream
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: darkOnBackgroundColor,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkOnBackgroundColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkOnBackgroundColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: darkOnBackgroundColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: darkOnBackgroundColor,
      ),
      titleLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkOnBackgroundColor,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkOnBackgroundColor,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkOnBackgroundColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: darkOnBackgroundColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: darkSecondaryColor, // Tender Rose
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: darkSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkOnBackgroundColor,
      ),
      labelMedium: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkSecondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkSecondaryColor,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor, // Warm Coral
        foregroundColor: darkOnPrimaryColor, // Soft Cream
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
        borderSide: const BorderSide(color: darkSecondaryColor), // Tender Rose
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkSecondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkErrorColor),
      ),
      fillColor: darkSurfaceColor, // Soft Cream
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: darkSecondaryColor,
      ),
      hintStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: darkOnSurfaceColor, // Deep Charcoal
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: darkSurfaceColor, // Soft Cream
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: darkSecondaryColor, // Tender Rose
      thickness: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: darkSecondaryColor, size: 24),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkBackgroundColor, // Deep Charcoal
      selectedItemColor: darkPrimaryColor, // Warm Coral
      unselectedItemColor: darkSecondaryColor, // Tender Rose
      type: BottomNavigationBarType.fixed,
    ),
  );
}
