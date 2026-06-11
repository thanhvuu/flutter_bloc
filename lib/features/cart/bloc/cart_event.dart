part of 'cart_bloc.dart';

@immutable
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override  
  List<Object?> get props => [];
}

final class LoadCartEvent extends CartEvent {}

final class AddToCartEvent extends CartEvent {
  final CartItem item;
  const AddToCartEvent(this.item);

  @override  
  List<Object?> get props => [item];
}

final class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  const RemoveFromCartEvent(this.itemId);

  @override  
  List<Object?> get props => [itemId];
}

final class UpdateCartQuantityEvent extends CartEvent {
  final CartItem item;
  final int newQuantity;

 const UpdateCartQuantityEvent(this.item, this.newQuantity);

 @override  
 List<Object?> get props => [item,newQuantity];
}

final class CheckoutCartEvent extends CartEvent {
  final List<CartItem> items;
  final double totalAmount;
  const CheckoutCartEvent(this.items, this.totalAmount);

  List<Object?> get props => [items, totalAmount];
}
