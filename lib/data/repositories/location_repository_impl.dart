import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/repositories/location_repository.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/location_native_data_source.dart';

class LocationRepositoryImpl implements LocationRepository{
  final LocationNativeDataSource nativeDataSource;

  LocationRepositoryImpl({
    required this.nativeDataSource,
  });

  @override  
  Future<Either<Failure, String>> getUserLocation() async {
    try{
      final String? rawData = await nativeDataSource.getCurrentLocation();

      if (rawData == null || rawData.isEmpty){
        return const Left(ServerFailure('Lỗi hệ thống: Không lấy được vị trí'));
      }
        return Right(rawData);
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