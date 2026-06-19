import 'package:json_annotation/json_annotation.dart';
import 'package:bloc_app_demo/domain/entities/order.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:bloc_app_demo/data/models/product_model.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;

  @JsonKey(fromJson: _timestampToDateTime)
  final DateTime createdAt;


  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  static DateTime _timestampToDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    if (value is String) return DateTime.parse(value);
    try {
      return value.toDate();
    } catch (_) {
      return DateTime.now();
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  AppOrder toEntity() {
    return AppOrder(
      id:id.toString(),
      userId: userId,
      items: items.map((item) {
        return CartItem(
          id: item['id'] as String,
          product: ProductModel.fromJson(item['product'] as Map<String, dynamic>).toEntity(),
          quantity: item['quantity'] as int? ?? 1,
        );
      }).toList(),
      totalAmount: totalAmount,
      status: status,
      createdAt: createdAt,
    );
  }
  
}