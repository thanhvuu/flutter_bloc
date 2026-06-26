import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/repositories/network_repository.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkRepository networkRepository;
  StreamSubscription<bool>? _subscription;

  NetworkBloc({required this.networkRepository}) : super(NetworkInitial()) {
    
    on<NetworkObserve>((event, emit) async {
      final bool isConnected = await networkRepository.checkConnection();
      add(NetworkNotify(isConnected: isConnected));

      _subscription = networkRepository.isConnectedStream.listen((bool isConnected) {
        add(NetworkNotify(isConnected: isConnected));
      });
    }); 

    on<NetworkNotify>((event, emit) {
      if (event.isConnected) {
        emit(NetworkSuccess());
      } else {
        emit(NetworkFailure());
      }
    });

     on<NetworkRetry>((event, emit) async {
      
      final bool isConnected = await networkRepository.checkConnection();
      
      
      if (isConnected) {
        emit(NetworkSuccess());
      } else {
        emit(NetworkFailure());
      }
    });
  }
    
  

  @override  
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}