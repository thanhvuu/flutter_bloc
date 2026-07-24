import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/payment/bloc/payment_bloc.dart';

class PlaceOrderButton extends StatelessWidget {
  final double total;
  final String selectedMethod;
  final VoidCallback onCodSelected; 

  const PlaceOrderButton({
    super.key, 
    required this.total,
    required this.selectedMethod,
    required this.onCodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, paymentState) {
        final isStripeLoading = paymentState is PaymentLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC80000),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: isStripeLoading
                ? null
                : () {
                    if (selectedMethod == 'stripe') {
                      context.read<PaymentBloc>().add(
                            ProcessPaymentEvent(
                              totalAmount: total,
                              currency: 'usd',
                            ),
                          );
                    } else {
                      onCodSelected();
                    }
                  },
            child: isStripeLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'PLACE ORDER',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
                  ),
          ),
        );
      },
    );
  }
}