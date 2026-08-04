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
  final double minPrice;
  final double maxPrice;
  final ProductSortOption sortOption;

  _FilterParam({
    required this.products,
    required this.category,
    required this.keyword,
    required this.minPrice,
    required this.maxPrice,
    required this.sortOption,
  });
}


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository repository;
  List<Product> _allProducts = []; 
  String _currentCategory = 'ALL';
  String _currentKeyword= '' ;
  int _currentPage = 1;
  final int  _pageLimit = 20;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;
  double _minPrice = 0;
  double _maxPrice = 1000;
  ProductSortOption _sortOption = ProductSortOption.none;

  SearchBloc({required this.repository}) : super(const SearchInitial()) {
  
  on<LoadProductsEvent>((event, emit) async {
    _currentCategory = event.category ?? 'ALL';
    _currentPage = 1;
    _hasReachedMax = false;
    _allProducts.clear();

    emit(SearchLoading(selectedCategory: _currentCategory)); 
    
    if (_allProducts.isEmpty) {
      final result = await repository.getProducts(page: _currentPage, limit: _pageLimit);
      
      
      await result.fold(
        (failure) async {
          if (!emit.isDone) emit(SearchError(failure.message, selectedCategory: _currentCategory));
        },
        (products) async {
          _allProducts = products;
          if(products.length < _pageLimit) {
            _hasReachedMax = true;
          }
          await _emitFilteredProducts(emit);
        },
      );
    } else {
      await _emitFilteredProducts(emit);
    }
  });

  on<LoadMoreProductsEvent>((event,emit) async {
    if(_hasReachedMax || _isFetchingMore) return;

    _isFetchingMore = true;

    if (state is SearchLoaded){
      final currentLoaded = state as SearchLoaded;
      emit(SearchLoaded(
        currentLoaded.results,
        selectedCategory: _currentCategory,
        hasReachedMax: _hasReachedMax,
        isFetchingMore: true,
      ));
    }

    _currentPage ++;
    final result = await repository.getProducts(page: _currentPage, limit: _pageLimit);

    await result.fold(
      (failure) async{
        _isFetchingMore = false;
      },
      (newProducts) async {
        _isFetchingMore = false;
        if( newProducts.isEmpty || newProducts.length < _pageLimit) {
          _hasReachedMax = true;
        }
        _allProducts.addAll(newProducts);
        await _emitFilteredProducts(emit);
      }
    );
  });

  on<SearchKeywordChanged>((event, emit) async {
    _currentKeyword = event.keyword.trim();
    emit(SearchLoading(selectedCategory: _currentCategory)); 

    await _emitFilteredProducts(emit);
  }, transformer: debounceAndRestartable(const Duration(milliseconds: 300)));

  on<FilterPriceChanged>((event, emit) async {
    _minPrice = event.minPrice;
    _maxPrice = event.maxPrice;
    await _emitFilteredProducts(emit);
  });

  on<SortOptionChanged>((event, emit) async {
    _sortOption = event.sortOption;
    await _emitFilteredProducts(emit);
  });

  on<ClearSearch>((event, emit) async {
    _currentKeyword = '';
    await _emitFilteredProducts(emit);
  });
}

static List<Product> _filterProductsTask(_FilterParam param) {
  List<Product> temp = List.from(param.products);

  if(param.category != 'ALL') {
    final lowerCategory = param.category.toLowerCase();
    temp = temp.where((p) => p.category.toLowerCase() == lowerCategory).toList();
  }
  if(param.keyword.isNotEmpty) {
    final lowerKeyword = param.keyword.toLowerCase();
    temp = temp.where((p) => p.name.toLowerCase().contains(lowerKeyword)).toList();
  }
  temp = temp.where((p) => p.price >= param.minPrice && p.price <= param.maxPrice).toList();
  if(param.sortOption == ProductSortOption.priceLowToHigh){
    temp.sort((a,b) => a.price.compareTo(b.price));
  } else if (param.sortOption == ProductSortOption.priceHighToLow){
    temp.sort((a,b) => b.price.compareTo(a.price));
  }
  return temp;
}


  
  Future<void> _emitFilteredProducts(Emitter<SearchState> emit) async {
  final products = _allProducts;
  final category = _currentCategory;
  final keyword = _currentKeyword;
  final minPrice = _minPrice;
  final maxPrice = _maxPrice;
  final sortOption = _sortOption;


  final temp = await Isolate.run(
    () => _filterProductsTask(
      _FilterParam(
        products: products,
        category: category,
        keyword: keyword,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortOption: sortOption,
      ),
    ),
  );

  if (emit.isDone) return;
  if (temp.isEmpty) {
    emit(SearchEmpty( selectedCategory: _currentCategory, minPrice: _minPrice, maxPrice: _maxPrice, sortOption: _sortOption)); 
  } else {
    emit(SearchLoaded(temp, selectedCategory: _currentCategory, minPrice: _minPrice, maxPrice: _maxPrice, sortOption: _sortOption)); 
  }
}
}