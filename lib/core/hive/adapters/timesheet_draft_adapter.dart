import 'package:hive/hive.dart';
import '../../../models/timesheet_draft.dart';

class TimesheetDraftModelAdapter extends TypeAdapter<TimesheetDraftModel> {
  @override
  final int typeId = 2;

  @override
  TimesheetDraftModel read(BinaryReader reader) {
    return TimesheetDraftModel(
      userId: reader.readString(),
      jobName: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      tm: reader.readString(),
      foreman: reader.readString(),
      jobDesc: reader.readString(),
      jobSize: reader.readString(),
      material: reader.readString(),
      notes: reader.readString(),
      vehicle: reader.readString(),
      workers: List<Map<String, dynamic>>.from(reader.readList()),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, TimesheetDraftModel obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.jobName);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.tm);
    writer.writeString(obj.foreman);
    writer.writeString(obj.jobDesc);
    writer.writeString(obj.jobSize);
    writer.writeString(obj.material);
    writer.writeString(obj.notes);
    writer.writeString(obj.vehicle);
    writer.writeList(obj.workers);
    writer.writeInt(obj.lastUpdated.millisecondsSinceEpoch);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
