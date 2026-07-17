import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/product/bloc/product_detail_bloc.dart';

class ProductColorSelection extends StatelessWidget {
  final ProductDetailLoaded state;

  const ProductColorSelection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.select_color'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(state.colors.length, (index) {
            bool isSelected = state.selectedColorIndex == index;
            return GestureDetector(
              onTap: () => context.read<ProductDetailBloc>().add(SelectColor(index)),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: state.colors[index],
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}