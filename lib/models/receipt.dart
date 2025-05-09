import 'package:hive/hive.dart';

part 'receipt.g.dart';

@HiveType(typeId: 1)
class ReceiptModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String cardLast4;

  @HiveField(2)
  String amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String description;

  @HiveField(5)
  String imageUrl;

  @HiveField(6)
  DateTime timestamp;

  @HiveField(7)
  DateTime updatedAt;

  ReceiptModel({
    required this.userId,
    required this.cardLast4,
    required this.amount,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
    required this.updatedAt,
  });

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      userId: map['userId'],
      cardLast4: map['cardLast4'],
      amount: map['amount'],
      date: _parseDate(map['date']) ?? DateTime.now(),
      description: map['description'],
      imageUrl: map['imageUrl'],
      timestamp: _parseDate(map['timestamp']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cardLast4': cardLast4,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  // Field for Hive object ID
  String get uniqueId => key.toString();
  
  // Getter for id to satisfy debug_page references
  String get id => uniqueId;
  
  // Getter for merchant to match references in debug_page
  String get merchant => description;

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw Exception('Unsupported date type: ${value.runtimeType}');
  }
}
