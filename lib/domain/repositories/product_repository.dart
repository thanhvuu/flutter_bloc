import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';


abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({required int page, required int limit});
  Future<Either<Failure, List<Product>>> searchProducts(String keywords);
}