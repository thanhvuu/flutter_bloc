part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState ();

  @override
  List<Object?> get props => [];
}
final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Product> products; 
  const HomeLoaded(this.products);

  @override  
  List<Object?> get props => [products];
}

final class HomeError extends HomeState {
  final String errorMessage;
  const HomeError(this.errorMessage);

  @override 
  List<Object?> get props => [errorMessage];
}