// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'widgets/home_banner.dart';
import 'widgets/category_bar.dart';
import 'widgets/new_arrivals_section.dart';
import 'widgets/shop_by_category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeBanner(),
            const SizedBox(height: 30),
            CategoryBar(),
            const SizedBox(height: 20),
            NewArrivalsSection(),
            const SizedBox(height: 40),
            ShopByCategory(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}