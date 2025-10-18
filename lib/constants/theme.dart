import 'package:fitness_dashboard/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeEnglish = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0.3,
    iconTheme: IconThemeData(color: MyColors.black),
    titleTextStyle: TextStyle(
      color: MyColors.black01,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Roboto",
    ), // Cairo

    backgroundColor: MyColors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.primary,
  ),
  fontFamily: "Roboto",
  iconTheme: IconThemeData(size: 20.0, color: MyColors.black01),
  textTheme: TextTheme(
    /*   titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.secondColor), */
    headlineLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MyColors.grey01,
    ),
    headlineMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        color: MyColors.dark,
        fontSize: 20.0,
        // fontWeight: FontWeight.bold,
        fontWeight: FontWeight.w500,
      ),
    ),

    headlineSmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        color: MyColors.whiteObasity,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),

    bodyLarge: TextStyle(
      color: MyColors.black,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    bodyMedium: TextStyle(
      color: MyColors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: MyColors.black,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: MyColors.orange,
    textTheme: ButtonTextTheme.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
);

ThemeData themeArabic = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0.0,
    iconTheme: IconThemeData(color: MyColors.white),
    titleTextStyle: TextStyle(
      color: MyColors.blueDark,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: "Cairo",
    ),

    backgroundColor: MyColors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.primary,
  ),
  fontFamily: "Cairo",
  textTheme: const TextTheme(
    /*   titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.secondColor), */
    headlineLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MyColors.blueDark,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: MyColors.blueDark,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontSize: 17,
      color: MyColors.blueDark,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      height: 1.5,
      color: MyColors.grey01,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    bodyMedium: TextStyle(color: MyColors.grey01, fontSize: 17),
    bodySmall: TextStyle(color: MyColors.grey01, fontSize: 15),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0.3,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Roboto",
    ),
    backgroundColor: Color(0xFF1E1E1E), // AppBar background
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.primary, // نفس اللون الأساسي بتاعك
  ),
  fontFamily: "Roboto",
  iconTheme: const IconThemeData(size: 20.0, color: MyColors.black),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white70, //white70
      ),
    ),
    headlineMedium: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: MyColors.black01, //white
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineSmall: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: MyColors.white, //white70
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),

    bodyLarge: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    bodyMedium: const TextStyle(
      color: Colors.white70,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: const TextStyle(
      color: Colors.white60,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // خلفية أساسية للدارك
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    buttonColor: MyColors.orange, //primary
  ),
);
