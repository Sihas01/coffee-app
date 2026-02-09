import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStream async* {
    yield await _checkConnection();
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }

  Future<bool> _checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
