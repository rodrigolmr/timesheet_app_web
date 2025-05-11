import 'package:cloud_firestore/cloud_firestore.dart';

// Flag para modo de desenvolvimento (sem acessar o Firestore)
const bool _devMode = false;

// Função para verificar se o modo desenvolvimento está ativado
bool isDevMode() {
  // Sempre retorna false para garantir que o modo de desenvolvimento não seja usado em produção
  return false;
}

// Mock data para desenvolvimento
final _now = DateTime.now().toIso8601String();

Future<List<Map<String, dynamic>>> fetchCardsFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para cards em vez do Firestore');
    return [];
  }

  final snapshot = await FirebaseFirestore.instance.collection('cards').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['uniqueId'] = doc.id;
    data['createdAt'] = _safeTimestampToIsoString(data['createdAt']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchReceiptsFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para receipts em vez do Firestore');
    return [];
  }

  final snapshot =
      await FirebaseFirestore.instance.collection('receipts').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['id'] = doc.id;
    data['date'] = _safeTimestampToIsoString(data['date']);
    data['timestamp'] = _safeTimestampToIsoString(data['timestamp']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchDraftsFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para drafts em vez do Firestore');
    return [];
  }

  final snapshot =
      await FirebaseFirestore.instance.collection('timesheet_drafts').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['id'] = doc.id;
    data['date'] = _safeTimestampToIsoString(data['date']);
    data['lastUpdated'] = _safeTimestampToIsoString(data['lastUpdated']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchTimesheetsFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para timesheets em vez do Firestore');
    return [];
  }

  final snapshot =
      await FirebaseFirestore.instance.collection('timesheets').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['id'] = doc.id;
    data['date'] = _safeTimestampToIsoString(data['date']);
    data['timestamp'] = _safeTimestampToIsoString(data['timestamp']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchUsersFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para users em vez do Firestore');
    return [
      {
        'userId': 'mock-user-id',
        'email': 'rodrigo.lmr@hotmail.com',
        'name': 'Rodrigo (Dev Mode)',
        'role': 'admin',
        'status': 'active',
        'createdAt': _now,
        'updatedAt': _now,
      }
    ];
  }

  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['userId'] = doc.id;
    data['createdAt'] = _safeTimestampToIsoString(data['createdAt']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchWorkersFromFirestore() async {
  if (isDevMode()) {
    print('⚠️ Usando dados mockados para workers em vez do Firestore');
    return [];
  }

  final snapshot = await FirebaseFirestore.instance.collection('workers').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['uniqueId'] = doc.id;
    data['createdAt'] = _safeTimestampToIsoString(data['createdAt']);
    data['updatedAt'] = _safeTimestampToIsoString(data['updatedAt']);
    return data;
  }).toList();
}

String? _safeTimestampToIsoString(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toIso8601String();
  } else if (value is DateTime) {
    return value.toIso8601String();
  } else if (value is String) {
    return value; // assume already string
  } else {
    return null;
  }
}
