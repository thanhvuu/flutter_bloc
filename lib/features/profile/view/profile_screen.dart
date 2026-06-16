import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';
import 'login_view.dart';
import 'dashboard_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Đã đăng nhập -> Vẽ màn hình Dashboard cá nhân
          return DashboardView(user: state.user);
        } else if (state is AuthLoading) {
          // Đang xử lý -> Vẽ màn hình chờ xoay tròn màu đỏ
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
          );
        } else {
          // Chưa đăng nhập -> Vẽ Form Đăng nhập & Đăng ký
          return const LoginView();
        }
      },
    );
  }
}