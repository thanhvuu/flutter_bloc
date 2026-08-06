import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/theme_local_data_source.dart';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource{
  static const String _themeBoxName = 'setting_box';
  static const String _themeKey = 'current_theme_mode';

  @override  
  Future<String> getCachedThemeString() async{
    final box = await Hive.openBox(_themeBoxName);
    return box.get(_themeKey, defaultValue: 'system');
  }

  @override  
  Future<void> cacheThemeString(String themeString) async {
    final box = await Hive.openBox(_themeBoxName);
    return box.put(_themeKey, themeString);
  }
}