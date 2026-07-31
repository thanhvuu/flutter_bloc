import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:isolate';
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

class _FilterParam{
  final List<Product> products;
  final String category;
  final String keyword;

  _FilterParam({
    required this.products,
    required this.category,
    required this.keyword,
  });
}

 List<Product> _filterProductsTask(_FilterParam param) {
  List<Product> temp = List.from(param.products);

  if(param.category != 'ALL') {
    final lowerCategory = param.category.toLowerCase();
    temp = temp.where((p) => p.category.toLowerCase() == lowerCategory).toList();
  }
  if(param.keyword.isNotEmpty) {
    final lowerKeyword = param.keyword.toLowerCase();
    temp = temp.where((p) => p.name.toLowerCase().contains(lowerKeyword)).toList();
  }
  return temp;
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository repository;
  List<Product> _allProducts = []; 
  String _currentCategory = 'ALL';
  String _currentKeyword= '' ;

  SearchBloc({required this.repository}) : super(const SearchInitial()) {
  
  on<LoadProductsEvent>((event, emit) async {
    _currentCategory = event.category ?? 'ALL';
    emit(SearchLoading(selectedCategory: _currentCategory)); 
    
    if (_allProducts.isEmpty) {
      final result = await repository.getProducts(page: 1, limit: 100);
      
      
      await result.fold(
        (failure) async {
          if (!emit.isDone) emit(SearchError(failure.message, selectedCategory: _currentCategory));
        },
        (products) async {
          _allProducts = products;
          await _emitFilteredProducts(emit);
        },
      );
    } else {
      await _emitFilteredProducts(emit);
    }
  });

  on<SearchKeywordChanged>((event, emit) async {
    _currentKeyword = event.keyword.trim();
    emit(SearchLoading(selectedCategory: _currentCategory)); 

    await _emitFilteredProducts(emit);
  }, transformer: debounceAndRestartable(const Duration(milliseconds: 300)));

  on<ClearSearch>((event, emit) async {
    _currentKeyword = '';
    await _emitFilteredProducts(emit);
  });
}

  
  Future<void> _emitFilteredProducts(Emitter<SearchState> emit) async {
  final products = _allProducts;
  final category = _currentCategory;
  final keyword = _currentKeyword;

  final temp = await Isolate.run(
    () => _filterProductsTask(
      _FilterParam(
        products: products,
        category: category,
        keyword: keyword,
      ),
    ),
  );

  if (emit.isDone) return;
  if (temp.isEmpty) {
    emit(SearchEmpty(selectedCategory: _currentCategory)); 
  } else {
    emit(SearchLoaded(temp, selectedCategory: _currentCategory)); 
  }
}
}