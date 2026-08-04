part of 'search_bloc.dart';

enum ProductSortOption {none, priceLowToHigh, priceHighToLow}

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class SearchKeywordChanged extends SearchEvent {
  final String keyword;

  const SearchKeywordChanged(this.keyword);

  @override  
  List<Object?> get props => [keyword];
}

final class ClearSearch extends SearchEvent{}

final class LoadProductsEvent extends SearchEvent{
  final String? category;

  const LoadProductsEvent({this.category});

  @override  
  List<Object?> get props => [category];
}

final class LoadMoreProductsEvent extends SearchEvent {}

final class FilterPriceChanged extends SearchEvent{
  final double minPrice;
  final double maxPrice;

  const FilterPriceChanged({required this.minPrice, required this.maxPrice});

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

final class SortOptionChanged extends SearchEvent {
  final ProductSortOption sortOption;

  const SortOptionChanged(this.sortOption);

  @override   
  List<Object?> get props => [sortOption];
}
