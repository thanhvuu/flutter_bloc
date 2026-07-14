import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final DateTime createdAt;
  final String category;
  final List<String> colors;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.createdAt,
    required this.category,
    required this.colors,
    required this.sizes,
  });

  @override  
  List<Object?> get props => [id, name, description, price, imageUrl, createdAt,category,colors, sizes];
}