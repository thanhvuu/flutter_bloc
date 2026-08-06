abstract class ThemeLocalDataSource {
  Future<String> getCachedThemeString();
  Future<void> cacheThemeString(String themeString);
}