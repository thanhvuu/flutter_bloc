import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/core/widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  final String? initialCategory;
  const ShopScreen({super.key, this.initialCategory});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = ['ALL', 'Footwear', 'Apparel', 'Running', 'Training', 'Basketball'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(covariant ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    context.read<SearchBloc>().add(LoadProductsEvent(category: widget.initialCategory));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, 
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'search.hint'.tr(),
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchBloc>().add(ClearSearch());
                },
              ),
            ),
            onChanged: (value) {
              context.read<SearchBloc>().add(SearchKeywordChanged(value));
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final activeCategory = state.selectedCategory; 
              return SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final bool isSelected = cat.toLowerCase() == activeCategory.toLowerCase();

                    String displayName = cat;
                if (cat == 'ALL') {
                displayName = 'home.all'.tr();
              } else if (cat == 'Footwear') {
                displayName = 'home.footwear'.tr();
              } else if (cat == 'Apparel') {
                displayName = 'home.apparel'.tr();
              } else if (cat == 'Running') {
                displayName = 'home.running'.tr();
              } else if (cat == 'Training') {
                displayName = 'home.training'.tr();
              } else if (cat == 'Basketball') {
                displayName = 'home.basketball'.tr();
              }


                    return GestureDetector(
                      onTap: () {
                        context.read<SearchBloc>().add(LoadProductsEvent(category: cat));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.red : Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          
          // 2. HIỂN THỊ DANH SÁCH SẢN PHẨM
          Expanded(
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
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }

                if (state is SearchLoaded) {
                  final products = state.results;
                  return GridView.builder(
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
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}