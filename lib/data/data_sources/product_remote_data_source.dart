import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';

class ProductRemoteDataSource {
  final RestClient restClient;

  ProductRemoteDataSource({required this.restClient});

  Future<List<ProductModel>> getProducts() async {
    
    final dtoList = await restClient.getOnlineProducts();
    return dtoList; 
  }
}