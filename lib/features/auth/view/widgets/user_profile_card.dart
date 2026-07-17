import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';

class UserProfileCard extends StatelessWidget {
  final User user;

  const UserProfileCard({super.key, required this.user});


  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('profile.language'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('profile.english').tr(),
                trailing: context.locale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () {
                  context.setLocale(const Locale('en', 'US'));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                title: const Text('profile.vietnamese').tr(),
                trailing: context.locale.languageCode == 'vi' ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () {
                  context.setLocale(const Locale('vi', 'VN'));
                  Navigator.pop(bottomSheetContext);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  radius: 28,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(user.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(Icons.phone_android, 'profile.phone'.tr(), user.phone),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on_outlined, 'profile.address'.tr(), user.address),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showLanguageBottomSheet(context),
              child: _buildInfoRow(
                Icons.language,
                'profile.language'.tr(),
                context.locale.languageCode == 'vi' ? 'profile.vietnamese'.tr() : 'profile.english'.tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}