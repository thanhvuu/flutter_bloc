import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;


  const MainScreen({super.key,required this.navigationShell});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF5F5F5),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),

        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items:  [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          const BottomNavigationBarItem(icon: Icon(Icons.search),label: 'SHOP'),
          BottomNavigationBarItem(
            icon: BlocSelector<CartBloc, CartState, int>(
              selector: (state) => (state is CartLoaded) ? state.items.length : 0 ,
              builder: (context, count) {
                return Badge(
                  label: Text('$count'),
                  isLabelVisible: count > 0,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.shopping_bag)
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ]
      )
    );
  }
}