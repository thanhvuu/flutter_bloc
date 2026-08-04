part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  final String selectedCategory;
  final double minPrice;
  final double maxPrice;
  final ProductSortOption sortOption;
  const SearchState({
    this.selectedCategory = 'ALL',
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.sortOption = ProductSortOption.none,                   
  });
  
  @override
  List<Object?> get props => [selectedCategory, minPrice, maxPrice,sortOption];
}

final class SearchInitial extends SearchState {
  const SearchInitial() : super(
    selectedCategory: 'ALL',
    minPrice: 0,
    maxPrice: 1000,
    sortOption: ProductSortOption.none,
    );
}

final class SearchLoading extends SearchState {
  const SearchLoading({super.selectedCategory = 'ALL'});
}

final class SearchEmpty extends SearchState {
  const SearchEmpty({
    super.selectedCategory = 'ALL',
    super.minPrice = 0,
    super.maxPrice = 1000,
    super.sortOption = ProductSortOption.none,
  });
}

final class SearchLoaded extends SearchState {
  final List<Product> results;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const SearchLoaded(this.results, {super.selectedCategory = 'ALL',this.hasReachedMax=false, this.isFetchingMore= false, super.minPrice = 0, super.maxPrice = 1000,super.sortOption = ProductSortOption.none,});

  @override  
  List<Object?> get props => [results, selectedCategory, hasReachedMax, isFetchingMore, minPrice, maxPrice, sortOption];

}

final class SearchError extends SearchState {
  final String message;

  const SearchError(this.message,{super.selectedCategory = 'ALL'});

  @override  
  List<Object?> get props => [message, selectedCategory];
}

