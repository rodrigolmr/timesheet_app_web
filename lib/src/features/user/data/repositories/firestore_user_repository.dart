import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/domain/repositories/user_repository.dart';

class FirestoreUserRepository extends FirestoreRepository<UserModel> implements UserRepository {
  FirestoreUserRepository({FirebaseFirestore? firestore})
      : super(
          collectionPath: 'users',
          firestore: firestore,
        );

  @override
  UserModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(UserModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<UserModel?> getUserByAuthUid(String authUid) async {
    try {
      final querySnapshot = await collection
          .where('auth_uid', isEqualTo: authUid)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = querySnapshot.docs.first;
      
      return fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserModel?> watchUserByAuthUid(String authUid) {
    return collection
        .where('auth_uid', isEqualTo: authUid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = snapshot.docs.first;
      
      try {
        final userModel = fromFirestore(doc);
        return userModel;
      } catch (e) {
        rethrow;
      }
    })
    .handleError((error) {
      return null;
    });
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    return query(
      (collection) => collection.where('role', isEqualTo: role),
    );
  }

  @override
  Future<void> toggleUserActive(String id, bool isActive) async {
    await collection.doc(id).update({'is_active': isActive});
  }
  
  @override
  Future<void> updateUserTheme(String id, String themePreference, {bool? forcedTheme}) async {
    final updates = <String, dynamic>{
      'theme_preference': themePreference,
      'updated_at': FieldValue.serverTimestamp(),
    };
    
    // Adiciona forcedTheme apenas se foi fornecido
    if (forcedTheme != null) {
      updates['forced_theme'] = forcedTheme;
    }
    
    await collection.doc(id).update(updates);
  }
}