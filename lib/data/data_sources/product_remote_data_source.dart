import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/core/errors/exception.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:dio/dio.dart';

class ProductRemoteDataSource {
  final RestClient restClient;

  ProductRemoteDataSource({required this.restClient});

  Future<List<ProductModel>> getProducts({required int page, required int limit}) async {
    try{
    final dtoList = await restClient.getOnlineProducts(page: page, limit: limit);
    return dtoList; 
    }on DioException catch (e) {
      throw ServerException('Lỗi API: ${e.message}');
    } catch(e) {
      throw ServerException ('Lỗi hệ thống không xác định: $e');
    }
  }
}