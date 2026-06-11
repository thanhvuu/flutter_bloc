import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:bloc_app_demo/core/hive_database/entities/base_entity/base_entity.dart';
import 'package:bloc_app_demo/core/hive_database/hive_constants.dart';




abstract class BaseDao<T extends BaseEntity> {
  @protected late Box<T> box;
  BaseDao() {
    box = Hive.box<T>(HiveBoxMap.hiveBoxMap[T]!.boxName);
  }

  Future<void> insert(T entity) async {
    try {
      await box.put(entity.id, entity);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> insertAll(List<T> entities) async {
    try {
      Map<dynamic, T> data =
          { for (var e in entities) e.id : e };
      await box.putAll(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  T? findById(String? id) {
    if(id == null) {
      return null;
    }
    return box.get(id);
  }

  List<T> getAll() {
    return box.values.toList();
  }
  

  Future<void> update(String id, T entity) async {
    if (box.containsKey(id)) {
      await box.put(id, entity);
    }
  }

  Future<void> updateAll(List<T> entities) async {
    Map<dynamic, T> data =
        { for (var e in entities) e.id : e };
    await box.putAll(data);
  }


  Future<void> delete(String? id) async {
    if (box.containsKey(id)) {
      await box.delete(id);
    }
  }

  Future<void> deleteAll(List<String> ids) async {
    await box.deleteAll(ids);
  }

  Future<int> clear() async {
    return await box.clear();
  }
}