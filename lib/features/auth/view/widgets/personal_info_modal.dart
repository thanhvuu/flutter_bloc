import 'package:flutter/material.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonalInfoModal extends StatelessWidget {
  final User user;

  const PersonalInfoModal({super.key, required this.user});

  static void show(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PersonalInfoModal(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile.personal_info'.tr().toUpperCase(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const Divider(thickness: 1.5, height: 24),
          _buildInfoItem(Icons.person, 'profile.full_name'.tr(), user.name),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.email, 'profile.email_label'.tr(), user.email),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.phone, 'profile.phone_number'.tr(), user.phone.isEmpty ? 'profile.na'.tr() : user.phone),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.location_on, 'profile.shipping_address'.tr(), user.address.isEmpty ? 'profile.na'.tr() : user.address),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}