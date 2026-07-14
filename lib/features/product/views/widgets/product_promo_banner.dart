import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductPromoBanner extends StatelessWidget {
  const ProductPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF222222), Colors.black],
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'product_detail.promo_1'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Text(
                'product_detail.promo_2'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3),
              ),
            ],
          )
        ],
      ),
    );
  }
}