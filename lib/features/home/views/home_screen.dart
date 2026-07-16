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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeBanner(),
            SizedBox(height: 30),
            CategoryBar(),
            SizedBox(height: 20),
            NewArrivalsSection(),
            SizedBox(height: 40),
            ShopByCategory(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}