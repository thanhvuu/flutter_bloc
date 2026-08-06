import 'package:flutter/material.dart';

class AppTheme{
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.red,
    cardColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      surface: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: Colors.red,
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.red,
      surface: Color(0xFF1E1E1E),
    )
  );
}