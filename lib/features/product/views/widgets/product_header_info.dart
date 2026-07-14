import 'package:flutter/material.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';

class ProductHeaderInfo extends StatelessWidget {
  final Product product;
  
  
  final Color primaryRed = const Color(0xFFC00010);

  const ProductHeaderInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.category.toUpperCase(), 
          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          product.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}