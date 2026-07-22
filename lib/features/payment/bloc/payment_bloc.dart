import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({required PaymentRepository paymentRepository}) : _paymentRepository = paymentRepository,
  super(PaymentInitial()) {
    on<ProcessPaymentEvent>((event, emit) async {
      emit(PaymentLoading());

      final result = await _paymentRepository.processPayment(totalAmount: event.totalAmount, currency: event.currency);

      result.fold(
        (failure) => emit (PaymentFailure(failure.message)),
        (_) => emit(PaymentSuccess()),
      );
    });
  }
}
