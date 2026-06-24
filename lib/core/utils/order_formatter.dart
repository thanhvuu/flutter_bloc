import 'package:bloc_app_demo/domain/entities/order.dart';

extension AppOrderFormatting on AppOrder {
  String get displayId {
    return id.length > 8 ? id.substring(0,8).toUpperCase() : id.toUpperCase();
  }

  String get displayDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}