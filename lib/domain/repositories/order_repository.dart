import 'package:bloc_app_demo/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<AppOrder>> getUserOrders(String userId);

  Future<void> createOrder(AppOrder order);
}