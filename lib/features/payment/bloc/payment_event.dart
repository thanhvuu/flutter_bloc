part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessPaymentEvent extends PaymentEvent{
  final double totalAmount;
  final String currency;

  const ProcessPaymentEvent({
    required this.totalAmount,
    required this.currency,
  });

  @override   
  List<Object?> get props => [totalAmount,currency];
}
