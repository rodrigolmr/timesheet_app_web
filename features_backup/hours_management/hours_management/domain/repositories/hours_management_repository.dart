import '../../../hours_management/data/models/daily_hours_model.dart';
import '../../../hours_management/data/models/user_hours_model.dart';

abstract class HoursManagementRepository {
  Future<List<DailyHoursModel>> getDailyHoursByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? employeeId,
    String? userId,
  });
  
  Future<Map<String, double>> getHoursSummaryByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? employeeId,
    String? userId,
  });
  
  Future<List<UserHoursModel>> getUserHoursByEmployeeId({
    required DateTime startDate,
    required DateTime endDate,
    required String employeeId,
    String? userName,
  });
}