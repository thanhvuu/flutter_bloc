import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:bloc_app_demo/core/api/stripe_client.dart';
import 'package:bloc_app_demo/core/api/rest_client.dart';
import 'package:bloc_app_demo/core/constants/api_constants.dart';
import 'package:bloc_app_demo/core/hive_database/hive_database.dart';
import 'package:bloc_app_demo/core/hive_database/daos/cart_dao.dart';
import 'package:bloc_app_demo/data/data_sources/cart_local_data_source.dart';
import 'package:bloc_app_demo/data/data_sources/cart_remote_data_source.dart';
import 'package:bloc_app_demo/core/hive_database/daos/product_dao.dart';
import 'package:bloc_app_demo/data/data_sources/product_remote_data_source.dart';
import 'package:bloc_app_demo/data/data_sources/product_local_data_source.dart';
import 'package:bloc_app_demo/data/repositories/product_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/auth_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/order_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/cart_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/network_repository_impl.dart';
import 'package:bloc_app_demo/data/repositories/payment_repository_impl.dart';

class Injection {
  late final ProductRepositoryImpl productRepository;
  late final CartRepositoryImpl cartRepository;
  late final AuthRepositoryImpl authRepository;
  late final OrderRepositoryImpl orderRepository;
  late final NetworkRepositoryImpl networkRepository;
  late final PaymentRepositoryImpl paymentRepository;

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
    final cartRemoteDataSource = CartRemoteDataSource(restClient: restClient);
    final remoteDataSource = ProductRemoteDataSource(restClient: restClient);
    final localDataSource = ProductLocalDataSource(productDao: ProductDao());
    final cartLocalDataSource = CartLocalDataSource(cartDao: CartDao());

    // Repository
    productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    cartRepository = CartRepositoryImpl(
      localDataSource: cartLocalDataSource,
      remoteDataSource: cartRemoteDataSource,
    );
    authRepository = AuthRepositoryImpl();
    orderRepository = OrderRepositoryImpl(restClient: restClient);
    networkRepository = NetworkRepositoryImpl();
    paymentRepository = PaymentRepositoryImpl(stripeClient: stripeClient);
  }
}