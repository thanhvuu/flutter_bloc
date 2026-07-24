import 'package:dio/dio.dart';
import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/core/errors/exception.dart';
import 'package:bloc_app_demo/data/models/order_model.dart';

class OrderRemoteDataSource {
  final RestClient restClient;

  OrderRemoteDataSource({required this.restClient});

  Future<void> createOrder(OrderModel model) async {
    try {
      await restClient.createOrder(model.toJson());
    } on DioException catch (e) {
      throw ServerException('Lỗi API Tạo đơn hàng: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi hệ thống không xác định: $e');
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      return await restClient.getOrders(userId);
    } on DioException catch (e) {
      throw ServerException('Lỗi API Lấy đơn hàng: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi hệ thống không xác định: $e');
    }
  }
}