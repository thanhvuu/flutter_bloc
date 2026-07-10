// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemEntityAdapter extends TypeAdapter<CartItemEntity> {
  @override
  final int typeId = 1;

  @override
  CartItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemEntity(
      id: fields[0] as String,
      product: fields[1] as ProductEntity,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
