import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductShippingInfo extends StatelessWidget {
  const ProductShippingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.black54),
            const SizedBox(width: 12),
            Text('product_detail.express_shipping'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.assignment_return_outlined, size: 16, color: Colors.black54),
            const SizedBox(width: 12),
            Text('product_detail.returns'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}