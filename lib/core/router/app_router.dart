
import 'package:bloc_app_demo/features/profile/view/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_app_demo/features/home/views/main_screen.dart';
import 'package:bloc_app_demo/features/home/views/home_screen.dart';
import 'package:bloc_app_demo/features/cart/views/cart_screen.dart';
import 'package:bloc_app_demo/features/search/view/shop_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path:'/home',
              builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/shop',
              builder: (context,state) => const ShopScreen(),
              ),
            ] ,
            ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/cart',
              builder: (context,state) => const CartScreen(),
              ),
            ],
             ),
             StatefulShellBranch(
              routes: [
                GoRoute(path: '/profile',
                builder: (context,state) => const ProfileScreen(),
                )
              ]
               )
        ]
      )
    ]
  );
}