import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';

abstract class PaymentRepository{
  Future<Either<Failure, Unit>> processPayment({
    required double totalAmount,
    required String currency,
  });
}