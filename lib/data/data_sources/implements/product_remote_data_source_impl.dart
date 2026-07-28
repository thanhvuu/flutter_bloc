import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final RestClient restClient;

  ProductRemoteDataSourceImpl({required this.restClient});

  @override
  Future<List<ProductModel>> getProducts({required int page, required int limit}) async {
    return await restClient.getOnlineProducts(page: page, limit: limit);
  }

  @override
  Future<List<ProductModel>> searchProducts(String keywords, {required int page, required int limit}) async {
    return await restClient.searchOnlineProducts(keywords, page, limit);
  }
}