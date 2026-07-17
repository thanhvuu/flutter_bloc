
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final List<String> categories = ['ALL', 'Footwear', 'Apparel', 'Running', 'Training', 'Basketball'];

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        String currentCategory = 'ALL';
        if (state is HomeLoaded) {
          currentCategory = state.selectedCategory;
        }

        return SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final bool isSelected = category == currentCategory;

              String displayName = category;
              if (category == 'ALL') {
                displayName = 'home.all'.tr();
              } else if (category == 'Footwear') {
                displayName = 'home.footwear'.tr();
              } else if (category == 'Apparel') {
                displayName = 'home.apparel'.tr();
              } else if (category == 'Running') {
                displayName = 'home.running'.tr();
              } else if (category == 'Training') {
                displayName = 'home.training'.tr();
              } else if (category == 'Basketball') {
                displayName = 'home.basketball'.tr();
              }

              return GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(ChangeCategoryEvent(category));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey.shade800,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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