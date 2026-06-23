part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class LoadOrdersEvent extends OrderEvent {
  final String userId;
  
  const LoadOrdersEvent (this.userId);

  @override  
  List<Object?> get props => [userId];
}
