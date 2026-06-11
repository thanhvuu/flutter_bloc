import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable{
  final String id;
  final Product product;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  @override   
  List<Object?>get props => [id, product, quantity];

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id:id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}