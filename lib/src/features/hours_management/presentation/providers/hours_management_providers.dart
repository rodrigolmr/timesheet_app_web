import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../data/repositories/firestore_hours_management_repository.dart';
import '../../domain/repositories/hours_management_repository.dart';
import '../../data/models/daily_hours_model.dart';
import '../../data/models/user_hours_model.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../../employee/presentation/providers/employee_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../user/domain/enums/user_role.dart';

part 'hours_management_providers.g.dart';

@riverpod
HoursManagementRepository hoursManagementRepository(HoursManagementRepositoryRef ref) {
  return FirestoreHoursManagementRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
class DateRangeSelection extends _$DateRangeSelection {
  @override
  ({DateTime? startDate, DateTime? endDate}) build() {
    // Default to this week (Friday to Thursday)
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    
    DateTime friday;
    if (dayOfWeek == 5) {
      friday = now;
    } else if (dayOfWeek < 5) {
      friday = now.subtract(Duration(days: dayOfWeek + 2));
    } else {
      friday = now.subtract(Duration(days: dayOfWeek - 5));
    }
    
    final fridayDate = DateTime(friday.year, friday.month, friday.day);
    final thursdayDate = fridayDate.add(const Duration(days: 6));
    
    return (startDate: fridayDate, endDate: thursdayDate);
  }

  void updateDateRange(DateTime startDate, DateTime endDate) {
    state = (startDate: startDate, endDate: endDate);
  }
}

@riverpod
Future<List<UserHoursModel>> userDailyHours(UserDailyHoursRef ref) async {
  final dateRange = ref.watch(dateRangeSelectionProvider);
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return [];
  }
  
  if (currentUser == null || currentUser.employeeId == null) {
    return [];
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  return repository.getUserHoursByEmployeeId(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: currentUser.employeeId!,
    userName: '${currentUser.firstName} ${currentUser.lastName}',
  );
}

@riverpod
Future<Map<String, double>> userHoursSummary(UserHoursSummaryRef ref) async {
  final dateRange = ref.watch(dateRangeSelectionProvider);
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  if (currentUser == null || currentUser.employeeId == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  return repository.getHoursSummaryByDateRange(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: currentUser.employeeId!,
  );
}

@riverpod
Future<List<DailyHoursModel>> employeeDailyHours(
  EmployeeDailyHoursRef ref, {
  required String employeeId,
}) async {
  final dateRange = ref.watch(dateRangeSelectionProvider);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return [];
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  return repository.getDailyHoursByDateRange(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: employeeId,
  );
}

@riverpod
Future<Map<String, double>> employeeHoursSummary(
  EmployeeHoursSummaryRef ref, {
  required String employeeId,
}) async {
  final dateRange = ref.watch(dateRangeSelectionProvider);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  return repository.getHoursSummaryByDateRange(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: employeeId,
  );
}

@riverpod
class SelectedEmployee extends _$SelectedEmployee {
  @override
  String? build() => null;
  
  void selectEmployee(String? employeeId) {
    state = employeeId;
  }
}

@riverpod
Future<bool> canViewOtherEmployees(CanViewOtherEmployeesRef ref) async {
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  if (currentUser == null) return false;
  
  return currentUser.userRole == UserRole.admin || currentUser.userRole == UserRole.manager;
}

@riverpod
Future<List<UserHoursModel>> viewingEmployeeHours(ViewingEmployeeHoursRef ref) async {
  final selectedEmployeeId = ref.watch(selectedEmployeeProvider);
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  final canViewOthers = await ref.watch(canViewOtherEmployeesProvider.future);
  
  if (currentUser == null) {
    return [];
  }
  
  // Para admin/manager sem employeeId, eles só podem ver se selecionaram alguém
  if (currentUser.employeeId == null && !canViewOthers) {
    return [];
  }
  
  // Se pode ver outros mas não selecionou ninguém e não tem employeeId próprio
  if (canViewOthers && selectedEmployeeId == null && currentUser.employeeId == null) {
    return [];
  }
  
  final employeeId = (canViewOthers && selectedEmployeeId != null) 
    ? selectedEmployeeId 
    : currentUser.employeeId;
    
  if (employeeId == null) {
    return [];
  }
    
  final dateRange = ref.watch(dateRangeSelectionProvider);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return [];
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  if (selectedEmployeeId != null && canViewOthers) {
    final employee = await ref.watch(employeeProvider(selectedEmployeeId).future);
    if (employee != null) {
      return repository.getUserHoursByEmployeeId(
        startDate: dateRange.startDate!,
        endDate: dateRange.endDate!,
        employeeId: employeeId,
        userName: '${employee.firstName} ${employee.lastName}',
      );
    }
  }
  
  return repository.getUserHoursByEmployeeId(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: employeeId,
    userName: '${currentUser.firstName} ${currentUser.lastName}',
  );
}

@riverpod
Future<Map<String, double>> viewingEmployeeHoursSummary(ViewingEmployeeHoursSummaryRef ref) async {
  final selectedEmployeeId = ref.watch(selectedEmployeeProvider);
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  final canViewOthers = await ref.watch(canViewOtherEmployeesProvider.future);
  
  final dateRange = ref.watch(dateRangeSelectionProvider);
  
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  if (currentUser == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  // Para admin/manager sem employeeId, eles só podem ver se selecionaram alguém
  if (currentUser.employeeId == null && !canViewOthers) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  // Se pode ver outros mas não selecionou ninguém e não tem employeeId próprio
  if (canViewOthers && selectedEmployeeId == null && currentUser.employeeId == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  final employeeId = (canViewOthers && selectedEmployeeId != null) 
    ? selectedEmployeeId 
    : currentUser.employeeId;
    
  if (employeeId == null) {
    return {
      'regularHours': 0.0,
      'travelHours': 0.0,
      'totalHours': 0.0,
    };
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  return repository.getHoursSummaryByDateRange(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: employeeId,
  );
}