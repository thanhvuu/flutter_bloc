import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_app_demo/core/widgets/product_card.dart';

class NewArrivalsSection extends StatelessWidget {
  const NewArrivalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.new_arrivals'.tr(),
                style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  context.go('/shop?category=ALL'); 
                },
                child: Text(
                  'home.see_all'.tr(),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator(color: Colors.red)),
              );
            }

            if (state is HomeError) {
              return SizedBox(
                height: 280,
                child: Center(
                  child: Text(state.errorMessage, style: const TextStyle(color: Colors.white)),
                ),
              );
            }

            if (state is HomeLoaded) {
              final products = state.products;

              return SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product); 
                  },
                ),
              );
            }

            return const SizedBox(height: 280);
          },
        ),
      ],
    );
  }
}