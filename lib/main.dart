import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:bloc_app_demo/core/di/injection.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_app_demo/core/router/app_router.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_app_demo/features/order/bloc/order_bloc.dart';
import 'package:bloc_app_demo/features/network/bloc/network_bloc.dart';
import 'package:bloc_app_demo/features/network/view/no_network_screen.dart';
import 'package:bloc_app_demo/features/payment/bloc/payment_bloc.dart';
import 'package:bloc_app_demo/core/blocs/location/cubit/location_cubit.dart';
import 'package:bloc_app_demo/core/utils/app_bloc_observe.dart';
import 'package:bloc_app_demo/core/blocs/theme/cubit/theme_cubit.dart';
import 'package:bloc_app_demo/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51TvUAzCaQ5qjnc7OfVJKtWrMeJdnrKMezq9LeM5NlD0XjV0u0ZFP2tQrHuJioS41DLfadPWimYibPjnhKgl9s62I00sf4Tobow';

  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  final injection = Injection();
  await injection.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi', 'VN'),
      child: MyApp(injection: injection),
    ),
  );
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
          create: (context) => CartBloc(injection.cartRepository,injection.authRepository, injection.orderRepository)..add(LoadCartEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(repository: injection.productRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: injection.authRepository),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(orderRepository: injection.orderRepository),
        ),
        BlocProvider<NetworkBloc>(
          create: (context) => NetworkBloc(networkRepository: injection.networkRepository)..add(NetworkObserve()),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(paymentRepository: injection.paymentRepository),
        ),
        BlocProvider(
          create: (context) => LocationCubit(repository: injection.locationRepository),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(themeRepository: injection.themeRepository),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
            builder: (context, child) {
              return BlocBuilder<NetworkBloc, NetworkState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      child ?? const SizedBox.shrink(), 
                      if (state is NetworkFailure)
                        const NoNetworkOverlay(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}