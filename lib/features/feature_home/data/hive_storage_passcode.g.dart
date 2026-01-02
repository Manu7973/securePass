// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_storage_passcode.dart';

class PasswordModelAdapter extends TypeAdapter<PasswordModel> {
  @override
  final int typeId = 1;

  @override
  PasswordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return PasswordModel(
      siteName: fields[0] as String,
      username: fields[1] as String,
      password: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordModel obj) {
    writer
      ..writeByte(3) // number of fields
      ..writeByte(0)
      ..write(obj.siteName)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
