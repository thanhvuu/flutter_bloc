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
  List<Product> _allProducts = []; // Bộ nhớ cache lưu sản phẩm gốc
  String _currentCategory = 'ALL';
  String _currentKeyword = '';

  SearchBloc({required this.repository}) : super( const SearchInitial()) {
    
    // 1. Xử lý tải dữ liệu theo danh mục
    on<LoadProductsEvent>((event, emit) async {
      _currentCategory = event.category ?? 'ALL';
      emit(SearchLoading(selectedCategory: _currentCategory)); // Truyền danh mục vào Loading
      
      if (_allProducts.isEmpty) {
        final result = await repository.getProducts(page: 1, limit: 100);
        result.fold(
          (failure) => emit(SearchError(failure.message, selectedCategory: _currentCategory)),
          (products) {
            _allProducts = products;
            _emitFilteredProducts(emit);
          },
        );
      } else {
        _emitFilteredProducts(emit);
      }
    });

    // 2. Xử lý khi người dùng gõ tìm kiếm
    on<SearchKeywordChanged>((event, emit) async {
      _currentKeyword = event.keyword.trim();
      emit(SearchLoading(selectedCategory: _currentCategory)); // Truyền danh mục vào Loading
      
      await Future.delayed(const Duration(milliseconds: 300));
      _emitFilteredProducts(emit);
    }, transformer: debounceAndRestartable(const Duration(milliseconds: 300)));

    // 3. Xử lý khi xóa trắng ô tìm kiếm
    on<ClearSearch>((event, emit) {
      _currentKeyword = '';
      _emitFilteredProducts(emit);
    });
  }

  // Hàm helper tính toán lọc sản phẩm theo cả danh mục + từ khóa
  void _emitFilteredProducts(Emitter<SearchState> emit) {
    List<Product> temp = List.from(_allProducts);
    
    // Lọc theo Danh mục
    if (_currentCategory != 'ALL') {
      temp = temp.where((p) => p.category.toLowerCase() == _currentCategory.toLowerCase()).toList();
    }
    
    // Lọc theo Từ khóa
    if (_currentKeyword.isNotEmpty) {
      final lower = _currentKeyword.toLowerCase();
      temp = temp.where((p) => p.name.toLowerCase().contains(lower)).toList();
    }

    if (temp.isEmpty) {
      emit(SearchEmpty(selectedCategory: _currentCategory)); // Truyền danh mục vào Empty
    } else {
      emit(SearchLoaded(temp, selectedCategory: _currentCategory)); // Truyền danh mục vào Loaded
    }
  }
}