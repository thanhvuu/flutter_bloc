import 'package:hive/hive.dart';
import 'package:bloc_app_demo/core/hive_database/entities/base_entity/base_entity.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';

part 'cart_item_entity.g.dart';

@HiveType(typeId: 1)
class CartItemEntity extends BaseEntity {
 

  @HiveField(1)
  final ProductEntity product;

  @HiveField(2)
  final int quantity;

  CartItemEntity({
    required String id,
    required this.product,
    required this.quantity,
  }) : super(id: id);
}