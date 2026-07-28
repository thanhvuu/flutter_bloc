import 'package:bloc_app_demo/core/hive_database/daos/cart_dao.dart';
import 'package:bloc_app_demo/core/hive_database/entities/cart_item_entity/cart_item_entity.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/cart_local_data_source.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final CartDao cartDao;

  CartLocalDataSourceImpl({required this.cartDao});

  @override
  List<CartItemEntity> getCachedCartItems() {
    return cartDao.getAll();
  }

  @override
  Future<void> saveCartItem(CartItemEntity item) async {
    await cartDao.insert(item);
  }

  @override
  Future<void> removeCartItem(String id) async {
    await cartDao.delete(id);
  }

  @override
  Future<void> clearCart() async {
    await cartDao.clear();
  }
}