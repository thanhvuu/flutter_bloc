import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product_detail', extra: product),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration (
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit:BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2,),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.broken_image, color:  Colors.grey,),
                    )),
                  
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.red,
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
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
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
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
                          child: Row(
                            children: [
                              const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'home.add_to_cart'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      ),
    );
  }
}