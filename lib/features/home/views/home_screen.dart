import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/home/bloc/home_bloc.dart';
import 'widgets/home_banner.dart';
import 'widgets/category_bar.dart';
import 'widgets/new_arrivals_section.dart';
import 'widgets/shop_by_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeBloc>().add(LoadMoreHomeDataEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
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