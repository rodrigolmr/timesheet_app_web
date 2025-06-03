import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/repositories/firestore_repository.dart';
import '../../../job_record/data/models/job_record_model.dart';
import '../../domain/repositories/hours_management_repository.dart';
import '../models/daily_hours_model.dart';
import '../models/user_hours_model.dart';

class FirestoreHoursManagementRepository implements HoursManagementRepository {
  final FirebaseFirestore firestore;

  FirestoreHoursManagementRepository({required this.firestore});

  @override
  Future<List<DailyHoursModel>> getDailyHoursByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? employeeId,
    String? userId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection('job_records');
      
      // Filter by date range
      query = query
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      
      // Filter by userId if provided (for regular users)
      if (userId != null) {
        query = query.where('user_id', isEqualTo: userId);
      }
      
      final querySnapshot = await query.get();
      final jobRecords = querySnapshot.docs
          .map((doc) => JobRecordModel.fromFirestore(doc))
          .toList();

      // Process job records to get daily hours
      final Map<String, Map<String, dynamic>> dailyHoursMap = {};

      for (final jobRecord in jobRecords) {
        for (final employee in jobRecord.employees) {
          // Skip if employeeId is specified and doesn't match
          if (employeeId != null && employee.employeeId != employeeId) {
            continue;
          }

          final dateKey = _getDateKey(jobRecord.date);
          final employeeKey = employee.employeeId;

          if (!dailyHoursMap.containsKey(dateKey)) {
            dailyHoursMap[dateKey] = {};
          }

          if (!dailyHoursMap[dateKey]!.containsKey(employeeKey)) {
            dailyHoursMap[dateKey]![employeeKey] = {
              'date': jobRecord.date,
              'employeeId': employee.employeeId,
              'employeeName': employee.employeeName,
              'regularHours': 0.0,
              'travelHours': 0.0,
              'jobRecords': <JobRecordSummary>[],
            };
          }

          dailyHoursMap[dateKey]![employeeKey]['regularHours'] += employee.hours;
          dailyHoursMap[dateKey]![employeeKey]['travelHours'] += employee.travelHours;
          
          (dailyHoursMap[dateKey]![employeeKey]['jobRecords'] as List<JobRecordSummary>)
              .add(JobRecordSummary(
            jobRecordId: jobRecord.id,
            jobName: jobRecord.jobName,
            regularHours: employee.hours,
            travelHours: employee.travelHours,
          ));
        }
      }

      // Convert map to list of DailyHoursModel
      final List<DailyHoursModel> dailyHoursList = [];
      
      dailyHoursMap.forEach((dateKey, employeeMap) {
        employeeMap.forEach((employeeKey, data) {
          dailyHoursList.add(DailyHoursModel(
            date: data['date'] as DateTime,
            employeeId: data['employeeId'] as String,
            employeeName: data['employeeName'] as String,
            regularHours: data['regularHours'] as double,
            travelHours: data['travelHours'] as double,
            totalHours: (data['regularHours'] as double) + (data['travelHours'] as double),
            jobRecords: data['jobRecords'] as List<JobRecordSummary>,
          ));
        });
      });

      // Sort by date
      dailyHoursList.sort((a, b) => a.date.compareTo(b.date));

      return dailyHoursList;
    } catch (e) {
      throw Exception('Failed to get daily hours: $e');
    }
  }

  @override
  Future<Map<String, double>> getHoursSummaryByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? employeeId,
    String? userId,
  }) async {
    final dailyHours = await getDailyHoursByDateRange(
      startDate: startDate,
      endDate: endDate,
      employeeId: employeeId,
      userId: userId,
    );

    double totalRegularHours = 0;
    double totalTravelHours = 0;
    double totalHours = 0;

    for (final daily in dailyHours) {
      totalRegularHours += daily.regularHours;
      totalTravelHours += daily.travelHours;
      totalHours += daily.totalHours;
    }

    return {
      'regularHours': totalRegularHours,
      'travelHours': totalTravelHours,
      'totalHours': totalHours,
    };
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<UserHoursModel>> getUserHoursByEmployeeId({
    required DateTime startDate,
    required DateTime endDate,
    required String employeeId,
    String? userName,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection('job_records');
      
      // Filter by date range only
      query = query
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      
      final querySnapshot = await query.get();
      final jobRecords = querySnapshot.docs
          .map((doc) => JobRecordModel.fromFirestore(doc))
          .toList();
      
      // Filter job records that contain the employeeId
      final filteredJobRecords = jobRecords.where((record) => 
        record.employees.any((emp) => emp.employeeId == employeeId)
      ).toList();

      // Group by date
      final Map<String, List<JobRecordModel>> recordsByDate = {};
      
      for (final jobRecord in filteredJobRecords) {
        final dateKey = _getDateKey(jobRecord.date);
        if (!recordsByDate.containsKey(dateKey)) {
          recordsByDate[dateKey] = [];
        }
        recordsByDate[dateKey]!.add(jobRecord);
      }

      // Convert to UserHoursModel
      final List<UserHoursModel> userHoursList = [];
      
      recordsByDate.forEach((dateKey, records) {
        double totalRegularHours = 0;
        double totalTravelHours = 0;
        final List<JobRecordDetail> jobDetails = [];
        
        for (final record in records) {
          final List<EmployeeHours> employeeHoursList = [];
          double jobRegularHours = 0;
          double jobTravelHours = 0;
          
          // Only include the specific employee's hours
          for (final employee in record.employees) {
            if (employee.employeeId == employeeId) {
              employeeHoursList.add(EmployeeHours(
                employeeId: employee.employeeId,
                employeeName: employee.employeeName,
                regularHours: employee.hours,
                travelHours: employee.travelHours,
              ));
              jobRegularHours += employee.hours;
              jobTravelHours += employee.travelHours;
            }
          }
          
          totalRegularHours += jobRegularHours;
          totalTravelHours += jobTravelHours;
          
          jobDetails.add(JobRecordDetail(
            jobRecordId: record.id,
            jobName: record.jobName,
            employeeHours: employeeHoursList,
            totalRegularHours: jobRegularHours,
            totalTravelHours: jobTravelHours,
          ));
        }
        
        userHoursList.add(UserHoursModel(
          date: records.first.date,
          userId: employeeId, // Using employeeId as userId for now
          userName: userName ?? 'User',
          regularHours: totalRegularHours,
          travelHours: totalTravelHours,
          totalHours: totalRegularHours + totalTravelHours,
          jobRecords: jobDetails,
        ));
      });

      // Sort by date
      userHoursList.sort((a, b) => a.date.compareTo(b.date));

      return userHoursList;
    } catch (e) {
      throw Exception('Failed to get user hours: $e');
    }
  }
}