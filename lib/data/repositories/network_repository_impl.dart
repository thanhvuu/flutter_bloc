import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bloc_app_demo/domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final Connectivity _connectivity;

  NetworkRepositoryImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

      @override  
      Future<bool> checkConnection() async {
        final result = await _connectivity.checkConnectivity();
        return result != ConnectivityResult.none;
      }

      @override  
      Stream<bool> get isConnectedStream {
        return _connectivity.onConnectivityChanged.map((result) {
          return result != ConnectivityResult.none;
        });
      }
}