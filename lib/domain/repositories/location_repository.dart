import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';

abstract class LocationRepository {
  Future<Either<Failure, String>> getUserLocation();
}