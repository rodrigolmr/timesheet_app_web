import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/domain/repositories/expense_repository.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';

class FirestoreExpenseRepository extends FirestoreRepository<ExpenseModel>
    implements ExpenseRepository {
  FirestoreExpenseRepository({FirebaseFirestore? firestore})
      : super(
          collectionPath: 'expenses',
          firestore: firestore,
        );

  @override
  ExpenseModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ExpenseModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(ExpenseModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByStatus(ExpenseStatus status) async {
    final statusStr = _mapExpenseStatusToString(status);
    return query(
      (collection) => collection.where('status', isEqualTo: statusStr),
    );
  }

  @override
  Stream<List<ExpenseModel>> watchExpensesByStatus(ExpenseStatus status) {
    final statusStr = _mapExpenseStatusToString(status);
    return watchQuery(
      (collection) => collection.where('status', isEqualTo: statusStr),
    );
  }

  @override
  Future<List<ExpenseModel>> getExpensesByUser(String userId) async {
    return query(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Stream<List<ExpenseModel>> watchExpensesByUser(String userId) {
    return watchQuery(
      (collection) => collection.where('user_id', isEqualTo: userId),
    );
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCard(String cardId) async {
    return query(
      (collection) => collection.where('card_id', isEqualTo: cardId),
    );
  }

  @override
  Future<void> updateExpenseStatus(String id, ExpenseStatus status, {String? reviewerNote}) async {
    final data = {
      'status': _mapExpenseStatusToString(status),
      'reviewed_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    };
    
    if (reviewerNote != null) {
      data['reviewer_note'] = reviewerNote;
    }
    
    await collection.doc(id).update(data);
  }

  String _mapExpenseStatusToString(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.pending:
        return 'pending';
      case ExpenseStatus.approved:
        return 'approved';
      case ExpenseStatus.rejected:
        return 'rejected';
    }
  }
}