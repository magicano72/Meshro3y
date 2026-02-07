// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MachineModelAdapter extends TypeAdapter<MachineModel> {
  @override
  final int typeId = 1;

  @override
  MachineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MachineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      pricePerHour: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MachineModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pricePerHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MachineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
