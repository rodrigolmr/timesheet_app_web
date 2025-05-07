import 'package:hive/hive.dart';

part 'worker.g.dart';

@HiveType(typeId: 5)
class WorkerModel extends HiveObject {
  @HiveField(0)
  String uniqueId;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  WorkerModel({
    required this.uniqueId,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      uniqueId: map['uniqueId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueId': uniqueId,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}