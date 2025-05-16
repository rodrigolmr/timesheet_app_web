import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/domain/repositories/employee_repository.dart';

class FirestoreEmployeeRepository extends FirestoreRepository<EmployeeModel>
    implements EmployeeRepository {
  FirestoreEmployeeRepository({FirebaseFirestore? firestore})
      : super(
          collectionPath: 'employees',
          firestore: firestore,
        );

  @override
  EmployeeModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return EmployeeModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(EmployeeModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<EmployeeModel>> getActiveEmployees() async {
    return query(
      (collection) => collection.where('is_active', isEqualTo: true),
    );
  }

  @override
  Stream<List<EmployeeModel>> watchActiveEmployees() {
    return watchQuery(
      (collection) => collection.where('is_active', isEqualTo: true),
    );
  }

  @override
  Future<void> toggleEmployeeActive(String id, bool isActive) async {
    await collection.doc(id).update({'is_active': isActive});
  }
}