import 'package:flutter/material.dart';
import 'package:bloc_app_demo/domain/repositories/theme_repository.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<ThemeMode> getCachedThemeMode() async {
    final themeString = await localDataSource.getCachedThemeString();
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    String themeString = 'system';
    if (themeMode == ThemeMode.dark) themeString = 'dark';
    if (themeMode == ThemeMode.light) themeString = 'light';

    await localDataSource.cacheThemeString(themeString);
  }
}