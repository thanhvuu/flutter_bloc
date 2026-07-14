import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductKeyFeatures extends StatelessWidget {
  const ProductKeyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      'product_detail.feature_1'.tr(),
      'product_detail.feature_2'.tr(),
      'product_detail.feature_3'.tr(),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.key_features'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 8),
        ...features.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(' ', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Expanded(child: Text(e, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5))),
            ],
          ),
        )),
      ],
    );
  }
}