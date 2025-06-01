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
      status:
          $enumDecodeNullable(_$JobRecordStatusEnumMap, json['status']) ??
          JobRecordStatus.pending,
      approverNote: json['approverNote'] as String?,
      approvedAt:
          json['approvedAt'] == null
              ? null
              : DateTime.parse(json['approvedAt'] as String),
      approverId: json['approverId'] as String?,
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
  'status': _$JobRecordStatusEnumMap[instance.status]!,
  'approverNote': instance.approverNote,
  'approvedAt': instance.approvedAt?.toIso8601String(),
  'approverId': instance.approverId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$JobRecordStatusEnumMap = {
  JobRecordStatus.pending: 'pending',
  JobRecordStatus.approved: 'approved',
};
