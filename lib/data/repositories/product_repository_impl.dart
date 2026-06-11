import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/domain/repositories/product_repository.dart';
import 'package:bloc_app_demo/data/data_sources/product_remote_data_source.dart';
import 'package:bloc_app_demo/data/data_sources/product_local_data_source.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts() async {
    try {
      //call api
      final remoteModels = await remoteDataSource.getProducts();

      //map remote models to hive entities and cache them
      final hiveEntities = remoteModels.map((model) => ProductEntity(
        id: model.id.toString(),
        name: model.name,
        description: model.description,
        price: (model.price is num) ? (model.price as num).toDouble() : 0.0,
        category: model.category ?? 'Unknown',
        imageUrl: model.imageUrl ?? '',
        createdAt: model.createdAt ?? DateTime.now(),
      )).toList();
      await localDataSource.cacheProducts(hiveEntities);

      //map remote models to domain entities and return
      return remoteModels.map((m) => m.toEntity()).toList();

    } catch (e) {
      //not call api, get cached data
      final cachedEntities = localDataSource.getCachedProducts();
      return cachedEntities.map((entity) => Product(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        price: entity.price,
        imageUrl: entity.imageUrl,
        createdAt: entity.createdAt,
        category: entity.category,
      )).toList();
    }
  }

  @override  
  Future<List<Product>> searchProducts(String keywords) async {
    final allProducts = await getProducts();

    await Future.delayed(const Duration(seconds: 3));

    final lowerKeyword = keywords.toLowerCase();
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerKeyword);
    }).toList();

  }
}