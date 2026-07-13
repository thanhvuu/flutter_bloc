
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';

class CartSummary extends StatelessWidget {
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;

  
  const CartSummary({
    super.key,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cart.order_summary'.tr(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 16),
          _buildSummaryRow('cart.subtotal'.tr(), '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('cart.shipping'.tr(), '\$${shippingFee.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('cart.tax'.tr(), '\$${tax.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('cart.total'.tr(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('cart.promo_code'.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'cart.enter_code'.tr(),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              Container(
                height: 48,
                color: Colors.black,
                child: TextButton(
                  onPressed: () {},
                  child: Text('cart.apply'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () {
                context.read<CartBloc>().add(
                  CheckoutCartEvent(List.from(items), total),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('cart.checkout'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'cart.terms'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card, color: Colors.grey),
              SizedBox(width: 12),
              Icon(Icons.account_balance_wallet, color: Colors.grey),
              SizedBox(width: 12),
              Icon(Icons.security, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.black87, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}