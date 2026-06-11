import 'package:bloc_app_demo/core/hive_database/daos/cart_dao.dart';
import 'package:bloc_app_demo/core/hive_database/entities/cart_item_entity/cart_item_entity.dart';

class CartLocalDataSource {
  final CartDao cartDao;

  CartLocalDataSource({required this.cartDao});

  List<CartItemEntity> getCachedCartItems() {
    return cartDao.getAll();
  }

  Future<void> saveCartItem(CartItemEntity item) async {
    await cartDao.insert(item);
  }

  Future<void> removeCartItem(String id) async {
    await cartDao.delete(id);
  }

  Future<void> clearCart() async {
    await cartDao.clear();
  }
}