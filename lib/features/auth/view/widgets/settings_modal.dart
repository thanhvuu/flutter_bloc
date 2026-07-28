import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsModal extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsModal({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  static void show(
    BuildContext context, {
    required bool isDarkMode,
    required ValueChanged<bool> onDarkModeChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SettingsModal(
        isDarkMode: isDarkMode,
        onDarkModeChanged: onDarkModeChanged,
      ),
    );
  }

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SETTINGS',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const Divider(thickness: 1.5, height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language, color: Colors.black),
            title: Text('settings.language'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            trailing: DropdownButton<String>(
              value: context.locale.languageCode,
              underline: const SizedBox(),
              items:  [
                DropdownMenuItem(value: 'vi', child: Text('profile.vietnamese'.tr())),
                DropdownMenuItem(value: 'en', child: Text('profile.english'.tr())),
              ],
              onChanged: (langCode) {
                if (langCode != null) {
                  context.setLocale(Locale(langCode, langCode == 'vi' ? 'VN' : 'US'));
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.black),
            title: Text('settings.dark_mode'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            value: _isDarkMode,
            activeColor: Colors.black,
            onChanged: (val) {
              setState(() {
                _isDarkMode = val;
              });
              widget.onDarkModeChanged(val);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}