import 'package:bloc_app_demo/data/data_sources/cart_remote_data_source.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:bloc_app_demo/domain/repositories/cart_repository.dart';
import 'package:bloc_app_demo/data/data_sources/cart_local_data_source.dart';
import 'package:bloc_app_demo/core/hive_database/entities/cart_item_entity/cart_item_entity.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final CartRemoteDataSource remoteDataSource;
  

  CartRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<List<CartItem>> getCartItems() async {
    final hiveEntities = localDataSource.getCachedCartItems();
    
    // Convert từ khuôn Hive sang Entity gốc để trả về cho UI
    return hiveEntities.map((entity) => CartItem(
      id: entity.id,
      quantity: entity.quantity,
      product: Product(
        id: entity.product.id,
        name: entity.product.name,
        description: entity.product.description,
        price: entity.product.price,
        imageUrl: entity.product.imageUrl,
        createdAt: entity.product.createdAt,
        category: entity.product.category,
      ),
    )).toList();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    // Convert từ Entity gốc thành khuôn Hive để cất vào kho
    final hiveEntity = CartItemEntity(
      id: item.id,
      quantity: item.quantity,
      product: ProductEntity(
        id: item.product.id,
        name: item.product.name,
        description: item.product.description,
        price: item.product.price,
        imageUrl: item.product.imageUrl,
        createdAt: item.product.createdAt,
        category: item.product.category,
      ),
    );
    await localDataSource.saveCartItem(hiveEntity);
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await localDataSource.removeCartItem(cartItemId);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }

  @override  
  Future<void> checkoutCart(List<CartItem> items, double totalAmount) async {
    final orderItems = items.map((item) => {
       "productId": item.product.id,
      "name": item.product.name,
      "price": item.product.price,
      "quantity": item.quantity,
    }).toList();

    await remoteDataSource.postOrder(orderItems, totalAmount);

    await localDataSource.clearCart();
  }
}