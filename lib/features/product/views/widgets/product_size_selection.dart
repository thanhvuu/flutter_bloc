import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/product/bloc/product_detail_bloc.dart';

class ProductSizeSelection extends StatelessWidget {
  final ProductDetailLoaded state;

  const ProductSizeSelection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('product_detail.select_size'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('product_detail.size_guide'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey.shade600, decoration: TextDecoration.underline)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(state.sizes.length, (index) {
            bool isSelected = state.selectedSizeIndex == index;
            bool isAvailable = state.sizeAvailability[index]; 
            return GestureDetector(
              onTap: isAvailable ? () => context.read<ProductDetailBloc>().add(SelectSize(index)) : null,
              child: Container(
                width: (MediaQuery.of(context).size.width - 40 - 24) / 4, 
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : (isAvailable ? Colors.white : Colors.grey.shade100),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                ),
                alignment: Alignment.center,
                child: Text(
                  state.sizes[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isAvailable ? Colors.black : Colors.grey.shade400),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}