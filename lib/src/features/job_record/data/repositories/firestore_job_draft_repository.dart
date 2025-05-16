import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_draft_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/repositories/job_draft_repository.dart';

class FirestoreJobDraftRepository extends FirestoreRepository<JobDraftModel>
    implements JobDraftRepository {
  final FirebaseFirestore _firestore;

  FirestoreJobDraftRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(
          collectionPath: 'job_drafts',
          firestore: firestore,
        );

  @override
  JobDraftModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return JobDraftModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(JobDraftModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<JobDraftModel>> getDraftsByUser(String userId) async {
    return query(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Stream<List<JobDraftModel>> watchDraftsByUser(String userId) {
    return watchQuery(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Future<List<JobDraftModel>> getDraftsByWorker(String workerId) async {
    // Busca todos os drafts e filtra localmente
    final allDrafts = await getAll();
    return allDrafts.where((draft) {
      return draft.employees.any((employee) => employee.employeeId == workerId);
    }).toList();
  }

  @override
  Future<void> convertToRecord(String draftId) async {
    final draftDoc = await collection.doc(draftId).get();
    if (!draftDoc.exists) {
      throw Exception('Draft with ID $draftId not found');
    }

    final draft = fromFirestore(draftDoc);
    
    // Transação para garantir consistência
    await _firestore.runTransaction((transaction) async {
      // Criar novo registro de trabalho a partir do rascunho
      final recordData = draft.toFirestore();
      recordData.remove('id'); // Remove o ID do draft
      recordData['created_at'] = Timestamp.now();
      recordData['updated_at'] = Timestamp.now();

      // Criar o registro
      final recordRef = _firestore.collection('job_records').doc();
      transaction.set(recordRef, recordData);
      
      // Excluir o rascunho
      transaction.delete(collection.doc(draftId));
    });
  }
}