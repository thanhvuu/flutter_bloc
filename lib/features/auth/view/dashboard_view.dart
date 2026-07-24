import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_app_demo/features/order/bloc/order_bloc.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/profile_menu_item.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/personal_info_modal.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/settings_modal.dart';
import 'package:bloc_app_demo/features/auth/view/widgets/my_orders_modal.dart';

class DashboardView extends StatefulWidget {
  final User user;
  const DashboardView({super.key, required this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              widget.user.name.toUpperCase(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 8),

            // 1. MY ORDERS
            ProfileMenuItem(
              title: 'MY ORDERS',
              onTap: () => MyOrdersModal.show(context, widget.user.id),
            ),

            // 2. PERSONAL INFORMATION
            ProfileMenuItem(
              title: 'PERSONAL INFORMATION',
              onTap: () => PersonalInfoModal.show(context, widget.user),
            ),

            // 3. SETTINGS
            ProfileMenuItem(
              title: 'SETTINGS',
              onTap: () => SettingsModal.show(
                context,
                isDarkMode: _isDarkMode,
                onDarkModeChanged: (val) => setState(() => _isDarkMode = val),
              ),
            ),

            const SizedBox(height: 40),

            // 4. LOGOUT
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequestedEvent());
                },
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}