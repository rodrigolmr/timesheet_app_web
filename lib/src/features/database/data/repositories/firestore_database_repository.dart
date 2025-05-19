import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';
import 'package:timesheet_app_web/src/features/database/domain/repositories/database_repository.dart';

class FirestoreDatabaseRepository implements DatabaseRepository {
  final FirebaseFirestore _firestore;
  
  FirestoreDatabaseRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Collections in the database based on DATABASE_TREE.md
  final List<String> _collections = [
    'users',
    'employees',
    'company_cards',
    'expenses',
    'job_records',
    'job_drafts',
  ];

  final Map<String, List<String>> _collectionFields = {
    'users': ['id', 'auth_uid', 'email', 'first_name', 'last_name', 'role', 'is_active', 'created_at', 'updated_at'],
    'employees': ['id', 'first_name', 'last_name', 'is_active', 'created_at', 'updated_at'],
    'company_cards': ['id', 'holder_name', 'last_four_digits', 'is_active', 'created_at', 'updated_at'],
    'expenses': ['id', 'user_id', 'card_id', 'amount', 'date', 'description', 'image_url', 'created_at', 'updated_at'],
    'job_records': ['id', 'user_id', 'job_name', 'date', 'territorial_manager', 'job_size', 'material', 'job_description', 'foreman', 'vehicle', 'employees', 'created_at', 'updated_at'],
    'job_drafts': ['id', 'user_id', 'job_name', 'date', 'territorial_manager', 'job_size', 'material', 'job_description', 'foreman', 'vehicle', 'employees', 'created_at', 'updated_at'],
  };

  @override
  Future<List<DatabaseStatsModel>> getCollectionStats() async {
    final List<DatabaseStatsModel> stats = [];

    for (final collection in _collections) {
      try {
        final snapshot = await _firestore.collection(collection).get();
        final documentCount = snapshot.size;
        
        DateTime? lastUpdated;
        int approximateSize = 0;

        if (snapshot.docs.isNotEmpty) {
          // Get the most recently updated document
          final sortedDocs = snapshot.docs
              .where((doc) => doc.data().containsKey('updated_at'))
              .toList()
              ..sort((a, b) {
                final aTime = (a.data()['updated_at'] as Timestamp).toDate();
                final bTime = (b.data()['updated_at'] as Timestamp).toDate();
                return bTime.compareTo(aTime);
              });

          if (sortedDocs.isNotEmpty) {
            lastUpdated = (sortedDocs.first.data()['updated_at'] as Timestamp).toDate();
          }

          // Estimate collection size
          for (final doc in snapshot.docs) {
            approximateSize += doc.data().toString().length;
          }
        }

        stats.add(DatabaseStatsModel(
          collectionName: collection,
          documentCount: documentCount,
          lastUpdated: lastUpdated,
          approximateSizeInBytes: approximateSize,
        ));
      } catch (e) {
        print('Error getting stats for collection $collection: $e');
        stats.add(DatabaseStatsModel(
          collectionName: collection,
          documentCount: 0,
          lastUpdated: null,
          approximateSizeInBytes: 0,
        ));
      }
    }

    return stats;
  }

  @override
  Future<DatabaseCollectionModel> getCollectionDetails(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();
    final documentCount = snapshot.size;
    
    DateTime? lastUpdated;
    if (snapshot.docs.isNotEmpty) {
      final sortedDocs = snapshot.docs
          .where((doc) => doc.data().containsKey('updated_at'))
          .toList()
          ..sort((a, b) {
            final aTime = (a.data()['updated_at'] as Timestamp).toDate();
            final bTime = (b.data()['updated_at'] as Timestamp).toDate();
            return bTime.compareTo(aTime);
          });

      if (sortedDocs.isNotEmpty) {
        lastUpdated = (sortedDocs.first.data()['updated_at'] as Timestamp).toDate();
      }
    }

    return DatabaseCollectionModel(
      name: collectionName,
      documentCount: documentCount,
      fields: _collectionFields[collectionName] ?? [],
      lastUpdated: lastUpdated,
    );
  }

  @override
  Future<Map<String, dynamic>> getSampleDocument(String collectionName) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) {
      return {};
    }

    final doc = snapshot.docs.first;
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments(String collectionName, {int limit = 20}) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .limit(limit)
        .get();
    
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getDocument(String collectionName, String documentId) async {
    final doc = await _firestore
        .collection(collectionName)
        .doc(documentId)
        .get();
    
    if (!doc.exists) {
      throw Exception('Document not found');
    }

    return {
      'id': doc.id,
      ...doc.data()!,
    };
  }

  @override
  Future<String> createDocument(String collectionName, Map<String, dynamic> data) async {
    // Remove id field if it exists (Firestore will generate it)
    final dataToSave = Map<String, dynamic>.from(data);
    dataToSave.remove('id');
    
    // Add timestamps
    final timestamp = Timestamp.now();
    dataToSave['created_at'] = timestamp;
    dataToSave['updated_at'] = timestamp;

    final docRef = await _firestore.collection(collectionName).add(dataToSave);
    return docRef.id;
  }

  @override
  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    // Remove id field if it exists
    final dataToUpdate = Map<String, dynamic>.from(data);
    dataToUpdate.remove('id');
    
    // Update timestamp
    dataToUpdate['updated_at'] = Timestamp.now();

    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .update(dataToUpdate);
  }

  @override
  Future<void> deleteDocument(String collectionName, String documentId) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .delete();
  }

  @override
  Future<void> generateTestData(String collectionName, int count) async {
    final batch = _firestore.batch();
    final timestamp = Timestamp.now();

    for (int i = 0; i < count; i++) {
      final docRef = _firestore.collection(collectionName).doc();
      
      Map<String, dynamic> testData;
      
      switch (collectionName) {
        case 'users':
          testData = {
            'auth_uid': 'test_uid_$i',
            'email': 'test$i@example.com',
            'first_name': 'Test',
            'last_name': 'User $i',
            'role': i % 3 == 0 ? 'admin' : (i % 2 == 0 ? 'manager' : 'user'),
            'is_active': true,
            'created_at': timestamp,
            'updated_at': timestamp,
          };
          break;
          
        case 'employees':
          testData = {
            'first_name': 'Employee',
            'last_name': 'Test $i',
            'is_active': true,
            'created_at': timestamp,
            'updated_at': timestamp,
          };
          break;
          
        case 'company_cards':
          testData = {
            'holder_name': 'Card Holder $i',
            'last_four_digits': '${1000 + i}'.substring(0, 4),
            'is_active': true,
            'created_at': timestamp,
            'updated_at': timestamp,
          };
          break;
          
        case 'expenses':
          testData = {
            'user_id': 'test_user_$i',
            'card_id': 'test_card_$i',
            'amount': (100 + i * 10).toDouble(),
            'date': timestamp,
            'description': 'Test expense $i',
            'image_url': '',
            'created_at': timestamp,
            'updated_at': timestamp,
          };
          break;
          
        case 'job_records':
        case 'job_drafts':
          testData = {
            'user_id': 'test_user_$i',
            'job_name': 'Test Job $i',
            'date': timestamp,
            'territorial_manager': 'Manager $i',
            'job_size': 'Medium',
            'material': 'Material $i',
            'job_description': 'Test job description $i',
            'foreman': 'Foreman $i',
            'vehicle': 'Vehicle $i',
            'employees': [
              {
                'employee_id': 'emp_$i',
                'employee_name': 'Worker $i',
                'start_time': '08:00',
                'finish_time': '17:00',
                'hours': 8.0,
                'travel_hours': 1.0,
                'meal': 1.0,
              }
            ],
            'created_at': timestamp,
            'updated_at': timestamp,
          };
          break;
          
        default:
          testData = {
            'test_field': 'Test data $i',
            'created_at': timestamp,
            'updated_at': timestamp,
          };
      }
      
      batch.set(docRef, testData);
    }

    await batch.commit();
  }

  @override
  Future<void> exportCollection(String collectionName) async {
    // This would typically export to a file or external storage
    // For now, we'll just print stats
    final snapshot = await _firestore.collection(collectionName).get();
    print('Exporting ${snapshot.size} documents from $collectionName');
    // TODO: Implement actual export functionality
  }

  @override
  Future<void> backupDatabase() async {
    // This would create a backup of all collections
    // For now, we'll just print what would be backed up
    for (final collection in _collections) {
      final snapshot = await _firestore.collection(collection).get();
      print('Would backup ${snapshot.size} documents from $collection');
    }
    // TODO: Implement actual backup functionality
  }

  @override
  Future<void> clearCache() async {
    // Clear Firestore cache
    await _firestore.clearPersistence();
  }
}