import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:bloc_app_demo/core/api/stripe_client.dart';
import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/core/constants/api_constants.dart';
import 'package:bloc_app_demo/core/hive_database/hive_database.dart';
import 'package:bloc_app_demo/core/hive_database/daos/cart_dao.dart';
import 'package:bloc_app_demo/core/hive_database/daos/product_dao.dart';
import 'package:bloc_app_demo/data/data_sources/implements/location_native_data_source_impl.dart';
import 'package:bloc_app_demo/data/repositories/product_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/auth_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/order_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/cart_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/network_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/payment_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/location_repository_impl.dart';
import 'package:bloc_app_demo/data/data_sources/implements/product_remote_data_source_impl.dart';
import 'package:bloc_app_demo/data/data_sources/implements/product_local_data_source_impl.dart';
import 'package:bloc_app_demo/data/data_sources/implements/cart_local_data_source_impl.dart';
import 'package:bloc_app_demo/data/data_sources/implements/order_remote_data_source_impl.dart';

class Injection {
  late final ProductRepositoryImpl productRepository;
  late final CartRepositoryImpl cartRepository;
  late final AuthRepositoryImpl authRepository;
  late final OrderRepositoryImpl orderRepository;
  late final NetworkRepositoryImpl networkRepository;
  late final PaymentRepositoryImpl paymentRepository;
  late final LocationRepositoryImpl locationRepository;

  Future<void> init() async {
    // Hive
    final hiveDatabase = HiveDatabase();
    await hiveDatabase.init();

    // API
    final dio = Dio();
    dio.options = BaseOptions(
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
    );
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => developer.log('⚡ [API] $object'),
    ));
    final restClient = RestClient(dio, baseUrl: ApiConstants.baseUrl);
    final stripeClient = StripeClient(dio, baseUrl: ApiStripe.baseUrl);

    // Data Sources
    final remoteDataSource = ProductRemoteDataSourceImpl(restClient: restClient);
    final localDataSource = ProductLocalDataSourceImpl(productDao: ProductDao());
    final cartLocalDataSource = CartLocalDataSourceImpl(cartDao: CartDao());
    final orderRemoteDataSource = OrderRemoteDataSourceImpl(restClient: restClient);
    final locationNativeDataSource = LocationNativeDataSourceImpl();

    // Repository
    productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    cartRepository = CartRepositoryImpl(
      localDataSource: cartLocalDataSource,
    );
    authRepository = AuthRepositoryImpl();
    networkRepository = NetworkRepositoryImpl();
    paymentRepository = PaymentRepositoryImpl(stripeClient: stripeClient);
    orderRepository =
        OrderRepositoryImpl(remoteDataSource: orderRemoteDataSource);
    locationRepository =
        LocationRepositoryImpl(nativeDataSource: locationNativeDataSource);
  }
}
