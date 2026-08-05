import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            RangeValues currentRange = RangeValues(state.minPrice, state.maxPrice);
            ProductSortOption selectedSort = state.sortOption;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'filter.title'.tr(),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'filter.price_range'.tr(namedArgs: {
                          'min': currentRange.start.round().toString(),
                          'max': currentRange.end.round().toString(),
                        }),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: currentRange,
                        min: 0,
                        max: 1000,
                        divisions: 100,
                        activeColor: Colors.red,
                        onChanged: (RangeValues newValues) {
                          setModalState(() => currentRange = newValues);
                          context.read<SearchBloc>().add(
                                FilterPriceChanged(
                                  minPrice: newValues.start,
                                  maxPrice: newValues.end,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'filter.sort_by'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text('filter.price_low_to_high'.tr()),
                            selected: selectedSort == ProductSortOption.priceLowToHigh,
                            selectedColor: Colors.red,
                            labelStyle: TextStyle(
                              color: selectedSort == ProductSortOption.priceLowToHigh
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: (bool isSelected) {
                              final newSort = isSelected
                                  ? ProductSortOption.priceLowToHigh
                                  : ProductSortOption.none;
                              setModalState(() => selectedSort = newSort);
                              context.read<SearchBloc>().add(SortOptionChanged(newSort));
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: Text('filter.price_high_to_low'.tr()),
                            selected: selectedSort == ProductSortOption.priceHighToLow,
                            selectedColor: Colors.red,
                            labelStyle: TextStyle(
                              color: selectedSort == ProductSortOption.priceHighToLow
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: (bool isSelected) {
                              final newSort = isSelected
                                  ? ProductSortOption.priceHighToLow
                                  : ProductSortOption.none;
                              setModalState(() => selectedSort = newSort);
                              context.read<SearchBloc>().add(SortOptionChanged(newSort));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
