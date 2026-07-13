part of 'search_bloc.dart';

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
