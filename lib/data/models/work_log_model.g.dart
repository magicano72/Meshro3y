// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkLogModelAdapter extends TypeAdapter<WorkLogModel> {
  @override
  final int typeId = 3;

  @override
  WorkLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkLogModel(
      id: fields[0] as String,
      projectId: fields[1] as String,
      machineId: fields[2] as String,
      date: fields[3] as DateTime,
      hours: fields[4] as double,
      totalPrice: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WorkLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.machineId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.hours)
      ..writeByte(5)
      ..write(obj.totalPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
