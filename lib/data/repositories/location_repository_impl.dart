import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/repositories/location_repository.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/location_native_data_source.dart';
import 'package:bloc_app_demo/domain/entities/location_point.dart';

class LocationRepositoryImpl implements LocationRepository{
  final LocationNativeDataSource nativeDataSource;

  LocationRepositoryImpl({
    required this.nativeDataSource,
  });

  @override  
  Future<Either<Failure, LocationPoint>> getUserLocation() async {
    try{
      final String? rawData = await nativeDataSource.getCurrentLocation();

      if (rawData == null || rawData.isEmpty){
        return const Left(ServerFailure('Lỗi hệ thống: Không lấy được vị trí'));
      }

      final parts = rawData.split(',');
      if(parts.length ==2){
        final lat = double.tryParse(parts[0]) ?? 0.0;
        final lng = double.tryParse(parts[1]) ?? 0.0;
        return Right(LocationPoint(latitude: lat,longtitude: lng));
      }

      return const Left(ServerFailure('Lỗi GPS không hợp lệ'));
    } on PlatformException catch (e){
      if(e.code == 'PERMISSION_DENIED') {
        return Left(ServerFailure(e.message ?? 'Bạn chưa cấp quyền vị trí'));
      } else if (e.code == 'UNAVAILABLE') {
        return Left(ServerFailure(e.message ?? 'Tín hiệu GPS đang tắt'));
      }

      return const Left(ServerFailure('Lỗi không xác định'));
    } catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }
}