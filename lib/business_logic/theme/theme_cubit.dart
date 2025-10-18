import 'package:fitness_dashboard/business_logic/theme/theme_state.dart';
import 'package:fitness_dashboard/constants/theme.dart';
import 'package:fitness_dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
    : super(
        AppSettingsState(
          locale: const Locale('en'),
          themeData: themeEnglish,
          isDarkMode: false,
        ),
      ) {
    _initSettings();
  }

  Future<void> _initSettings() async {
    final langCode = myBox!.get("lang") ?? "en";
    final isDark = myBox!.get("isDark") ?? false;

    Locale locale = Locale(langCode);
    ThemeData baseTheme = langCode == "ar" ? themeArabic : themeEnglish;
    ThemeData theme = isDark
        ? themeDark
        : baseTheme; //ThemeData.dark().copyWith()

    emit(state.copyWith(locale: locale, themeData: theme, isDarkMode: isDark));
  }

  // Future<void> changeLanguage(String langCode) async {
  //   await myBox!.put("lang", langCode);

  //   Locale locale = Locale(langCode);
  //   ThemeData baseTheme = langCode == "ar" ? themeArabic : themeEnglish;
  //   ThemeData theme = state.isDarkMode
  //       ? ThemeData.dark().copyWith()
  //       : baseTheme;

  //   emit(state.copyWith(locale: locale, themeData: theme));
  // }

  Future<void> changeThemeMode() async {
    bool newDarkMode = !state.isDarkMode;
    await myBox!.put("isDark", newDarkMode);

    ThemeData baseTheme = state.locale.languageCode == "ar"
        ? themeArabic
        : themeEnglish;
    ThemeData theme = newDarkMode
        ? themeDark
        : baseTheme; //ThemeData.dark().copyWith()

    emit(state.copyWith(isDarkMode: newDarkMode, themeData: theme));
  }

  Future<void> toggleLanguage() async {
    final currentLang = state.locale.languageCode;

    String newLang = currentLang == "en" ? "ar" : "en";
    await myBox!.put("lang", newLang);

    Locale locale = Locale(newLang);
    ThemeData baseTheme = newLang == "ar" ? themeArabic : themeEnglish;
    ThemeData theme = state.isDarkMode
        ? themeDark // ThemeData.dark().copyWith()
        : baseTheme;

    emit(state.copyWith(locale: locale, themeData: theme));
  }
}
