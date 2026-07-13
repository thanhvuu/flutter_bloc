import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          }

          if (state is CartError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }

          if (state is CartLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  'cart.empty'.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'cart.title'
                        .tr(namedArgs: {'count': items.length.toString()}),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 20),
                    height: 2,
                    width: 150,
                    color: Colors.black,
                  ),
                  ...items.map((item) => CartItemCard(item: item)),
                  CartSummary(
                    items: items,
                    subtotal: state.subtotal,
                    shippingFee: state.shippingFee,
                    tax: state.tax,
                    total: state.total,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
