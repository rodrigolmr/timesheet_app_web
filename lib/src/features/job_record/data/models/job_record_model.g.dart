// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobRecordModelImpl _$$JobRecordModelImplFromJson(Map<String, dynamic> json) =>
    _$JobRecordModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      jobName: json['jobName'] as String,
      date: DateTime.parse(json['date'] as String),
      territorialManager: json['territorialManager'] as String,
      jobSize: json['jobSize'] as String,
      material: json['material'] as String,
      jobDescription: json['jobDescription'] as String,
      foreman: json['foreman'] as String,
      vehicle: json['vehicle'] as String,
      employees:
          (json['employees'] as List<dynamic>)
              .map((e) => JobEmployeeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      notes: json['notes'] as String? ?? '',
      workerId: json['workerId'] as String? ?? '',
      companyCardId: json['companyCardId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JobRecordModelImplToJson(
  _$JobRecordModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'jobName': instance.jobName,
  'date': instance.date.toIso8601String(),
  'territorialManager': instance.territorialManager,
  'jobSize': instance.jobSize,
  'material': instance.material,
  'jobDescription': instance.jobDescription,
  'foreman': instance.foreman,
  'vehicle': instance.vehicle,
  'employees': instance.employees,
  'notes': instance.notes,
  'workerId': instance.workerId,
  'companyCardId': instance.companyCardId,
  'status': instance.status,
  'hours': instance.hours,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
