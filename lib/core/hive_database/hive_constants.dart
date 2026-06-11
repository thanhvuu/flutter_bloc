import 'package:hive/hive.dart';
import 'package:bloc_app_demo/core/hive_database/entities/product_entity/product_entity.dart';
import 'package:bloc_app_demo/core/hive_database/entities/cart_item_entity/cart_item_entity.dart';



class HiveBoxName {
  static const String products = 'products'; // 1
  static const String cartItems = 'cart_items'; // 2
}

class HiveBoxMap {
  static Map<Type, MyHive> hiveBoxMap = {
    ProductEntity: MyHive<ProductEntity>(
      boxName: HiveBoxName.products,
      registerAdapterFunction: () {
        Hive.registerAdapter(ProductEntityAdapter());
      },
    ),

    CartItemEntity: MyHive<CartItemEntity>(
      boxName: HiveBoxName.cartItems,
      registerAdapterFunction: () {
        Hive.registerAdapter(CartItemEntityAdapter());
      }
    )
    
  };
}

class MyHive<EntityT> {
  String boxName;
  late Future<void> Function() openBoxFunction;
  void Function() registerAdapterFunction;

  MyHive({required this.boxName, required this.registerAdapterFunction}) {
    openBoxFunction = () async {
      await Hive.openBox<EntityT>(boxName);
    };
  }
}
