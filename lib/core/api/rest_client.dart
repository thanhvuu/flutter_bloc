import 'package:dio/dio.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:bloc_app_demo/data/models/order_model.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/products')
  Future<List<ProductModel>> getOnlineProducts(
         {
      //   @Path('serial') required String deviceSerial,
      //   @Query('SearchText') required String searchText,
      //   @Query('PaginationType') required int paginationType,
          @Query('page') required  int page,
          @Query('limit') required int limit,
      //   @CancelRequest() CancelToken? cancelToken,
       }
      );

  @GET('/products')
  Future<List<ProductModel>> searchOnlineProducts(
    @Query('search') String keyword,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @POST('/orders')
  Future<void> createOrder(
    @Body() Map<String, dynamic> body
  );

  @GET('/orders')
  Future<List<OrderModel>> getOrders(
    @Query('userId') String userId
  );
}
