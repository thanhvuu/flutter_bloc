import 'dart:developer' as developer;
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/core/api/stripe_client.dart';
import 'package:bloc_app_demo/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripeClient _stripeClient;
  final String _secretKey = '';

  PaymentRepositoryImpl({required StripeClient stripeClient}) : _stripeClient = stripeClient;

  @override  
  Future<Either<Failure, Unit>> processPayment({
    required double totalAmount,
    required String currency,
  }) async {
    try {
      final amountInCents = (totalAmount * 100).toInt().toString();
      final response = await _stripeClient.createPaymentIntent('Bearer $_secretKey', amountInCents, currency, 'card');
      final clientSecret = response.data['client_secret'] as String?;
      
      if(clientSecret == null) {
        return  const Left(ServerFailure('không thể tạo mã thanh toán từ stripe'));
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ELITE ATHLETE',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return const Right(unit);
    } on StripeException catch(e) {
      developer.log('Stripe Exception: ${e.error.localizedMessage}');
      if(e.error.code == FailureCode.Canceled){
        return const Left(ServerFailure('Hủy thanh toán.'));
      }
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      developer.log('Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}


