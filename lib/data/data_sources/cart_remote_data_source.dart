import 'package:bloc_app_demo/core/api/rest_client.dart';

class CartRemoteDataSource {
  final RestClient restClient;

  CartRemoteDataSource({required this.restClient});

  Future<void> postOrder(List<Map<String,dynamic>> orderItems, double totalAmount) async {
    final body = {
      "items": orderItems,
      "total": totalAmount,
      "createdAt": DateTime.now().toIso8601String()
    };
    await restClient.createOrder(body);
  }
}