import 'package:bloc_app_demo/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> createOrder(OrderModel model);
  Future<List<OrderModel>> getUserOrders(String userId);
}