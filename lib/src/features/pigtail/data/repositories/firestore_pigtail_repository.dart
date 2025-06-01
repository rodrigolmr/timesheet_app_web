import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';
import 'package:timesheet_app_web/src/features/pigtail/domain/repositories/pigtail_repository.dart';

class FirestorePigtailRepository extends FirestoreRepository<PigtailModel> 
    implements PigtailRepository {
  FirestorePigtailRepository({required FirebaseFirestore firestore})
      : super(collectionPath: 'pigtails', firestore: firestore);

  @override
  PigtailModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PigtailModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(PigtailModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<PigtailModel>> getByUserId(String userId) async {
    final snapshot = await collection
        .where('installed_by', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs.map(fromFirestore).toList();
  }

  @override
  Stream<List<PigtailModel>> watchByUserId(String userId) {
    return collection
        .where('installed_by', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(fromFirestore).toList());
  }
}