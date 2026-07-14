// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'],
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: ProductModel._timestampToDateTime(json['createdAt']),
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sizes:
          (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'colors': instance.colors,
      'sizes': instance.sizes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
