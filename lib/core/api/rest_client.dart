import 'package:dio/dio.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/products')
  Future<List<ProductModel>> getOnlineProducts(
      //   {
      //   @Path('serial') required String deviceSerial,
      //   @Query('SearchText') required String searchText,
      //   @Query('PaginationType') required int paginationType,
      //   @Query('Page') required int page,
      //   @Query('Amount') required int amount,
      //   @CancelRequest() CancelToken? cancelToken,
      // }
      );

  @POST('/orders')
  Future<void> createOrder(
    @Body() Map<String, dynamic> body
  );
}
