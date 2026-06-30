import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:go_router/go_router.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['ALL', 'Footwear', 'Apparel', 'Nike', 'Adidas'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'ELITE ATHLETE',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body:  BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartRequireAuth) {
              _showLoginRequiredDialog(context);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Banner Section
               Container(
                height: 500, 
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    
                    image: const NetworkImage('https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=800'), 
                    fit: BoxFit.cover,
                    
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const Text(
                      'UNLEASH YOUR\nPOTENTIAL',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    
                    const Text(
                      'Engineered for the elite. Discover the\ncollection designed to push boundaries and\nredefine performance.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                  
                    Row(
                      children: [
                        
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), 
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('SHOP NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        
                        
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 1), 
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('VIEW COLLECTION', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
                
                const SizedBox(height: 30),

                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    String currentCategory = 'ALL';
                    if (state is HomeLoaded) {
                      currentCategory = state.selectedCategory;
                    }

                    return SizedBox(
                      height: 35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: categories.length,
                        itemBuilder: (context,index) {
                          final category = categories[index];
                          final bool isSelected = category == currentCategory;

                          return GestureDetector(
                            onTap: () {
                              context.read<HomeBloc>().add(ChangeCategoryEvent(category));
                            },

                            child: Container (
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration (
                                color: isSelected ? Colors.red : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.red : Colors.grey.shade800,
                                ),
                              ),
                              child: Center (
                                child: Text(category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  ),

                  

                            
              const SizedBox(height: 20), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NEW ARRIVALS',
                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('SEE ALL', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
                      child: Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.white))),
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

                          return GestureDetector(
                            onTap: () => context.push('/product_detail', extra: product),
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              color: const Color(0xFF1A1A1A),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(product.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      color: Colors.red,
                                      child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text('\$${product.price}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      
                                      
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(product.category.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                          
                                          
                                          InkWell(
                                            onTap: () {
                                        
                                              final item = CartItem(
                                                id: product.id, 
                                                product: product,
                                              );
                                             
                                              context.read<CartBloc>().add(AddToCartEvent(item));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
                                                  SizedBox(width: 4),
                                                  Text('ADD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          );
                        },
                      ),
                    );
                  }
                  
                  // Trạng thái khởi tạo mặc định ban đầu
                  return const SizedBox(height: 280);
                },
              ),
              
              // --- KẾT THÚC PHẦN NEW ARRIVALS ---


            ],
          ),
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Yêu cầu Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Bạn cần phải đăng nhập để thêm sản phẩm vào giỏ hàng.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext); // Đóng Dialog
                // Điều hướng sang Tab PROFILE (Index 3 của StatefulNavigationShell)
                StatefulNavigationShell.of(context).goBranch(3);
              },
              child: const Text('ĐĂNG NHẬP NGAY', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
