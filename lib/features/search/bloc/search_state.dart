part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchEmpty extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<Product> results;
  final String selectedCategory;

  const SearchLoaded(this.results, {this.selectedCategory = 'ALL'});

  @override  
  List<Object?> get props => [results, selectedCategory];

}

final class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override  
  List<Object?> get props => [message];
}

