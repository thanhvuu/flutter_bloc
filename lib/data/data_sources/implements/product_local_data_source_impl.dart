import 'package:bloc_app_demo/core/errors/exception.dart';
import 'package:bloc_app_demo/core/hive_database/daos/product_dao.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final ProductDao productDao;

  ProductLocalDataSourceImpl({required this.productDao});

  @override
  List<ProductEntity> getCachedProducts() {
    return productDao.getAll();
  }

  @override
  Future<void> cacheProducts(List<ProductEntity> products) async {
    try {
      await productDao.insertAll(products);
    } catch (e) {
      throw CacheException();
    }
  }
}