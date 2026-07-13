part of 'cart_bloc.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}  

final class CartInitial extends CartState {} 

final class CartLoading extends CartState {}

final class CartItemAddedSuccess extends CartState{}

final class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;
  

  const CartLoaded({ 
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
  });

  @override  
  List<Object?> get props => [items, subtotal, shippingFee, tax, total];
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