import 'package:hive/hive.dart';

part 'timesheet_draft.g.dart';

@HiveType(typeId: 2)
class TimesheetDraftModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String jobName;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String tm;

  @HiveField(4)
  String foreman;

  @HiveField(5)
  String jobDesc;

  @HiveField(6)
  String jobSize;

  @HiveField(7)
  String material;

  @HiveField(8)
  String notes;

  @HiveField(9)
  String vehicle;

  @HiveField(10)
  List<Map<String, dynamic>> workers;

  @HiveField(11)
  DateTime lastUpdated;

  @HiveField(12)
  DateTime updatedAt;

  TimesheetDraftModel({
    required this.userId,
    required this.jobName,
    required this.date,
    required this.tm,
    required this.foreman,
    required this.jobDesc,
    required this.jobSize,
    required this.material,
    required this.notes,
    required this.vehicle,
    required this.workers,
    required this.lastUpdated,
    required this.updatedAt,
  });

  factory TimesheetDraftModel.fromMap(Map<String, dynamic> map) {
    return TimesheetDraftModel(
      userId: map['userId'],
      jobName: map['jobName'],
      date: DateTime.parse(map['date']),
      tm: map['tm'],
      foreman: map['foreman'],
      jobDesc: map['jobDesc'],
      jobSize: map['jobSize'],
      material: map['material'],
      notes: map['notes'],
      vehicle: map['vehicle'],
      workers: List<Map<String, dynamic>>.from(map['workers']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'jobName': jobName,
      'date': date.toIso8601String(),
      'tm': tm,
      'foreman': foreman,
      'jobDesc': jobDesc,
      'jobSize': jobSize,
      'material': material,
      'notes': notes,
      'vehicle': vehicle,
      'workers': workers,
      'lastUpdated': lastUpdated.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}