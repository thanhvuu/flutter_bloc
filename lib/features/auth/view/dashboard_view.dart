import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_app_demo/features/order/bloc/order_bloc.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/user_profile_card.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/order_history_section.dart';

class DashboardView extends StatefulWidget {
  final User user;
  const DashboardView({super.key, required this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('profile.title'.tr(),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequestedEvent());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(user: widget.user),
            const SizedBox(height: 32),
            OrderHistorySection(userId: widget.user.id),
          ],
        ),
      ),
    );
  }
}
