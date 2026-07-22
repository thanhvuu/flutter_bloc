import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/features/payment/bloc/payment_bloc.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Quản lý các ô nhập liệu Shipping Info
  final _firstNameController = TextEditingController(text: 'JOHN');
  final _lastNameController = TextEditingController(text: 'DOE');
  final _addressLine1Controller = TextEditingController(text: '123 ELITE WAY');
  final _addressLine2Controller = TextEditingController(text: 'APT 4B');
  final _cityController = TextEditingController(text: 'NEW YORK');
  final _zipCodeController = TextEditingController(text: '10001');
  final _phoneController = TextEditingController(text: '+1 555 123 4567');

  String _selectedPaymentMethod = 'stripe';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, paymentState) {
        if (paymentState is PaymentSuccess) {
          // 1. Stripe báo THÀNH CÔNG -> Lấy danh sách món trong Cart và gửi CheckoutCartEvent
          final cartState = context.read<CartBloc>().state;
          if (cartState is CartLoaded) {
            context.read<CartBloc>().add(
                  CheckoutCartEvent(cartState.items, cartState.total),
                );
          }

          // 2. Hiển thị thông báo và quay về Home
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Thanh toán & Đặt hàng thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/home');
        } else if (paymentState is PaymentFailure) {
          // 3. Stripe THẤT BẠI / HỦY -> Hiển thị lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Lỗi: ${paymentState.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'ELITE ATHLETE',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState is! CartLoaded) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }

            final items = cartState.items;
            final total = cartState.total;
            final subtotal = cartState.subtotal;
            final shipping = cartState.shippingFee;
            final tax = cartState.tax;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TIÊU ĐỀ
                  const Text(
                    'CHECKOUT',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                  const Divider(thickness: 2, color: Colors.black),
                  const SizedBox(height: 16),

                  // 1. SECTION: SHIPPING INFORMATION
                  _buildShippingInfo(),
                  const SizedBox(height: 20),

                  // 2. SECTION: PAYMENT METHOD
                  _buildPaymentMethod(),
                  const SizedBox(height: 20),

                  // 3. SECTION: ORDER SUMMARY
                  _buildOrderSummary(
                    items: items,
                    subtotal: subtotal,
                    shipping: shipping,
                    tax: tax,
                    total: total,
                  ),
                  const SizedBox(height: 20),

                  // 4. SECTION: NÚT PLACE ORDER (Giao tiếp hoàn toàn với PaymentBloc)
                  _buildPlaceOrderButton(total),
                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      'By placing your order, you agree to our Terms of Service.',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // WIDGET 1: SHIPPING INFORMATION
  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 20),
              SizedBox(width: 8),
              Text('SHIPPING INFORMATION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('FIRST NAME', _firstNameController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('LAST NAME', _lastNameController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('ADDRESS LINE 1', _addressLine1Controller),
          const SizedBox(height: 12),
          _buildTextField('ADDRESS LINE 2 (OPTIONAL)', _addressLine2Controller),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('CITY', _cityController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('ZIP CODE', _zipCodeController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('PHONE NUMBER', _phoneController),
        ],
      ),
    );
  }

  // WIDGET 2: PAYMENT METHOD
  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, size: 20),
              SizedBox(width: 8),
              Text('PAYMENT METHOD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = 'stripe'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedPaymentMethod == 'stripe' ? Colors.black : Colors.grey.shade300,
                  width: _selectedPaymentMethod == 'stripe' ? 2 : 1,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.radio_button_checked, size: 18),
                  SizedBox(width: 12),
                  Text('CREDIT / DEBIT CARD (STRIPE)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Spacer(),
                  Icon(Icons.credit_card, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET 3: ORDER SUMMARY
  Widget _buildOrderSummary({
    required List<CartItem> items,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ORDER SUMMARY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
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
                          Text('Qty: ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
          _buildDarkRow('SUBTOTAL', '\$${subtotal.toStringAsFixed(2)}'),
          _buildDarkRow('SHIPPING', '\$${shipping.toStringAsFixed(2)}'),
          _buildDarkRow('TAX', '\$${tax.toStringAsFixed(2)}'),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET 4: BUTTON PLACE ORDER (Chuẩn BLoC Builder)
  Widget _buildPlaceOrderButton(double total) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, paymentState) {
        final isLoading = paymentState is PaymentLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC80000),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: isLoading
                ? null
                : () {
                    // Bấm Place Order -> Bắn Event tới PaymentBloc
                    context.read<PaymentBloc>().add(
                          ProcessPaymentEvent(
                            totalAmount: total,
                            currency: 'usd',
                          ),
                        );
                  },
            child: isLoading
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ],
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