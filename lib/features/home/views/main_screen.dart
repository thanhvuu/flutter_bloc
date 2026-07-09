import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';


class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;


  const MainScreen({super.key,required this.navigationShell});

  @override
  Widget build(BuildContext context){
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if(state is CartRequireAuth) {
          _showLoginRequiredDialog(context);
        }
      },
    
    child: Scaffold(
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
           BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: 'navbar.home'.tr(context: context)),
           BottomNavigationBarItem(icon: const Icon(Icons.search),label: 'navbar.search'.tr(context: context)),
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
            label: 'navbar.cart'.tr(context: context),
          ),
           BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: 'navbar.profile'.tr(context: context)),
        ]
      )
    )
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('search.login_required_title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text('search.login_required_content'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), 
              child: Text('common.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(dialogContext);

                  if (context.canPop()) {
                    context.pop();
                  }

                  navigationShell.goBranch(3);
                },
                child: Text('common.login_now'.tr(),style: const TextStyle(color: Colors.white),
                ),
              )
          ],
        );
      }
       );
  }
}