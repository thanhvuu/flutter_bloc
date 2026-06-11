import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:bloc_app_demo/domain/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {  
  final ProductRepository _productRepository;  

  HomeBloc(this._productRepository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final products = await _productRepository.getProducts();
        emit(HomeLoaded(products));
      } catch (e) {
        emit(const HomeError('Lỗi khi tải dữ liệu'));
      }
    });
  }
}