import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();
  
  const factory ExpenseModel({
    // Campos do sistema (não visíveis ao usuário)
    required String id,
    required String userId,
    required String cardId,
    
    // Campos visíveis ao usuário
    required double amount,
    required DateTime date,
    required String description,
    required String imageUrl,
    
    // Campos de status
    @Default(ExpenseStatus.pending) ExpenseStatus status,
    String? reviewerNote,
    DateTime? reviewedAt,
    
    // Campos de controle (sistema)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);

  factory ExpenseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    print('ExpenseModel.fromFirestore - Document ID: ${doc.id}');
    print('ExpenseModel.fromFirestore - Data: $data');
    print('ExpenseModel.fromFirestore - user_id field: ${data['user_id']}');
    
    return ExpenseModel(
      id: doc.id,
      userId: data['user_id'] as String,
      cardId: data['card_id'] as String,
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] as String,
      imageUrl: data['image_url'] as String,
      status: data['status'] != null 
          ? ExpenseStatus.values.firstWhere((e) => e.name == data['status'])
          : ExpenseStatus.pending,
      reviewerNote: data['reviewer_note'] as String?,
      reviewedAt: data['reviewed_at'] != null 
          ? (data['reviewed_at'] as Timestamp).toDate()
          : null,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'card_id': cardId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'description': description,
      'image_url': imageUrl,
      'status': status.name,
      if (reviewerNote != null) 'reviewer_note': reviewerNote,
      if (reviewedAt != null) 'reviewed_at': Timestamp.fromDate(reviewedAt!),
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}