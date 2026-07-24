import 'package:flutter/material.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/order_history_section.dart';

class MyOrdersModal extends StatelessWidget {
  final String userId;

  const MyOrdersModal({super.key, required this.userId});

  static void show(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MyOrdersModal(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: controller,
            child: OrderHistorySection(userId: userId),
          ),
        );
      },
    );
  }
}