part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProductsDetail extends ProductDetailEvent {
  final Product product;

  const LoadProductsDetail(this.product);

  @override  
  List<Object?> get props => [product];
}

final class SelectColor extends ProductDetailEvent {
  final int colorIndex;
  const SelectColor(this.colorIndex);

  @override  
  List<Object?> get props => [colorIndex];
}

final class SelectSize extends ProductDetailEvent {
  final int sizeIndex;

  const SelectSize(this.sizeIndex);

  @override  
  List<Object?> get props => [sizeIndex];
}
