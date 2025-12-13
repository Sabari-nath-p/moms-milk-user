import 'package:flutter/material.dart';

class AppTheme {
  // ------------------------------------------------------------
  //  LIGHT THEME COLORS  (UPDATED)
  // ------------------------------------------------------------

  static const Color primaryColor =
  // Color(
  //   0xffFB7185,
  // );
  Color(0xFFF47458); // Warm Coral
  static const Color secondaryColor = Color(0xFFD66EAB); // Tender Rose

  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;

  static const Color errorColor = Color(0xFFE53935);

  static const Color onPrimaryColor = Color(0xFFF9F1EF);
  static const Color onSecondaryColor = Color(0xFFF9F1EF);
  static const Color onBackgroundColor = Color(0xFFF9F1EF);
  static const Color onSurfaceColor = Color(0xFF3F2F39);
  static const Color onErrorColor = Color(0xFFF9F1EF);

  // ------------------ ROUND BUTTON GRADIENT ----------------
  static const Color roundButtonGradientTop = Color(0xFFFB7185);
  static const Color roundButtonGradientBottom = Color(0xFFFB923C);

  static const LinearGradient roundButtonGradient = LinearGradient(
    colors: [
      roundButtonGradientTop, // Top part
      roundButtonGradientBottom, // Bottom part
    ],
    begin: Alignment.topCenter, // Upper part
    end: Alignment.bottomCenter, // Lower part
  );

  // Gradient for cards
  static const Color cardGradientStart = Color(0xffFFE4E6);
  static const Color cardGradientEnd = Color(0xFFFFEDD5);
  static const LinearGradient CardGradient = LinearGradient(
    colors: [cardGradientStart, cardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border color
  static const Color borderColor = Color(0xFFE4E6);

  // Button / Card Gradient
  static const Color buttonCardGradientStart = Color(0xFFF6A0AA);
  static const Color buttonCardGradientEnd = Color(0xFFFDBA74);

  static const LinearGradient buttonCardGradient = LinearGradient(
    colors: [buttonCardGradientStart, buttonCardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ------------------------------------------------------------
  // UPDATED LIGHT TEXT COLORS
  // ------------------------------------------------------------

  static const Color textPrimaryColor = Colors.black; // Pure Black
  static const Color textSecondaryColor = Color(
    0xFF6B7280,
  ); // Neutral Gray (soft black shade)
  static const Color textDisabledColor = Color(0xFFBDBDBD);

  // ------------------------------------------------------------
  // DARK THEME COLORS (original structure kept)
  // ------------------------------------------------------------

  static const Color darkPrimaryColor = Color(0xFFF69173);
  static const Color darkSecondaryColor = Color(0xFFD6D6D6);

  static const Color darkBackgroundColor = Colors.white;
  static const Color darkSurfaceColor = Color(0xFFF9F1EF);

  static const Color darkErrorColor = Color(0xFFE53935);

  static const Color darkOnPrimaryColor = Color(0xFFF9F1EF);
  static const Color darkOnSecondaryColor = Color(0xFFF9F1EF);
  static const Color darkOnBackgroundColor = Color(0xFFF9F1EF);
  static const Color darkOnSurfaceColor = Color(0xFF3F2F39);
  static const Color darkOnErrorColor = Color(0xFFF9F1EF);

  static const Color darkTextPrimaryColor = Color(0xFF1E2939);
  static const Color darkTextSecondaryColor = Color(0xFFE2E2E2);
  static const Color darkTextDisabledColor = Color(0xFF555555);

  // ------------------------------------------------------------
  // FONTS
  // ------------------------------------------------------------
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Roboto';

  // ------------------------------------------------------------
  // LIGHT THEME  (UPDATED TEXT COLORS APPLIED)
  // ------------------------------------------------------------
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

    // APP BAR
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
    ),

    // ------------------------------------------------------------
    // UPDATED LIGHT TEXT THEME
    // ------------------------------------------------------------
    textTheme: const TextTheme(
      // HEADERS
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

      // HEADLINES
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

      // TITLES
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

      // BODY TEXT
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
        color: textSecondaryColor, // UPDATED
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor, // UPDATED
      ),

      // LABELS
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
        color: textSecondaryColor, // UPDATED
      ),
      labelSmall: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor, // UPDATED
      ),
    ),

    // BUTTON THEME
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

    // INPUT THEME
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
      labelStyle: TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: textSecondaryColor, // UPDATED
      ),
      hintStyle: const TextStyle(
        fontFamily: secondaryFont,
        fontSize: 14,
        color: textDisabledColor,
      ),
    ),

    dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 1),
  );

  // ------------------------------------------------------------
  // DARK THEME (UNCHANGED)
  // ------------------------------------------------------------
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
  );
}
