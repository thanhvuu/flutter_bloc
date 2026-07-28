import 'package:bloc_app_demo/core/hive_database/entities/cart_item_entity/cart_item_entity.dart';

abstract class CartLocalDataSource {
  List<CartItemEntity> getCachedCartItems();
  Future<void> saveCartItem(CartItemEntity item);
  Future<void> removeCartItem(String id);
  Future<void> clearCart();
}