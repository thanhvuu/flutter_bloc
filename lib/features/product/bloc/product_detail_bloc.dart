import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<LoadProductsDetail>(_onLoadProductDetail);
    on<SelectColor>(_onSelectColor);
    on<SelectSize>(_onSelectSize);
  }

  

  static Color _parseHexColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Mặc định: màu sắc dự phòng khi API trả về rỗng
  static const List<Color> _defaultColors = [
    Colors.black,
    Color(0xFFC00010),
    Colors.white,
  ];

  /// Mặc định: size dự phòng khi API trả về rỗng
  static const List<String> _defaultSizes = [
    'US 7', 'US 8', 'US 9', 'US 10', 'US 11', 'US 12', 'US 13',
  ];

  /// Tạo danh sách trạng thái còn hàng (size cuối luôn hết hàng để demo)
  static List<bool> _buildSizeAvailability(List<String> sizes) {
    return List.generate(
      sizes.length,
      (index) => index < sizes.length - 1,
    );
  }

  void _onLoadProductDetail(LoadProductsDetail event, Emitter<ProductDetailState> emit) {
    final product = event.product;

    // Parse colors từ Product entity
    final colors = product.colors.isEmpty
        ? _defaultColors
        : product.colors.map((hex) => _parseHexColor(hex)).toList();

    // Parse sizes từ Product entity
    final sizes = product.sizes.isEmpty ? _defaultSizes : product.sizes;

    // Tạo trạng thái availability
    final sizeAvailability = _buildSizeAvailability(sizes);

    emit(ProductDetailLoaded(
      product: product,
      colors: colors,
      sizes: sizes,
      sizeAvailability: sizeAvailability,
    ));
  }

  void _onSelectColor(SelectColor event, Emitter<ProductDetailState> emit) {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(currentState.copyWith(selectedColorIndex: event.colorIndex));
    }
  }

  void _onSelectSize(SelectSize event, Emitter<ProductDetailState> emit) {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(currentState.copyWith(selectedSizeIndex: event.sizeIndex));
    }
  }
}