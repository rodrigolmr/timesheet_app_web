import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchCardsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('cards').get();
  return snapshot.docs.map((doc) => doc.data()..['uniqueId'] = doc.id).toList();
}

Future<List<Map<String, dynamic>>> fetchReceiptsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('receipts').get();
  return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
}

Future<List<Map<String, dynamic>>> fetchDraftsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('timesheet_drafts').get();
  return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
}

Future<List<Map<String, dynamic>>> fetchTimesheetsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('timesheets').get();
  return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
}

Future<List<Map<String, dynamic>>> fetchUsersFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  return snapshot.docs.map((doc) => doc.data()..['userId'] = doc.id).toList();
}

Future<List<Map<String, dynamic>>> fetchWorkersFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('workers').get();
  return snapshot.docs.map((doc) => doc.data()..['uniqueId'] = doc.id).toList();
}