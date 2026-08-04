import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/core/widgets/product_card.dart';

class ShopProductGrid extends StatelessWidget {
  final ScrollController scrollController;

  const ShopProductGrid({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          if (state is SearchEmpty) {
            return Center(
              child: Text(
                'search.empty'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          if (state is SearchError) {
            return Center(
                child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          if (state is SearchLoaded) {
            final products = state.results;

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final Product product = products[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
                if (state.isFetchingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2.5),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
