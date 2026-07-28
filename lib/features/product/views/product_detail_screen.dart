import 'package:flutter/material.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/features/product/bloc/product_detail_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_image.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_header_info.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_color_selection.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_size_selection.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_action_buttons.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_shipping_info.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_description.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_key_features.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_technical_specs.dart';
import 'package:bloc_app_demo/features/product/views/widgets/product_promo_banner.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocProvider(
      create: (_) =>
          ProductDetailBloc()..add(LoadProductsDetail(widget.product)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'ELITE ATHLETE',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 18),
          ),
        ),
        body: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartItemAddedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('product_detail.added_to_cart_success'.tr(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, detailState) {
              if (detailState is! ProductDetailLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductImage(imageUrl: widget.product.imageUrl),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProductHeaderInfo(product: widget.product),
                          const SizedBox(height: 24),
                          ProductColorSelection(state: detailState),
                          const SizedBox(height: 24),
                          ProductSizeSelection(state: detailState),
                          const SizedBox(height: 32),
                          ProductActionButtons(product: widget.product),
                          const SizedBox(height: 32),
                          const ProductShippingInfo(),
                          const Divider(
                              height: 48,
                              thickness: 1,
                              color: Color(0xFFEEEEEE)),
                          ProductDescription(
                              description: widget.product.description),
                          const SizedBox(height: 32),
                          const ProductKeyFeatures(),
                          const SizedBox(height: 32),
                          const ProductTechnicalSpecs(),
                          const SizedBox(height: 32),
                          const ProductPromoBanner(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
