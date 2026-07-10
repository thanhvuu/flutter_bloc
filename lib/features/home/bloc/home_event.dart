part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override  
  List<Object?> get props => [];
}

final class LoadHomeDataEvent extends HomeEvent {}

final class LoadMoreHomeDataEvent extends HomeEvent{}

final class ChangeCategoryEvent extends HomeEvent {
  final String category;

  const ChangeCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
