// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyCardModelImpl _$$CompanyCardModelImplFromJson(
  Map<String, dynamic> json,
) => _$CompanyCardModelImpl(
  id: json['id'] as String,
  holderName: json['holderName'] as String,
  lastFourDigits: json['lastFourDigits'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CompanyCardModelImplToJson(
  _$CompanyCardModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'holderName': instance.holderName,
  'lastFourDigits': instance.lastFourDigits,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
