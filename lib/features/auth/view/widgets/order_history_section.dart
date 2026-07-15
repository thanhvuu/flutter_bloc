import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/order/bloc/order_bloc.dart';
import 'package:bloc_app_demo/core/utils/order_formatter.dart';

class OrderHistorySection extends StatelessWidget {
  final String userId;

  const OrderHistorySection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'profile.order_history'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                context.read<OrderBloc>().add(LoadOrdersEvent(userId));
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }
            if (state is OrderError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            if (state is OrderLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text('profile.no_order_history'.tr(), style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text('profile.order'.tr(namedArgs: {'id': order.displayId.toString()}),
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('profile.order_date'.tr(namedArgs: {'date': order.displayDate})),
                      trailing: Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}