import 'package:hive/hive.dart';
import '../../../models/worker.dart';

class WorkerModelAdapter extends TypeAdapter<WorkerModel> {
  @override
  final int typeId = 5;

  @override
  WorkerModel read(BinaryReader reader) {
    return WorkerModel(
      uniqueId: reader.readString(),
      firstName: reader.readString(),
      lastName: reader.readString(),
      status: reader.readString(),
      createdAt: reader.readDateTime(),
      updatedAt: reader.readDateTime(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkerModel obj) {
    writer.writeString(obj.uniqueId);
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.writeString(obj.status);
    writer.writeDateTime(obj.createdAt);
    writer.writeDateTime(obj.updatedAt);
  }
}