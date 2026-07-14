part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final List<Color> colors;           // Danh sách Color đã parse từ hex
  final List<String> sizes;           // Danh sách size
  final List<bool> sizeAvailability;  // Trạng thái còn hàng của từng size
  final int selectedColorIndex;
  final int selectedSizeIndex;

  const ProductDetailLoaded({
    required this.product,
    required this.colors,
    required this.sizes,
    required this.sizeAvailability,
    this.selectedColorIndex = 0,
    this.selectedSizeIndex = 0,
  });

  /// Getter tiện ích lấy size/color đang chọn
  String get selectedSize => sizes.isNotEmpty ? sizes[selectedSizeIndex] : '';
  Color get selectedColor => colors.isNotEmpty ? colors[selectedColorIndex] : const Color(0xFF000000);

  /// copyWith để BLoC emit state mới khi chỉ đổi 1 thuộc tính
  ProductDetailLoaded copyWith({
    int? selectedColorIndex,
    int? selectedSizeIndex,
  }) {
    return ProductDetailLoaded(
      product: product,
      colors: colors,
      sizes: sizes,
      sizeAvailability: sizeAvailability,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
    );
  }

  @override
  List<Object?> get props => [
        product,
        colors,
        sizes,
        sizeAvailability,
        selectedColorIndex,
        selectedSizeIndex,
      ];
}