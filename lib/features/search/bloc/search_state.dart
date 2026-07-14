part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  final String selectedCategory;
  const SearchState({this.selectedCategory = 'ALL'});
  
  @override
  List<Object?> get props => [selectedCategory];
}

final class SearchInitial extends SearchState {
  const SearchInitial() : super(selectedCategory: 'ALL');
}

final class SearchLoading extends SearchState {
  const SearchLoading({super.selectedCategory = 'ALL'});
}

final class SearchEmpty extends SearchState {
  const SearchEmpty({super.selectedCategory = 'ALL'});
}

final class SearchLoaded extends SearchState {
  final List<Product> results;

  const SearchLoaded(this.results, {super.selectedCategory = 'ALL'});

  @override  
  List<Object?> get props => [results, selectedCategory];

}

final class SearchError extends SearchState {
  final String message;

  const SearchError(this.message,{super.selectedCategory = 'ALL'});

  @override  
  List<Object?> get props => [message, selectedCategory];
}

