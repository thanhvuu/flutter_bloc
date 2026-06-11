import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity extends HiveObject {
  @HiveField(0)
  late String id;

  BaseEntity({
    String? id,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}