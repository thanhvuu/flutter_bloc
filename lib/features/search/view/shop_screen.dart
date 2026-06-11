import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, 
        // Giao diện thanh Search trên AppBar
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
              hintText: 'Tìm kiếm thiết bị, đồ thể thao...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              // Nút X xóa chữ
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchBloc>().add(ClearSearch());
                },
              ),
            ),
            onChanged: (value) {
              // Bắn event khi gõ (Đã có debounce)
              context.read<SearchBloc>().add(SearchKeywordChanged(value));
            },
          ),
        ),
      ),

      // Phần thân trang: Lắng nghe kết quả từ SearchBloc
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          // 1. Trạng thái ban đầu chưa tìm kiếm
          if (state is SearchInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nhập tên sản phẩm để tìm kiếm', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 2. Trạng thái đang tải (Loading)
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          // 3. Trạng thái không tìm thấy sản phẩm
          if (state is SearchEmpty) {
            return const Center(
              child: Text(
                'Không tìm thấy sản phẩm nào!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          // 4. Bị lỗi
          if (state is SearchError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          // 5. Hiển thị Lưới sản phẩm khi tìm thành công (SearchLoaded)
          if (state is SearchLoaded) {
            final products = state.results;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              // Ẩn bàn phím khi vuốt màn hình
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,           // Hiển thị 2 cột
                childAspectRatio: 0.6,       // Tỷ lệ cho giống hình Elite Athlete
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Product product = products[index];
                
                // --- Đưa Widget _buildProductItem vào đây ---
                // (Bạn có thể tái sử dụng Widget _buildProductItem giống y hệt phần trước)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade200,
                        // Thêm Image thực tế vào đây:
                        // child: Image.network(product.imageUrl, fit: BoxFit.cover),
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
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}