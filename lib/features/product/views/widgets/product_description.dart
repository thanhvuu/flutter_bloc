import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.performance'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text(
          description, 
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
        ),
      ],
    );
  }
}