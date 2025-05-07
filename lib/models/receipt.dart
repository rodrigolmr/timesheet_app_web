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
      date: DateTime.parse(map['date']),
      description: map['description'],
      imageUrl: map['imageUrl'],
      timestamp: DateTime.parse(map['timestamp']),
      updatedAt: DateTime.parse(map['updatedAt']),
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
}