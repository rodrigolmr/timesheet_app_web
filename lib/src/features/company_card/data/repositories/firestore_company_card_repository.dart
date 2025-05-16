import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/company_card/domain/repositories/company_card_repository.dart';

class FirestoreCompanyCardRepository extends FirestoreRepository<CompanyCardModel>
    implements CompanyCardRepository {
  FirestoreCompanyCardRepository({FirebaseFirestore? firestore})
      : super(
          collectionPath: 'company_cards',
          firestore: firestore,
        );

  @override
  CompanyCardModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CompanyCardModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(CompanyCardModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<CompanyCardModel>> getActiveCards() async {
    return query(
      (collection) => collection.where('is_active', isEqualTo: true),
    );
  }

  @override
  Stream<List<CompanyCardModel>> watchActiveCards() {
    return watchQuery(
      (collection) => collection.where('is_active', isEqualTo: true),
    );
  }

  @override
  Future<void> toggleCardActive(String id, bool isActive) async {
    await collection.doc(id).update({'is_active': isActive});
  }
}