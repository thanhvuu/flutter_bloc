import 'package:bloc_app_demo/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int page, required int limit});
  Future<List<ProductModel>> searchProducts(String keywords, {required int page, required int limit});
}