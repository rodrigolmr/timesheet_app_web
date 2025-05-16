import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// Provider que fornece a instância do FirebaseFirestore
/// configurada para persistência offline
@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) {
  // Configurando persistência offline
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  return FirebaseFirestore.instance;
}

/// Provider que fornece a instância do FirebaseAuth
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}