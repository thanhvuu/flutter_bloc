abstract class NetworkRepository {
  Future<bool> checkConnection();

  Stream<bool> get isConnectedStream;
}