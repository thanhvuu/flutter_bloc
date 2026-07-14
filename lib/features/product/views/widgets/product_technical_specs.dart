import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductTechnicalSpecs extends StatelessWidget {
  const ProductTechnicalSpecs({super.key});

  Widget _buildSpecRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.tech_specs'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.black, thickness: 1),
        _buildSpecRow('product_detail.offset'.tr(), '8mm'),
        _buildSpecRow('product_detail.surface'.tr(), 'product_detail.road_track'.tr()),
        _buildSpecRow('product_detail.support'.tr(), 'product_detail.neutral'.tr()),
      ],
    );
  }
}