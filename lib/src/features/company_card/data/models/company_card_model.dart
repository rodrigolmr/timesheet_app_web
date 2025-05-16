import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_card_model.freezed.dart';
part 'company_card_model.g.dart';

@freezed
class CompanyCardModel with _$CompanyCardModel {
  const CompanyCardModel._();
  
  const factory CompanyCardModel({
    // Campos do sistema (não visíveis ao usuário final)
    required String id,
    
    // Campos visíveis ao usuário
    required String holderName,
    required String lastFourDigits,
    required bool isActive,
    
    // Campos de controle (sistema)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CompanyCardModel;

  factory CompanyCardModel.fromJson(Map<String, dynamic> json) => _$CompanyCardModelFromJson(json);

  factory CompanyCardModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CompanyCardModel(
      id: doc.id,
      holderName: data['holder_name'] as String,
      lastFourDigits: data['last_four_digits'] as String,
      isActive: data['is_active'] as bool,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'holder_name': holderName,
      'last_four_digits': lastFourDigits,
      'is_active': isActive,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}