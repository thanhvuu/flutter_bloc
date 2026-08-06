import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<ThemeMode> getCachedThemeMode();
  Future<void> cacheThemeMode(ThemeMode themeMode);
}