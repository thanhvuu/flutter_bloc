import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;

  const CategorySelector({super.key, required this.categories});

  String _getCategoryDisplayName(String cat) {
    switch (cat) {
      case 'ALL':
        return 'home.all'.tr();
      case 'Footwear':
        return 'home.footwear'.tr();
      case 'Apparel':
        return 'home.apparel'.tr();
      case 'Running':
        return 'home.running'.tr();
      case 'Training':
        return 'home.training'.tr();
      case 'Basketball':
        return 'home.basketball'.tr();
      default:
        return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final activeCategory = state.selectedCategory;
        return SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final bool isSelected =
                  cat.toLowerCase() == activeCategory.toLowerCase();

              return GestureDetector(
                onTap: () {
                  context.read<SearchBloc>().add(LoadProductsEvent(category: cat));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      _getCategoryDisplayName(cat),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
