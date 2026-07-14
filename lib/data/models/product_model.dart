import 'package:json_annotation/json_annotation.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final dynamic id;
  final String name;
  final String description;
  final dynamic price;
  final String? category;
  final String? imageUrl;
  final List<String>? colors;
  final List<String>? sizes;
  
  @JsonKey(fromJson: _timestampToDateTime)
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.category,
    this.imageUrl,
    this.createdAt,
    this.colors,
    this.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  static DateTime? _timestampToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  // Chuyển từ Model (API) → Entity thuần (BLoC dùng)
  Product toEntity() {
    return Product(
      id: id.toString(),
      name: name,
      description: description,
      price: (price is num) ? (price as num).toDouble() : 0.0,
      category: category ?? 'Unknown',
      imageUrl: imageUrl ?? '',
      createdAt: createdAt ?? DateTime.now(),
      colors: colors ?? [],
      sizes: sizes ?? [],
    );
  }
}