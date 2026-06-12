import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloc_app_demo/core/di/injection.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_app_demo/core/router/app_router.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final injection = Injection();
  await injection.init();

  runApp(MyApp(injection: injection));
}


class MyApp extends StatelessWidget {
  final Injection injection;
  const MyApp({super.key, required this.injection});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(injection.productRepository)..add(LoadHomeDataEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(injection.cartRepository)..add(LoadCartEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(repository: injection.productRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: injection.authRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'BLoC App Demo',
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse, 
            PointerDeviceKind.touch, 
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad, 
          },
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}