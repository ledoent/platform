import 'package:flutter/material.dart';

/// Huly design tokens extracted from packages/theme/styles/_colors.scss .theme-dark
class HulyColors {
  HulyColors._();

  // Backgrounds
  static const background = Color(0xFF1A1A28);
  static const deepBackground = Color(0xFF0F0F18);
  static const navPanel = Color(0xFF14141F);
  static const header = Color(0xFF1F1F2C);
  static const listRow = Color(0xFF21212F);
  static const inputFill = Color(0xFF262634);

  // Primary / accent
  static const primaryButton = Color(0xFF205DC2);
  static const primaryHover = Color(0xFF3575DE);
  static const accent = Color(0xFF377AE6);

  // Semantic
  static const positive = Color(0xFF05A05C);
  static const negative = Color(0xFFCB4B42);
  static const errorText = Color(0xFFEE7A7A);

  // Text
  static const contentText = Color(0xCCFFFFFF); // white 80%
  static const darkText = Color(0x99FFFFFF); // white 60%
  static const darkerText = Color(0x66FFFFFF); // white 40%

  // Divider
  static const divider = Color(0x0FFFFFFF); // white 6%

  // Priority
  static const priorityUrgent = Color(0xFFCB4B42);
  static const priorityHigh = Color(0xFFF47758);
  static const priorityMedium = Color(0xFFFCC500);
  static const priorityLow = Color(0xFF377AE6);
  static const priorityNone = Color(0x66FFFFFF);

  static Color priorityColor(int priority) {
    switch (priority) {
      case 1:
        return priorityUrgent;
      case 2:
        return priorityHigh;
      case 3:
        return priorityMedium;
      case 4:
        return priorityLow;
      default:
        return priorityNone;
    }
  }
}

final hulyDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: HulyColors.background,
  colorScheme: const ColorScheme.dark(
    primary: HulyColors.primaryButton,
    secondary: HulyColors.accent,
    surface: HulyColors.header,
    error: HulyColors.negative,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: HulyColors.header,
    foregroundColor: HulyColors.contentText,
    elevation: 0,
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: Colors.white,
    unselectedLabelColor: HulyColors.darkerText,
    indicatorColor: HulyColors.accent,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: HulyColors.primaryButton,
    foregroundColor: Colors.white,
  ),
  dividerTheme: const DividerThemeData(
    color: HulyColors.divider,
    thickness: 1,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: HulyColors.accent,
  ),
);

InputDecoration hulyInputDecoration(String label, [String? hint]) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: HulyColors.darkText, fontSize: 14),
    hintStyle: const TextStyle(color: HulyColors.darkerText, fontSize: 14),
    filled: true,
    fillColor: HulyColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: HulyColors.accent, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

ButtonStyle hulyPrimaryButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: HulyColors.primaryButton,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  );
}

ButtonStyle hulyGhostButtonStyle() {
  return TextButton.styleFrom(
    foregroundColor: HulyColors.darkText,
    padding: const EdgeInsets.symmetric(vertical: 12),
    textStyle: const TextStyle(fontSize: 14),
  );
}
