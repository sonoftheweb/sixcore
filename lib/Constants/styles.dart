import 'package:flutter/material.dart';

import 'colors.dart';

enum AppTheme {
  darkTheme,
  lightTheme,
}

final appThemeData = {
  AppTheme.lightTheme: ThemeData.light().copyWith(
    useMaterial3: true,
    textTheme: TextTheme(
      headline1: TextStyle(color: AppColor.blue),
      headline2: TextStyle(color: AppColor.blue),
      bodyText2: TextStyle(color: AppColor.greyShade800),
      subtitle1: TextStyle(color: AppColor.greyShade800),
    ),
    backgroundColor: Colors.grey.shade100,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 53, 62, 125),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22.0,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.blue,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: AppColor.whiteT,
      ),
      toolbarTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColor.grey,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColor.blue,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: AppColor.blue,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: AppColor.blue,
        ),
      ),
    ),
  ),
  AppTheme.darkTheme: ThemeData.dark().copyWith(
    useMaterial3: true,
    textTheme: TextTheme(
      headline1: TextStyle(color: AppColor.teal),
      headline2: TextStyle(color: AppColor.teal),
      bodyText2: TextStyle(color: AppColor.white),
      subtitle1: TextStyle(color: AppColor.white),
    ),
    backgroundColor: AppColor.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.teal,
        foregroundColor: AppColor.greyShade800,
        elevation: 0,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22.0,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.whiteT,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: AppColor.blue,
      ),
      toolbarTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColor.teal,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: AppColor.teal,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: AppColor.teal,
        ),
      ),
    ),
  ),
};
