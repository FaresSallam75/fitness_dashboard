import 'package:flutter/material.dart';

class AppSettingsState {
  final Locale locale;
  final ThemeData themeData;
  final bool isDarkMode;

  AppSettingsState({
    required this.locale,
    required this.themeData,
    required this.isDarkMode,
  });

  AppSettingsState copyWith({
    Locale? locale,
    ThemeData? themeData,
    bool? isDarkMode,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      themeData: themeData ?? this.themeData,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
