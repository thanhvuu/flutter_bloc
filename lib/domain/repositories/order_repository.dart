import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/entities/order.dart';


abstract class OrderRepository {
  Future<Either<Failure,List<AppOrder>>> getUserOrders(String userId);

  Future<Either<Failure,void>> createOrder(AppOrder order);
}