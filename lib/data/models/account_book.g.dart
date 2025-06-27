// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBookModelAdapter extends TypeAdapter<AccountBookModel> {
  @override
  final int typeId = 0;

  @override
  AccountBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBookModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
