import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
          // ResizeImage 
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              image: DecorationImage(
                image: ResizeImage(
                  NetworkImage(product.imageUrl),
                  width: 90,
                  height: 90,
                ),
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
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                UpdateCartQuantityEvent(item, item.quantity - 1),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Text('-', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                UpdateCartQuantityEvent(item, item.quantity + 1),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Text('+', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'cart.remove'.tr(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}