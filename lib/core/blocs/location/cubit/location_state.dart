part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

final class LocationInitial extends LocationState {}
final class LocationLoading extends LocationState {}
final class LocationSuccess extends LocationState {
  final String address;
  
  const LocationSuccess(this.address);
  
  @override
  List<Object?> get props => [address];
}

final class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override  
  List<Object?> get props => [message];
}
