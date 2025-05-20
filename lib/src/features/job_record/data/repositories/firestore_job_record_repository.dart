import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/repositories/job_record_repository.dart';

class FirestoreJobRecordRepository extends FirestoreRepository<JobRecordModel>
    implements JobRecordRepository {
  FirestoreJobRecordRepository({FirebaseFirestore? firestore})
      : super(
          collectionPath: 'job_records',
          firestore: firestore,
        );

  @override
  JobRecordModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return JobRecordModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(JobRecordModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<JobRecordModel>> getRecordsByUser(String userId) async {
    return query(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Stream<List<JobRecordModel>> watchRecordsByUser(String userId) {
    return watchQuery(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Future<List<JobRecordModel>> getRecordsByEmployee(String employeeId) async {
    // Busca todos os registros e filtra localmente
    final allRecords = await getAll();
    return allRecords.where((record) {
      return record.employees.any((employee) => employee.employeeId == employeeId);
    }).toList();
  }

  @override
  Stream<List<JobRecordModel>> watchRecordsByEmployee(String employeeId) {
    // Busca todos os registros e filtra localmente
    return watchAll().map((records) {
      return records.where((record) {
        return record.employees.any((employee) => employee.employeeId == employeeId);
      }).toList();
    });
  }
}