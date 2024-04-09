import 'package:flutter/material.dart';

//
class MyColors {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blueColor = Color(0xFF0096FF);
  static const Color greenColor = Color(0xFF075e54);
  static const Color lightGreenColor = Color(0xFF128c7e);
  static const Color blackColor = Color(0xFF000000);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: MyColors.whiteColor,
    onPrimary: MyColors.whiteColor,
    secondary: MyColors.greenColor,
    onSecondary: MyColors.greenColor,
    error: MyColors.whiteColor,
    onError: MyColors.whiteColor,
    background: MyColors.whiteColor,
    onBackground: MyColors.greenColor,
    surface: MyColors.greenColor,
    onSurface: MyColors.whiteColor,
    inverseSurface: MyColors.lightGreenColor,
    onPrimaryContainer: MyColors.whiteColor,
    onSurfaceVariant: MyColors.whiteColor,
    outline: MyColors.whiteColor,
    primaryContainer: MyColors.lightGreenColor,
  ),
  snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
    color: MyColors.whiteColor, // Set your desired text color here
  )),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: MyColors.blueColor, // Set your desired text color here
    ),
    bodyMedium: TextStyle(
      color: MyColors.blackColor, // Set your desired text color here
    ),
    // Add more text styles as needed
  ),
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(
      color: MyColors.blackColor,
    ),
    colorScheme: const ColorScheme.dark(
      inverseSurface: MyColors.lightGreenColor,
      primaryContainer: MyColors.lightGreenColor,
      primary: MyColors.blueColor,
    ));
