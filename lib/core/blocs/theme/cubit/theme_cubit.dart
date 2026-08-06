import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/domain/repositories/theme_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeRepository themeRepository;

  ThemeCubit({required this.themeRepository}) : super(ThemeMode.system) {
    loadTheme();
  }

  // Đọc theme đã lưu
  Future<void> loadTheme() async {
    final themeMode = await themeRepository.getCachedThemeMode();
    emit(themeMode);
  }

  // Đổi sang theme mới
  Future<void> changeTheme(ThemeMode themeMode) async {
    await themeRepository.cacheThemeMode(themeMode);
    emit(themeMode);
  }
}