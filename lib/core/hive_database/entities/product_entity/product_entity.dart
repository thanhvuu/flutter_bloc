import 'package:hive/hive.dart';
import 'package:bloc_app_demo/core/hive_database/entities/base_entity/base_entity.dart';

part 'product_entity.g.dart';

@HiveType(typeId: 0)

class ProductEntity extends BaseEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  
  final String imageUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String category;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.createdAt,
    required this.category,
  });

  
}
