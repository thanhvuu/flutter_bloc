import 'package:go_router/go_router.dart';
import 'package:bloc_app_demo/features/auth/view/profile_screen.dart';
import 'package:bloc_app_demo/features/home/views/main_screen.dart';
import 'package:bloc_app_demo/features/home/views/home_screen.dart';
import 'package:bloc_app_demo/features/cart/views/cart_screen.dart';
import 'package:bloc_app_demo/features/search/view/shop_screen.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/features/product/views/product_detail_screen.dart';

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
              builder: (context,state) {
                final category = state.uri.queryParameters['category'];
                return ShopScreen(initialCategory: category);
              },
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
                ),
              ]
              )
        ]
      ),
      GoRoute(
        path: '/product_detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
    ]
  );
}