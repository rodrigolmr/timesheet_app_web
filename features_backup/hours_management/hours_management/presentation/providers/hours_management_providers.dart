import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../data/models/daily_hours_model.dart';
import '../../data/models/user_hours_model.dart';
import '../../data/repositories/firestore_hours_management_repository.dart';
import '../../domain/repositories/hours_management_repository.dart';

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
    return (startDate: null, endDate: null);
  }

  void updateDateRange(DateTime startDate, DateTime endDate) {
    state = (startDate: startDate, endDate: endDate);
  }
  
  void clearDateRange() {
    state = (startDate: null, endDate: null);
  }
}

@riverpod
Future<List<UserHoursModel>> userDailyHours(UserDailyHoursRef ref) async {
  final dateRange = ref.watch(dateRangeSelectionProvider);
  final currentUser = await ref.watch(currentUserProfileProvider.future);
  
  if (currentUser == null) return [];
  
  // Check if user has an associated employeeId
  if (currentUser.employeeId == null) {
    return []; // User is not associated with any employee
  }
  
  // If no date range is selected, return empty list
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return [];
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  // Get hours for the employee associated with the current user
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
  
  if (currentUser == null || currentUser.employeeId == null) {
    return {
      'regularHours': 0,
      'travelHours': 0,
      'totalHours': 0,
    };
  }
  
  // If no date range is selected, return zeros
  if (dateRange.startDate == null || dateRange.endDate == null) {
    return {
      'regularHours': 0,
      'travelHours': 0,
      'totalHours': 0,
    };
  }
  
  final repository = ref.watch(hoursManagementRepositoryProvider);
  
  // Get the daily hours and calculate summary
  final dailyHours = await repository.getUserHoursByEmployeeId(
    startDate: dateRange.startDate!,
    endDate: dateRange.endDate!,
    employeeId: currentUser.employeeId!,
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