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
      displayLarge: TextStyle(color: AppColor.blue),
      displayMedium: TextStyle(color: AppColor.blue),
      bodyMedium: TextStyle(color: AppColor.greyShade800),
      titleMedium: TextStyle(color: AppColor.greyShade800),
    ),
    backgroundColor: AppColor.greyShade100,
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
      contentPadding: const EdgeInsets.all(16),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: _outlineInputBorder(AppColor.greyShade400),
      enabledBorder: _outlineInputBorder(AppColor.greyShade400),
      focusedBorder: _outlineInputBorder(AppColor.blue),
      errorBorder: _outlineInputBorder(AppColor.error),
      focusedErrorBorder: _outlineInputBorder(AppColor.error),
      prefixIconColor: AppColor.blue,
      focusColor: AppColor.blue,
      errorStyle: _buildTextStyle(AppColor.error, size: 12),
      helperStyle: _buildTextStyle(AppColor.greyShade400, size: 12),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  AppTheme.darkTheme: ThemeData.dark().copyWith(
    useMaterial3: true,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColor.teal),
      displayMedium: TextStyle(color: AppColor.teal),
      bodyMedium: TextStyle(color: AppColor.white),
      titleMedium: TextStyle(color: AppColor.white),
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
      backgroundColor: AppColor.teal,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
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
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
};

_buildTextStyle(Color color, {double? size}) {
  return TextStyle(
    color: color,
    fontSize: size ?? 12,
  );
}

OutlineInputBorder _outlineInputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      width: 2,
      color: color,
    ),
  );
}
