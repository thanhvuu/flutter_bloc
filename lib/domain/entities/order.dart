import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';

class AppOrder extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const AppOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id,userId, items, totalAmount,status, createdAt];
}