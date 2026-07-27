import 'package:flutter/services.dart';
import 'package:bloc_app_demo/data/data_sources/interfaces/location_native_data_source.dart';

class LocationNativeDataSourceImpl implements LocationNativeDataSource{
  static const MethodChannel _channel = MethodChannel('com.eliteathlete/location');

  @override  
  Future<String?> getCurrentLocation() async {
    final String? result = await _channel.invokeMethod('getCurrentLocation');
    return result;
  }
}