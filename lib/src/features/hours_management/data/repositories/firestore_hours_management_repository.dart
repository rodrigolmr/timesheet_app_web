import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/hours_management_repository.dart';
import '../models/daily_hours_model.dart';
import '../models/user_hours_model.dart';
import '../../../job_record/data/models/job_record_model.dart';

class FirestoreHoursManagementRepository implements HoursManagementRepository {
  final FirebaseFirestore _firestore;

  FirestoreHoursManagementRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<List<DailyHoursModel>> getDailyHoursByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? employeeId,
    String? userId,
  }) async {
    try {
      // Adjust endDate to include the entire last day (23:59:59.999)
      final adjustedEndDate = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
        999,
      );
      
      Query<Map<String, dynamic>> query = _firestore.collection('job_records')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(adjustedEndDate));

      if (userId != null) {
        query = query.where('user_id', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      final jobRecords = querySnapshot.docs
          .map((doc) => JobRecordModel.fromFirestore(doc))
          .toList();

      // Group by date and employee
      final Map<String, Map<String, List<JobRecordSummary>>> groupedData = {};
      
      for (final record in jobRecords) {
        final dateKey = _getDateKey(record.date);
        
        for (final employee in record.employees) {
          if (employeeId != null && employee.employeeId != employeeId) {
            continue;
          }
          
          final employeeKey = '${employee.employeeId}_${employee.employeeName}';
          
          groupedData[dateKey] ??= {};
          groupedData[dateKey]![employeeKey] ??= [];
          
          groupedData[dateKey]![employeeKey]!.add(
            JobRecordSummary(
              jobRecordId: record.id,
              jobName: record.jobName,
              regularHours: employee.hours,
              travelHours: employee.travelHours,
            ),
          );
        }
      }
      
      // Convert to DailyHoursModel list
      final List<DailyHoursModel> dailyHoursList = [];
      
      groupedData.forEach((dateKey, employeeData) {
        employeeData.forEach((employeeKey, jobRecords) {
          final parts = employeeKey.split('_');
          final empId = parts[0];
          final empName = parts.sublist(1).join('_');
          
          double totalRegular = 0;
          double totalTravel = 0;
          
          for (final job in jobRecords) {
            totalRegular += job.regularHours;
            totalTravel += job.travelHours;
          }
          
          dailyHoursList.add(
            DailyHoursModel(
              date: DateTime.parse(dateKey),
              employeeId: empId,
              employeeName: empName,
              regularHours: totalRegular,
              travelHours: totalTravel,
              totalHours: totalRegular + totalTravel,
              jobRecords: jobRecords,
            ),
          );
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
    try {
      final dailyHours = await getDailyHoursByDateRange(
        startDate: startDate,
        endDate: endDate,
        employeeId: employeeId,
        userId: userId,
      );
      
      double totalRegular = 0;
      double totalTravel = 0;
      
      for (final daily in dailyHours) {
        totalRegular += daily.regularHours;
        totalTravel += daily.travelHours;
      }
      
      return {
        'regularHours': totalRegular,
        'travelHours': totalTravel,
        'totalHours': totalRegular + totalTravel,
      };
    } catch (e) {
      throw Exception('Failed to get hours summary: $e');
    }
  }

  @override
  Future<List<UserHoursModel>> getUserHoursByEmployeeId({
    required DateTime startDate,
    required DateTime endDate,
    required String employeeId,
    String? userName,
  }) async {
    try {
      // Adjust endDate to include the entire last day (23:59:59.999)
      final adjustedEndDate = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
        999,
      );
      
      Query<Map<String, dynamic>> query = _firestore.collection('job_records')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(adjustedEndDate));

      final querySnapshot = await query.get();
      final jobRecords = querySnapshot.docs
          .map((doc) => JobRecordModel.fromFirestore(doc))
          .toList();

      // Filter records that contain the employee
      final relevantRecords = jobRecords.where((record) =>
          record.employees.any((emp) => emp.employeeId == employeeId)).toList();

      // Group by date
      final Map<String, List<JobRecordDetail>> groupedByDate = {};
      
      for (final record in relevantRecords) {
        final dateKey = _getDateKey(record.date);
        
        // Get employee hours for this specific employee
        final employeeData = record.employees.firstWhere(
          (emp) => emp.employeeId == employeeId,
          orElse: () => throw Exception('Employee not found in record'),
        );
        
        // Convert all employees in this job record to EmployeeHours
        final employeeHoursList = record.employees.map((emp) => 
          EmployeeHours(
            employeeId: emp.employeeId,
            employeeName: emp.employeeName,
            regularHours: emp.hours,
            travelHours: emp.travelHours,
          ),
        ).toList();
        
        // Calculate totals for this job record
        double totalRegular = 0;
        double totalTravel = 0;
        for (final emp in record.employees) {
          totalRegular += emp.hours;
          totalTravel += emp.travelHours;
        }
        
        groupedByDate[dateKey] ??= [];
        groupedByDate[dateKey]!.add(
          JobRecordDetail(
            jobRecordId: record.id,
            jobName: record.jobName,
            employeeHours: employeeHoursList,
            totalRegularHours: totalRegular,
            totalTravelHours: totalTravel,
          ),
        );
      }
      
      // Convert to UserHoursModel list
      final List<UserHoursModel> userHoursList = [];
      
      groupedByDate.forEach((dateKey, jobRecords) {
        double dayRegular = 0;
        double dayTravel = 0;
        
        // Calculate only this employee's hours for the day
        for (final job in jobRecords) {
          final empHours = job.employeeHours.firstWhere(
            (emp) => emp.employeeId == employeeId,
            orElse: () => const EmployeeHours(
              employeeId: '',
              employeeName: '',
              regularHours: 0,
              travelHours: 0,
            ),
          );
          dayRegular += empHours.regularHours;
          dayTravel += empHours.travelHours;
        }
        
        userHoursList.add(
          UserHoursModel(
            date: DateTime.parse(dateKey),
            userId: userName ?? employeeId,
            userName: userName ?? employeeId,
            regularHours: dayRegular,
            travelHours: dayTravel,
            totalHours: dayRegular + dayTravel,
            jobRecords: jobRecords,
          ),
        );
      });
      
      // Sort by date
      userHoursList.sort((a, b) => a.date.compareTo(b.date));
      
      return userHoursList;
    } catch (e) {
      throw Exception('Failed to get user hours: $e');
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}