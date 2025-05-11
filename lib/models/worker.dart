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
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']) ?? DateTime.now(),
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
  
  // Getter for id to satisfy debug_page references
  String get id => uniqueId;
  
  // Full name helper
  String get name => '$firstName $lastName';

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    // Handle Firestore Timestamp
    if (value.runtimeType.toString() == 'Timestamp') {
      return value.toDate();
    }
    return DateTime.now();
  }
}
