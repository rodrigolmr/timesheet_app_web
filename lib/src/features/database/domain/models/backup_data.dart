import 'package:cloud_firestore/cloud_firestore.dart';

class BackupData {
  final String exportDate;
  final Map<String, List<Map<String, dynamic>>> collections;

  BackupData({
    required this.exportDate,
    required this.collections,
  });

  factory BackupData.fromJson(Map<String, dynamic> json) {
    final collections = <String, List<Map<String, dynamic>>>{};
    
    if (json['collections'] != null) {
      (json['collections'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          collections[key] = List<Map<String, dynamic>>.from(
            value.map((item) => Map<String, dynamic>.from(item)),
          );
        }
      });
    }

    return BackupData(
      exportDate: json['exportDate'] ?? '',
      collections: collections,
    );
  }

  List<Map<String, dynamic>> getCollection(String name) {
    return collections[name] ?? [];
  }
}

class OldTimesheetWorker {
  final String name;
  final String start;
  final String finish;
  final String hours;
  final String travel;
  final String meal;

  OldTimesheetWorker({
    required this.name,
    required this.start,
    required this.finish,
    required this.hours,
    required this.travel,
    required this.meal,
  });

  factory OldTimesheetWorker.fromJson(Map<String, dynamic> json) {
    return OldTimesheetWorker(
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      finish: json['finish'] ?? '',
      hours: json['hours'] ?? '0',
      travel: json['travel'] ?? '0',
      meal: json['meal'] ?? '0',
    );
  }
}

class OldTimesheet {
  final String docId;
  final String userId;
  final String jobName;
  final dynamic date;
  final String tm;
  final String jobSize;
  final String material;
  final String jobDesc;
  final String foreman;
  final String vehicle;
  final String notes;
  final List<OldTimesheetWorker> workers;
  final dynamic timestamp;

  OldTimesheet({
    required this.docId,
    required this.userId,
    required this.jobName,
    required this.date,
    required this.tm,
    required this.jobSize,
    required this.material,
    required this.jobDesc,
    required this.foreman,
    required this.vehicle,
    required this.notes,
    required this.workers,
    required this.timestamp,
  });

  factory OldTimesheet.fromJson(Map<String, dynamic> json) {
    final workersList = <OldTimesheetWorker>[];
    if (json['workers'] != null) {
      for (var worker in json['workers']) {
        workersList.add(OldTimesheetWorker.fromJson(worker));
      }
    }

    return OldTimesheet(
      docId: json['docId'] ?? '',
      userId: json['userId'] ?? '',
      jobName: json['jobName'] ?? '',
      date: json['date'],
      tm: json['tm'] ?? '',
      jobSize: json['jobSize'] ?? '',
      material: json['material'] ?? '',
      jobDesc: json['jobDesc'] ?? '',
      foreman: json['foreman'] ?? '',
      vehicle: json['vehicle'] ?? '',
      notes: json['notes'] ?? '',
      workers: workersList,
      timestamp: json['timestamp'],
    );
  }
}

class OldWorker {
  final String uniqueId;
  final String firstName;
  final String lastName;
  final String status;
  final dynamic createdAt;

  OldWorker({
    required this.uniqueId,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.createdAt,
  });

  factory OldWorker.fromJson(Map<String, dynamic> json) {
    return OldWorker(
      uniqueId: json['uniqueId'] ?? json['docId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'] ?? 'inativo',
      createdAt: json['createdAt'],
    );
  }
}

class OldCard {
  final String uniqueId;
  final String cardholderName;
  final String last4Digits;
  final String status;
  final dynamic createdAt;

  OldCard({
    required this.uniqueId,
    required this.cardholderName,
    required this.last4Digits,
    required this.status,
    required this.createdAt,
  });

  factory OldCard.fromJson(Map<String, dynamic> json) {
    return OldCard(
      uniqueId: json['uniqueId'] ?? json['docId'] ?? '',
      cardholderName: json['cardholderName'] ?? '',
      last4Digits: json['last4Digits'] ?? '',
      status: json['status'] ?? 'inativo',
      createdAt: json['createdAt'],
    );
  }
}

class OldUser {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final dynamic createdAt;

  OldUser({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
  });

  factory OldUser.fromJson(Map<String, dynamic> json) {
    return OldUser(
      userId: json['userId'] ?? json['docId'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? 'User',
      createdAt: json['createdAt'],
    );
  }
}

class OldReceipt {
  final String docId;
  final String userId;
  final String cardLast4;
  final dynamic date;
  final String amount;
  final String description;
  final String imageUrl;
  final dynamic timestamp;

  OldReceipt({
    required this.docId,
    required this.userId,
    required this.cardLast4,
    required this.date,
    required this.amount,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
  });

  factory OldReceipt.fromJson(Map<String, dynamic> json) {
    return OldReceipt(
      docId: json['docId'] ?? '',
      userId: json['userId'] ?? '',
      cardLast4: json['cardLast4'] ?? '',
      date: json['date'],
      amount: json['amount'] ?? '0',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}