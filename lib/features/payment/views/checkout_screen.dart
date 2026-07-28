import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/features/payment/bloc/payment_bloc.dart';
import 'package:bloc_app_demo/core/blocs/location/cubit/location_cubit.dart';
import 'package:bloc_app_demo/features/payment/views/widgets/shipping_info_section.dart';
import 'package:bloc_app_demo/features/payment/views/widgets/payment_method_section.dart';
import 'package:bloc_app_demo/features/payment/views/widgets/order_summary_section.dart';
import 'package:bloc_app_demo/features/payment/views/widgets/place_order_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _firstNameController = TextEditingController(text: 'Dang');
  final _lastNameController = TextEditingController(text: 'Vu');
  final _addressLine1Controller = TextEditingController(text: '123 Street');
  final _addressLine2Controller = TextEditingController(text: 'APT 4B');
  final _cityController = TextEditingController(text: 'HCM city');
  final _zipCodeController = TextEditingController(text: '10001');
  final _phoneController = TextEditingController(text: '+84 890 123 4567');

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
          final cartState = context.read<CartBloc>().state;
          if (cartState is CartLoaded) {
            context.read<CartBloc>().add(
                  CheckoutCartEvent(cartState.items, cartState.total,
                      status: 'PAID'),
                );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('payment.success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/home');
        } else if (paymentState is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('payment.error'.tr(namedArgs: {'msg': paymentState.message})),
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
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHECKOUT',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2),
                  ),
                  const Divider(thickness: 2, color: Colors.black),
                  const SizedBox(height: 16),

                  // 1 SHIPPING INFORMATION
                  BlocConsumer<LocationCubit, LocationState>(
                    listener: (context, locationState) {
                      if (locationState is LocationSuccess) {
                        _addressLine1Controller.text = locationState.address;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('payment.address_auto_success'.tr()),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (locationState is LocationError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(locationState.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, locationState) {
                      return ShippingInfoSection(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        addressLine1Controller: _addressLine1Controller,
                        addressLine2Controller: _addressLine2Controller,
                        cityController: _cityController,
                        zipCodeController: _zipCodeController,
                        phoneController: _phoneController,
                        isLocationLoading: locationState is LocationLoading,
                        onGetLocation: () {
                          context.read<LocationCubit>().fetchLocation();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 2SECTION: PAYMENT METHOD
                  PaymentMethodSection(
                    selectedMethod: _selectedPaymentMethod,
                    onMethodChanged: (method) =>
                        setState(() => _selectedPaymentMethod = method),
                  ),
                  const SizedBox(height: 20),

                  // 3 SECTION: ORDER SUMMARY
                  OrderSummarySection(
                    items: cartState.items,
                    subtotal: cartState.subtotal,
                    shipping: cartState.shippingFee,
                    tax: cartState.tax,
                    total: cartState.total,
                  ),
                  const SizedBox(height: 20),

                  // 4 SECTION: PLACE ORDER BUTTON
                  PlaceOrderButton(
                    total: cartState.total,
                    selectedMethod: _selectedPaymentMethod,
                    onCodSelected: () {
                      context.read<CartBloc>().add(CheckoutCartEvent(
                          cartState.items, cartState.total,
                          status: 'UNPAID'));

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('payment.order_success'.tr()),
                        backgroundColor: Colors.green,
                      ));
                      context.go('/home');
                    },
                  ),
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
}
