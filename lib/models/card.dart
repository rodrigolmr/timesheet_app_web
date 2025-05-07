import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId: 0)
class CardModel extends HiveObject {
  @HiveField(0)
  String uniqueId;

  @HiveField(1)
  String cardholderName;

  @HiveField(2)
  String last4Digits;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  CardModel({
    required this.uniqueId,
    required this.cardholderName,
    required this.last4Digits,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      uniqueId: map['uniqueId'],
      cardholderName: map['cardholderName'],
      last4Digits: map['last4Digits'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueId': uniqueId,
      'cardholderName': cardholderName,
      'last4Digits': last4Digits,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
