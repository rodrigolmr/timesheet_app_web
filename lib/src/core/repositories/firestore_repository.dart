import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/core/utils/text_formatters.dart';

/// Implementação base para repositórios Firestore
abstract class FirestoreRepository<T> implements BaseRepository<T> {
  final FirebaseFirestore _firestore;
  final String _collectionPath;

  FirestoreRepository({
    required String collectionPath,
    FirebaseFirestore? firestore,
  })  : _collectionPath = collectionPath,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Método para converter um DocumentSnapshot em uma entidade
  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);

  /// Método para converter uma entidade em um Map para o Firestore
  Map<String, dynamic> toFirestore(T entity);

  /// Referência para a coleção
  CollectionReference<Map<String, dynamic>> get collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<T?> getById(String id) async {
    print('FirestoreRepository.getById - Collection: $_collectionPath, ID: $id');
    final doc = await collection.doc(id).get();
    print('FirestoreRepository.getById - Document exists: ${doc.exists}');
    if (!doc.exists) {
      print('FirestoreRepository.getById - Document not found for ID: $id');
      return null;
    }
    final entity = fromFirestore(doc);
    print('FirestoreRepository.getById - Entity created: $entity');
    return entity;
  }

  @override
  Future<List<T>> getAll() async {
    final querySnapshot = await collection.get();
    return querySnapshot.docs.map(fromFirestore).toList();
  }

  @override
  Future<String> create(T entity) async {
    var data = toFirestore(entity);
    
    // Apply field cleaning if entity implements CleanableModel
    if (entity is CleanableModel) {
      data = TextCleaners.cleanJsonFields(data, entity.cleanableFields);
    }
    
    final docRef = await collection.add(data);
    return docRef.id;
  }

  @override
  Future<void> update(String id, T entity) async {
    var data = toFirestore(entity);
    
    // Apply field cleaning if entity implements CleanableModel
    if (entity is CleanableModel) {
      data = TextCleaners.cleanJsonFields(data, entity.cleanableFields);
    }
    
    await collection.doc(id).update(data);
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Stream<List<T>> watchAll() {
    return collection.snapshots().map(
          (snapshot) => snapshot.docs.map(fromFirestore).toList(),
        );
  }

  @override
  Stream<T?> watchById(String id) {
    return collection.doc(id).snapshots().map(
          (doc) => doc.exists ? fromFirestore(doc) : null,
        );
  }

  /// Método auxiliar para consultas com filtros
  Future<List<T>> query(Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>> collection) queryBuilder) async {
    final query = queryBuilder(collection);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map(fromFirestore).toList();
  }

  /// Método auxiliar para stream de consultas com filtros
  Stream<List<T>> watchQuery(Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>> collection) queryBuilder) {
    final query = queryBuilder(collection);
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(fromFirestore).toList(),
        );
  }
}