import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/entities/location_point.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationPoint>> getUserLocation();
}