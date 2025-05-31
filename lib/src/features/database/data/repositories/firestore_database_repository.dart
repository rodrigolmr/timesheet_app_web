import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';
import 'package:timesheet_app_web/src/features/database/domain/repositories/database_repository.dart';
import 'package:universal_html/html.dart' as html;
import 'package:csv/csv.dart';

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
    try {
      final snapshot = await _firestore.collection(collectionName).get();
      final documents = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
      
      final jsonString = const JsonEncoder.withIndent('  ').convert({
        'collection': collectionName,
        'exportDate': DateTime.now().toIso8601String(),
        'documentCount': documents.length,
        'documents': documents,
      });
      
      // Create and download file
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = '${collectionName}_export_${DateTime.now().millisecondsSinceEpoch}.json';
      anchor.click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error exporting collection: $e');
      rethrow;
    }
  }

  @override
  Future<void> backupDatabase() async {
    try {
      final backupData = <String, dynamic>{
        'backupDate': DateTime.now().toIso8601String(),
        'version': '1.0',
        'collections': {},
      };
      
      for (final collection in _collections) {
        final snapshot = await _firestore.collection(collection).get();
        final documents = snapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
        
        backupData['collections'][collection] = {
          'documentCount': documents.length,
          'documents': documents,
        };
      }
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = 'database_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      anchor.click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error backing up database: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    // Clear Firestore cache
    await _firestore.clearPersistence();
  }
  
  @override
  Future<int> importCollection(String collectionName, String csvData, {bool overwrite = false}) async {
    if (!_collections.contains(collectionName)) {
      throw Exception('Collection not found');
    }
    
    // Parse CSV data
    final lines = csvData.split('\n');
    if (lines.isEmpty) {
      return 0;
    }
    
    // Extract headers from first line
    final headers = lines[0].split(',');
    if (headers.isEmpty) {
      return 0;
    }
    
    // Validate headers against collection fields
    final validFields = _collectionFields[collectionName] ?? [];
    final invalidHeaders = headers.where((h) => !validFields.contains(h.trim())).toList();
    
    if (invalidHeaders.isNotEmpty) {
      throw Exception('Invalid headers: ${invalidHeaders.join(', ')}');
    }
    
    int importedCount = 0;
    final batch = _firestore.batch();
    
    // Process data rows
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      final values = _parseCSVLine(line);
      if (values.length != headers.length) {
        print('Skipping line $i: Column count mismatch');
        continue;
      }
      
      // Create document data
      final data = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        final header = headers[j].trim();
        final value = values[j].trim();
        
        // Skip empty values
        if (value.isEmpty) continue;
        
        // Convert values to appropriate types
        if (header == 'created_at' || header == 'updated_at' || header == 'date') {
          try {
            data[header] = DateTime.parse(value);
          } catch (_) {
            data[header] = value;
          }
        } else if (value == 'true' || value == 'false') {
          data[header] = value == 'true';
        } else if (double.tryParse(value) != null) {
          data[header] = double.parse(value);
        } else if (header == 'employees' || value.startsWith('[') && value.endsWith(']')) {
          // Tentar converter JSON string para objeto
          try {
            data[header] = jsonDecode(value);
          } catch (_) {
            data[header] = value;
          }
        } else {
          data[header] = value;
        }
      }
      
      // Add timestamps if missing
      final timestamp = DateTime.now();
      if (!data.containsKey('created_at')) {
        data['created_at'] = timestamp;
      }
      if (!data.containsKey('updated_at')) {
        data['updated_at'] = timestamp;
      }
      
      // Determine document ID
      String? docId = data['id'] as String?;
      if (docId != null) {
        data.remove('id');
        if (overwrite) {
          // Update existing document
          batch.set(_firestore.collection(collectionName).doc(docId), data, SetOptions(merge: true));
        } else {
          // Check if document exists
          final doc = await _firestore.collection(collectionName).doc(docId).get();
          if (!doc.exists) {
            batch.set(_firestore.collection(collectionName).doc(docId), data);
          } else {
            print('Skipping existing document: $docId');
            continue;
          }
        }
      } else {
        // Create new document with auto-generated ID
        batch.set(_firestore.collection(collectionName).doc(), data);
      }
      
      importedCount++;
      
      // Commit batch every 500 documents to avoid hitting size limits
      if (importedCount % 500 == 0) {
        await batch.commit();
      }
    }
    
    // Commit remaining documents
    if (importedCount % 500 != 0) {
      await batch.commit();
    }
    
    return importedCount;
  }
  
  // Helper para analisar linha CSV com campos entre aspas
  List<String> _parseCSVLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    String currentValue = '';
    
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        // Se encontrarmos aspas, alternamos o estado
        inQuotes = !inQuotes;
        currentValue += char;
      } else if (char == ',' && !inQuotes) {
        // Se for uma vírgula fora de aspas, finalizou um campo
        result.add(currentValue);
        currentValue = '';
      } else {
        // Qualquer outro caractere
        currentValue += char;
      }
    }
    
    // Adiciona o último campo
    if (currentValue.isNotEmpty) {
      result.add(currentValue);
    }
    
    return result;
  }
  
  @override
  Future<int> importJson(String collectionName, String jsonData, {bool overwrite = false}) async {
    if (!_collections.contains(collectionName)) {
      throw Exception('Collection not found');
    }
    
    try {
      // Parse JSON data
      final List<dynamic> documents = jsonDecode(jsonData) as List<dynamic>;
      if (documents.isEmpty) {
        return 0;
      }
      
      // Validate documents
      for (final doc in documents) {
        if (doc is! Map<String, dynamic>) {
          throw Exception('Invalid document format: not an object');
        }
        
        // Validate fields against collection schema
        final validFields = _collectionFields[collectionName] ?? [];
        final docFields = doc.keys.toList();
        final invalidFields = docFields.where((f) => 
            !validFields.contains(f) && 
            f != 'id' && // ID é permitido especialmente
            f != 'employees' // employees é um campo especial de array
        ).toList();
        
        if (invalidFields.isNotEmpty) {
          print('Warning: Document contains invalid fields: ${invalidFields.join(', ')}');
        }
      }
      
      int importedCount = 0;
      final batch = _firestore.batch();
      
      // Process documents
      for (final doc in documents) {
        final data = Map<String, dynamic>.from(doc as Map<String, dynamic>);
        
        // Add timestamps if missing
        final timestamp = DateTime.now();
        if (!data.containsKey('created_at')) {
          data['created_at'] = timestamp;
        } else if (data['created_at'] is String) {
          // Convert string to DateTime
          try {
            data['created_at'] = DateTime.parse(data['created_at'] as String);
          } catch (_) {
            data['created_at'] = timestamp;
          }
        }
        
        if (!data.containsKey('updated_at')) {
          data['updated_at'] = timestamp;
        } else if (data['updated_at'] is String) {
          // Convert string to DateTime
          try {
            data['updated_at'] = DateTime.parse(data['updated_at'] as String);
          } catch (_) {
            data['updated_at'] = timestamp;
          }
        }
        
        // Convert date field if it's a string
        if (data.containsKey('date') && data['date'] is String) {
          try {
            data['date'] = DateTime.parse(data['date'] as String);
          } catch (_) {
            // Keep as is if parsing fails
          }
        }
        
        // Determine document ID
        String? docId = data['id'] as String?;
        if (docId != null) {
          data.remove('id');
          if (overwrite) {
            // Update existing document
            batch.set(_firestore.collection(collectionName).doc(docId), data, SetOptions(merge: true));
          } else {
            // Check if document exists
            final doc = await _firestore.collection(collectionName).doc(docId).get();
            if (!doc.exists) {
              batch.set(_firestore.collection(collectionName).doc(docId), data);
            } else {
              print('Skipping existing document: $docId');
              continue;
            }
          }
        } else {
          // Create new document with auto-generated ID
          batch.set(_firestore.collection(collectionName).doc(), data);
        }
        
        importedCount++;
        
        // Commit batch every 500 documents to avoid hitting size limits
        if (importedCount % 500 == 0) {
          await batch.commit();
        }
      }
      
      // Commit remaining documents
      if (importedCount % 500 != 0) {
        await batch.commit();
      }
      
      return importedCount;
    } catch (e) {
      print('Error importing JSON data: $e');
      rethrow;
    }
  }
}