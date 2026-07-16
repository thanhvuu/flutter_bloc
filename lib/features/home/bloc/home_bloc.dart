import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/domain/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {  
  final ProductRepository _productRepository;  
  List<Product> _allProducts = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasReachedMax = false;

  HomeBloc(this._productRepository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      _currentPage = 1;
      _hasReachedMax = false;
      _allProducts.clear();
      final result = await _productRepository.getProducts(page: _currentPage, limit: _limit);
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (products) {
          _allProducts = products;
          _hasReachedMax = products.length < _limit;
          emit(HomeLoaded(products: List.from(_allProducts), selectedCategory: 'ALL', hasReachedMax: _hasReachedMax));
        },
      );
    });

    on<LoadMoreHomeDataEvent>((event,emit) async {
      final currentState = state;
      if(currentState is HomeLoaded && !_hasReachedMax) {
        _currentPage++;
        final result = await _productRepository.getProducts(page: _currentPage, limit: _limit);
        result.fold(
          (failure) => emit(HomeError(failure.message)),
          (newProducts) {
            if(newProducts.isEmpty) {
              _hasReachedMax = true;
            } else {
              _allProducts.addAll(newProducts);
              _hasReachedMax = newProducts.length < _limit;
            }
            emit(HomeLoaded(
              products: List.from(_allProducts),
              selectedCategory: currentState.selectedCategory,
              hasReachedMax: _hasReachedMax
            ));
          }
        );
      }
    });

    on<ChangeCategoryEvent>((event, emit) async {
      List<Product> filteredProducts;

      if (event.category == 'ALL') {
        filteredProducts = _allProducts;
      } else {
        filteredProducts = _allProducts.where((product) => product.category.toLowerCase() == event.category.toLowerCase()).toList();
      }

      emit(HomeLoaded(
        products: List.from(filteredProducts),
        selectedCategory: event.category,
        hasReachedMax: _hasReachedMax
      ));
    });
  }
}