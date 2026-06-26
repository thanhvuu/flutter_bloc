part of 'network_bloc.dart';

sealed class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

final class NetworkObserve extends NetworkEvent{}

final class NetworkNotify extends NetworkEvent{
  final bool isConnected;

  const NetworkNotify({this.isConnected = false});

  @override  
  List<Object?> get props => [isConnected];
}

final class NetworkRetry extends NetworkEvent{}


