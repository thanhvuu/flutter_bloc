import 'package:bloc_app_demo/core/hive_database/daos/product_dao.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';

class ProductLocalDataSource {
  final ProductDao productDao;

  ProductLocalDataSource({required this.productDao});

  List<ProductEntity> getCachedProducts() {
    return productDao.getAll();

  }

  Future<void> cacheProducts(List<ProductEntity> products) async {
    await productDao.insertAll(products);
  }
}