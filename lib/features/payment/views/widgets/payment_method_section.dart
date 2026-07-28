import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class PaymentMethodSection extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              const Icon(Icons.payment, size: 20),
              const SizedBox(width: 8),
              Text('payment.method'.tr(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => onMethodChanged('stripe'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedMethod == 'stripe' ? Colors.black : Colors.grey.shade300,
                  width: selectedMethod == 'stripe' ? 2 : 1,
                ),
              ),
              child:  Row(
                children: [
                  Icon(
                    selectedMethod == 'stripe'? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 18),
                  const SizedBox(width: 12),
                  Text('payment.credit_card'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.credit_card, size: 20),
                ],
                
              ),
            ),
          ),
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () => onMethodChanged('cod'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedMethod == 'cod' ? Colors.black : Colors.grey.shade300,
                  width: selectedMethod == 'cod' ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selectedMethod == 'cod' ? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 18,
                  ),
                  const SizedBox(width: 12 ),
                  Text('payment.cod'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.local_shipping, size: 20,),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}