import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';

class OrderSummarySection extends StatelessWidget {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment.order_summary'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Image.network(
                      item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey, width: 50, height: 50),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text('payment.qty'.tr(namedArgs: {'qty': item.quantity.toString()}), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          const Divider(color: Colors.grey),
          _buildDarkRow('cart.subtotal'.tr(), '\$${subtotal.toStringAsFixed(2)}'),
          _buildDarkRow('cart.shipping'.tr(), '\$${shipping.toStringAsFixed(2)}'),
          _buildDarkRow('cart.tax'.tr(), '\$${tax.toStringAsFixed(2)}'),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('payment.total'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDarkRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}