import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Vừa vào màn hình là gọi sự kiện lấy dữ liệu giỏ hàng từ Hive
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền xám nhạt sang trọng
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: BlocSelector<CartBloc, CartState, int>(
                  selector: (state) {
                    if (state is CartLoaded) {
                      return state.items.length;
                    }
                    return 0;
                  },
                  builder: (context, cartCount) {
                    if (cartCount == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }
          
          if (state is CartError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          if (state is CartLoaded) {
            final items = state.items;
            
            if (items.isEmpty) {
              return  Center(
                child: Text(
                  'cart.empty'.tr(), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey)
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TIÊU ĐỀ YOUR CART
                  Text(
                    'cart.title'.tr(namedArgs: {'count': items.length.toString()}),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 20),
                    height: 2,
                    width: 150,
                    color: Colors.black, // Đường gạch chân đen
                  ),

                  // DANH SÁCH SẢN PHẨM
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final product = item.product;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ẢNH SẢN PHẨM
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // CHI TIẾT SẢN PHẨM
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.category.toUpperCase(),
                                        style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.name.toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Màu sắc và size đang để tĩnh vì API Product gốc chưa có 2 trường này
                                  Text('cart.color_size'.tr(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                  const SizedBox(height: 12),
                                  
                                  // NÚT TĂNG GIẢM VÀ NÚT XÓA
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child:                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              children: [
                                                
                                                InkWell(
                                                  onTap: () {
                                                    context.read<CartBloc>().add(
                                                      UpdateCartQuantityEvent(item, item.quantity - 1)
                                                    );
                                                  },
                                                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: Text('-', style: TextStyle(fontSize: 16))),
                                                ),
                                                
                                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                
                                                
                                                InkWell(
                                                  onTap: () {
                                                    context.read<CartBloc>().add(
                                                      UpdateCartQuantityEvent(item, item.quantity + 1)
                                                    );
                                                  },
                                                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: Text('+', style: TextStyle(fontSize: 16))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          
                                          InkWell(
                                            onTap: () {
                                              context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
                                            },
                                            child:  Row(
                                              children:  [
                                                const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text('cart.remove'.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                      ), 
                                     
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  // TỔNG KẾT (ORDER SUMMARY)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('cart.order_summary'.tr(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildSummaryRow('cart.subtotal'.tr(), '\$${state.totalAmount.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('cart.shipping'.tr(), '\$12.00'), // Phí ship cố định
                        const SizedBox(height: 8),
                        _buildSummaryRow('cart.tax'.tr(), '\$22.24'), // Thuế cố định
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('cart.total'.tr(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                            // Cộng dồn Tiền giày + Ship + Thuế
                            Text('\$${(state.totalAmount + 12.00 + 22.24).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('cart.promo_code'.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                             Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'cart.enter_code'.tr(),
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              color: Colors.black,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('cart.apply'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800, // Đỏ đậm
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () {
                              
                              context.read<CartBloc>().add(
                                CheckoutCartEvent(state.items, state.totalAmount + 12.00 + 22.24));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Text('cart.checkout'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'cart.terms'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 8, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(Icons.credit_card, color: Colors.grey),
                            SizedBox(width: 12),
                            Icon(Icons.account_balance_wallet, color: Colors.grey),
                            SizedBox(width: 12),
                            Icon(Icons.security, color: Colors.grey),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      
    );
  }

  
  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.black87, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}