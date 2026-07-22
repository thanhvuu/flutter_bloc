import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'stripe_client.g.dart';

@RestApi()
abstract class StripeClient {
  factory StripeClient(Dio dio, {String? baseUrl}) = _StripeClient;

  @POST('/payment_intents')
  @FormUrlEncoded()
  Future<HttpResponse> createPaymentIntent(
    @Header('Authorization') String authHeader,
    @Field('amount') String amount,
    @Field('currency') String currency,
    @Field('payment_method_types[]') String paymentMethodType,
  );
}