// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimesheetModelAdapter extends TypeAdapter<TimesheetModel> {
  @override
  final int typeId = 3;

  @override
  TimesheetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimesheetModel(
      userId: fields[0] as String,
      jobName: fields[1] as String,
      date: fields[2] as DateTime,
      tm: fields[3] as String,
      foreman: fields[4] as String,
      jobDesc: fields[5] as String,
      jobSize: fields[6] as String,
      material: fields[7] as String,
      notes: fields[8] as String,
      vehicle: fields[9] as String,
      workers: (fields[10] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      timestamp: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimesheetModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.jobName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.tm)
      ..writeByte(4)
      ..write(obj.foreman)
      ..writeByte(5)
      ..write(obj.jobDesc)
      ..writeByte(6)
      ..write(obj.jobSize)
      ..writeByte(7)
      ..write(obj.material)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.vehicle)
      ..writeByte(10)
      ..write(obj.workers)
      ..writeByte(11)
      ..write(obj.timestamp)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimesheetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
