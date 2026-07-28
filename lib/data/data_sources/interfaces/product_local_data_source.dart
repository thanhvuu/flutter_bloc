import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';

abstract class ProductLocalDataSource {
  List<ProductEntity> getCachedProducts();
  Future<void> cacheProducts(List<ProductEntity> products);
}