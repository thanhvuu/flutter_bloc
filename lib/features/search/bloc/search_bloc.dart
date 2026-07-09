import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_app_demo/domain/repositories/product_repository.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:equatable/equatable.dart';


part 'search_event.dart';
part 'search_state.dart';


EventTransformer<E> debounceAndRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounceTime(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitial()) {
    
    on<SearchKeywordChanged>(
      _onSearchKeywordChanged,
      transformer: debounceAndRestartable(const Duration(milliseconds: 300)),
    );

    
    on<ClearSearch>((event, emit) {
      emit(SearchInitial());
    });
  }

  Future<void> _onSearchKeywordChanged(
    SearchKeywordChanged event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword.trim();

    if (keyword.isEmpty) {
      return emit(SearchInitial());
    }

    emit(SearchLoading());
    final result = await repository.searchProducts(keyword);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (results) {
        if (results.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(results));
        }
      },
    );
  }
}