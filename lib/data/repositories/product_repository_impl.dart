import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
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
  Future<Either<Failure, List<Product>>> getProducts({required int page, required int limit}) async {
    try {
      //call api
      final remoteModels = await remoteDataSource.getProducts(page: page, limit: limit);

      //map remote models to hive entities and cache them
      final hiveEntities = remoteModels.map((model) => ProductEntity(
        id: model.id.toString(),
        name: model.name,
        description: model.description,
        price: (model.price is num) ? (model.price as num).toDouble() : 0.0,
        category: model.category ?? 'Unknown',
        imageUrl: model.imageUrl ?? '',
        createdAt: model.createdAt ?? DateTime.now(),
        colors: model.colors ?? [],
        sizes: model.sizes ?? [],
      )).toList();
      await localDataSource.cacheProducts(hiveEntities);

      //map remote models to domain entities and return
      final products = remoteModels.map((m) => m.toEntity()).toList();
      return Right(products);

    } catch (e) {
      //not call api, get cached data
      try {
        final cachedEntities = localDataSource.getCachedProducts();
        final products = cachedEntities.map((entity) => Product(
          id: entity.id,
          name: entity.name,
          description: entity.description,
          price: entity.price,
          imageUrl: entity.imageUrl,
          createdAt: entity.createdAt,
          category: entity.category,
          colors: entity.colors,
          sizes: entity.sizes,
        )).toList();
        return Right(products);
      } catch (cacheError) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override  
  Future<Either<Failure, List<Product>>> searchProducts(String keywords) async {
    await Future.delayed(const Duration(seconds: 3));
    final result = await getProducts(page: 1, limit: 10);
    return result.fold(
      (failure) => Left(failure),
      (allProducts) {
        final lowerKeyword = keywords.toLowerCase();
        final filtered = allProducts.where((product) {
          return product.name.toLowerCase().contains(lowerKeyword);
        }).toList();
        return Right(filtered);
      },
    );
  }
}