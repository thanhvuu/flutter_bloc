import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
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

      // Bọc BlocListener ở đây để lắng nghe phản hồi từ CartBloc
      
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('search.initial'.tr(), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            if (state is SearchLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state is SearchEmpty) {
              return  Center(
                child: Text(
                  'search.empty'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }

            if (state is SearchError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: Colors.red)),
              );
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
                  
                  return GestureDetector(
                    onTap: () => context.push('/product_detail', extra: product),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.category,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                      ),
                      const SizedBox(height: 6),
                      // Hiển thị giá tiền và nút thêm sản phẩm vào giỏ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.black, size: 20),
                            onPressed: () {
                              // View chỉ gửi event yêu cầu thêm hàng đi, không tự kiểm tra Auth
                              final cartItem = CartItem(
                                id: product.id, 
                                product: product,
                                quantity: 1,
                              );
                              context.read<CartBloc>().add(AddToCartEvent(cartItem));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      
    );
  }

  // Hàm hiển thị Dialog cảnh báo và chuyển tab
  
}