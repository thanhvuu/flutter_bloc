import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/entities/order.dart';
import 'package:bloc_app_demo/domain/repositories/order_repository.dart';
import 'package:bloc_app_demo/data/models/order_model.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:bloc_app_demo/core/api/rest_client.dart';

class OrderRepositoryImpl implements OrderRepository {
  final RestClient restClient;

  OrderRepositoryImpl({required this.restClient});

  @override  
  Future<Either<Failure,void>> createOrder(AppOrder order) async {
    try{
      final model = OrderModel(
        id: order.id,
        userId: order.userId,
        items: order.items.map((item) => {
          'id': item.id,
          'quantity': item.quantity,
          'product': ProductModel(
            id: item.product.id,
            name: item.product.name,
            description: item.product.description,
            price: item.product.price,
            category: item.product.category,
            imageUrl: item.product.imageUrl,
            createdAt: item.product.createdAt,
          ).toJson(),
        }).toList(),
        totalAmount: order.totalAmount,
        status: order.status,
        createdAt: order.createdAt,
      );

      await restClient.createOrder(model.toJson());
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override  
  Future<Either<Failure,List<AppOrder>>> getUserOrders(String userId) async {
    try{
      final models = await restClient.getOrders(userId);
      models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final orders = models.map((model) => model.toEntity()).toList();
      return Right(orders);
    } catch(e) {
      return const Left(ServerFailure());
    }
  }
}