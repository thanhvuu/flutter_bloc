import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/core/errors/exception.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:dio/dio.dart';

class ProductRemoteDataSource {
  final RestClient restClient;

  ProductRemoteDataSource({required this.restClient});

  Future<List<ProductModel>> getProducts() async {
    try{
    final dtoList = await restClient.getOnlineProducts();
    return dtoList; 
    }on DioException {
      throw ServerException();
    } catch(e) {
      throw ServerException ();
    }
  }
}