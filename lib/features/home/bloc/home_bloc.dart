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

  HomeBloc(this._productRepository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await _productRepository.getProducts();
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (products) {
          _allProducts = products;
          emit(HomeLoaded(products: _allProducts, selectedCategory: 'ALL'));
        },
      );
    });

    on<ChangeCategoryEvent>((event, emit) async {
      List<Product> filteredProducts;

      if (event.category == 'ALL') {
        filteredProducts = _allProducts;
      } else {
        filteredProducts = _allProducts.where((product) => product.category.toLowerCase() == event.category.toLowerCase()).toList();
      }

      emit(HomeLoaded(
        products: filteredProducts,
        selectedCategory: event.category,
      ));
    });
  }
}