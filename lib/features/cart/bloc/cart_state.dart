part of 'cart_bloc.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}  

final class CartInitial extends CartState {} 

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItem> items;
  
  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  const CartLoaded(this.items);

  @override  
  List<Object?> get props => [items];
}

final class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override  
  List<Object?> get props => [message];
}

final class CartRequireAuth extends CartState {
  final int timestamp;
  const CartRequireAuth(this.timestamp);

  @override
  List<Object?> get props => [timestamp];
}