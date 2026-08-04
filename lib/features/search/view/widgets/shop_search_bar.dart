import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/search/bloc/search_bloc.dart';
import 'filter_bottom_sheet.dart';

class ShopSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  const ShopSearchBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'search.hint'.tr(),
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
              onPressed: () {
                controller.clear();
                context.read<SearchBloc>().add(ClearSearch());
              },
            ),
          ),
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchKeywordChanged(value));
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.black),
          onPressed: () => FilterBottomSheet.show(context),
        ),
      ],
    );
  }
}
