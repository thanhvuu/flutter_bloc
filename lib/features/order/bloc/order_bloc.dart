import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/entities/order.dart';
import 'package:bloc_app_demo/domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final  OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
  : _orderRepository =orderRepository,
    super(OrderInitial()) {

      on<LoadOrdersEvent>((event, emit) async {
        emit(OrderLoading());
        try {
          final orders = await _orderRepository.getUserOrders(event.userId);
          emit(OrderLoaded(orders));
        }catch (e) {
          emit(OrderError("OrderError: ${e.toString()}"));
        }
      });
    }
}
