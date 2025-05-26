// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cardId: json['cardId'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      status:
          $enumDecodeNullable(_$ExpenseStatusEnumMap, json['status']) ??
          ExpenseStatus.pending,
      reviewerNote: json['reviewerNote'] as String?,
      reviewedAt:
          json['reviewedAt'] == null
              ? null
              : DateTime.parse(json['reviewedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'cardId': instance.cardId,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'status': _$ExpenseStatusEnumMap[instance.status]!,
      'reviewerNote': instance.reviewerNote,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.pending: 'pending',
  ExpenseStatus.approved: 'approved',
  ExpenseStatus.rejected: 'rejected',
};
