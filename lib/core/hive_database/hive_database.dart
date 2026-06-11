import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc_app_demo/core/hive_database/entities/base_entity/base_entity.dart';
import 'package:bloc_app_demo/core/hive_database/hive_constants.dart';

class HiveDatabase {
  HiveDatabase();

   Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appFolder = await getApplicationSupportDirectory();
      Hive.init(appFolder.path);
    }
    
    _registerAdapters();
    await _initBoxes();
  }
  
  Box<T> getMyBox<T extends BaseEntity>() {
    return Hive.box<T>(HiveBoxMap.hiveBoxMap[T]!.boxName);
  }

  Future<void> _initBoxes() async {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      await HiveBoxMap.hiveBoxMap[key]!.openBoxFunction();
    }
  }

  void _registerAdapters() {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      HiveBoxMap.hiveBoxMap[key]!.registerAdapterFunction();
    }
  }
}
