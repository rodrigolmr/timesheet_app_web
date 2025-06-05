import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/input/app_date_range_picker_field.dart';
import '../../../../core/widgets/input/app_dropdown_field.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/utils/week_utils.dart';
import '../providers/hours_management_providers.dart';
import '../../data/models/user_hours_model.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../../user/data/models/user_model.dart';
import '../../../employee/presentation/providers/employee_providers.dart';
import '../../../employee/data/models/employee_model.dart';

class HoursManagementScreen extends ConsumerWidget {
  const HoursManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final dateRange = ref.watch(dateRangeSelectionProvider);
    final canViewOthersAsync = ref.watch(canViewOtherEmployeesProvider);
    final selectedEmployeeId = ref.watch(selectedEmployeeProvider);
    final dailyHoursAsync = ref.watch(viewingEmployeeHoursProvider);
    final hoursSummaryAsync = ref.watch(viewingEmployeeHoursSummaryProvider);

    String subtitle = 'Track and analyze work hours';
    if (currentUserAsync.valueOrNull != null) {
      final user = currentUserAsync.valueOrNull!;
      subtitle = '${user.firstName} ${user.lastName}';
      
      if (canViewOthersAsync.valueOrNull == true && selectedEmployeeId != null) {
        final selectedEmployeeAsync = ref.watch(employeeProvider(selectedEmployeeId));
        if (selectedEmployeeAsync.valueOrNull != null) {
          final employee = selectedEmployeeAsync.valueOrNull!;
          subtitle = '${employee.firstName} ${employee.lastName}';
        }
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: 'Hours Management',
        subtitle: subtitle,
        showBackButton: true,
      ),
      body: currentUserAsync.when(
        data: (user) {
          // Admin e Manager podem ver horas mesmo sem employeeId
          if (user == null) {
            return _buildNoEmployeeState(context);
          }
          
          // Se não é admin/manager e não tem employeeId, mostra estado vazio
          if (user.employeeId == null && !user.isAdmin && !user.isManager) {
            return _buildNoEmployeeState(context);
          }
          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, ref, dateRange, dailyHoursAsync, hoursSummaryAsync, canViewOthersAsync),
            desktop: _buildDesktopLayout(context, ref, dateRange, dailyHoursAsync, hoursSummaryAsync, canViewOthersAsync),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading user profile: $error',
            style: context.textStyles.body.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    ({DateTime? startDate, DateTime? endDate}) dateRange,
    AsyncValue<List<UserHoursModel>> dailyHoursAsync,
    AsyncValue<Map<String, double>> hoursSummaryAsync,
    AsyncValue<bool> canViewOthersAsync,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canViewOthersAsync.valueOrNull == true) ...[
            _buildEmployeeSelector(context, ref),
            SizedBox(height: context.dimensions.spacingL),
          ],
          _buildDateSelector(context, ref, dateRange),
          SizedBox(height: context.dimensions.spacingL),
          _buildSummaryCard(context, hoursSummaryAsync),
          SizedBox(height: context.dimensions.spacingL),
          _buildDailyHoursList(context, ref, dailyHoursAsync),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    ({DateTime? startDate, DateTime? endDate}) dateRange,
    AsyncValue<List<UserHoursModel>> dailyHoursAsync,
    AsyncValue<Map<String, double>> hoursSummaryAsync,
    AsyncValue<bool> canViewOthersAsync,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Date selector and summary
        SizedBox(
          width: 400,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (canViewOthersAsync.valueOrNull == true) ...[
                  _buildEmployeeSelector(context, ref),
                  SizedBox(height: context.dimensions.spacingL),
                ],
                _buildDateSelector(context, ref, dateRange),
                SizedBox(height: context.dimensions.spacingL),
                _buildSummaryCard(context, hoursSummaryAsync),
              ],
            ),
          ),
        ),
        // Right side - Daily hours list
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: _buildDailyHoursList(context, ref, dailyHoursAsync),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    WidgetRef ref,
    ({DateTime? startDate, DateTime? endDate}) dateRange,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        side: BorderSide(
          color: context.colors.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Date Range',
              style: context.textStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.dimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectThisWeek(ref),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.colors.primary.withOpacity(0.5)),
                      padding: EdgeInsets.symmetric(
                        vertical: context.dimensions.spacingS,
                      ),
                    ),
                    child: Text('This Week'),
                  ),
                ),
                SizedBox(width: context.dimensions.spacingS),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectLastWeek(ref),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.colors.primary.withOpacity(0.5)),
                      padding: EdgeInsets.symmetric(
                        vertical: context.dimensions.spacingS,
                      ),
                    ),
                    child: Text('Last Week'),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppDateRangePickerField(
              label: 'Period',
              hintText: 'Select date range',
              initialDateRange: dateRange.startDate != null && dateRange.endDate != null
                  ? DateTimeRange(
                      start: dateRange.startDate!,
                      end: dateRange.endDate!,
                    )
                  : null,
              onDateRangeSelected: (range) {
                if (range != null) {
                  ref.read(dateRangeSelectionProvider.notifier)
                      .updateDateRange(range.start, range.end);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AsyncValue<Map<String, double>> hoursSummaryAsync,
  ) {
    return hoursSummaryAsync.when(
      data: (summary) {
        final totalHours = summary['regularHours'] ?? 0.0; // Only regular hours count as total
        final travelHours = summary['travelHours'] ?? 0.0;
        
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
            side: BorderSide(
              color: context.colors.primary.withOpacity(0.3),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
            ),
            padding: EdgeInsets.all(context.dimensions.spacingL),
            child: Column(
              children: [
                Icon(
                  Icons.access_time,
                  size: 48,
                  color: context.colors.primary,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Text(
                  'Total Hours',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  totalHours.toStringAsFixed(2),
                  style: context.textStyles.headline.copyWith(
                    color: context.colors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (travelHours > 0) ...[
                  SizedBox(height: context.dimensions.spacingS),
                  Text(
                    '+ ${travelHours.toStringAsFixed(2)} travel hours',
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          side: BorderSide(
            color: context.colors.outline.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, _) => Card(
        color: context.colors.error.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          child: Text(
            'Error loading summary: $error',
            style: context.textStyles.body.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyHoursList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<UserHoursModel>> dailyHoursAsync,
  ) {
    final dateRange = ref.watch(dateRangeSelectionProvider);
    
    return dailyHoursAsync.when(
      data: (dailyHours) {
        if (dateRange.startDate == null || dateRange.endDate == null) {
          return _buildNoDateSelectedState(context);
        }
        if (dailyHours.isEmpty) {
          return _buildEmptyState(context);
        }

        // Check if any day has travel hours to show travel column
        final hasAnyTravel = dailyHours.any((daily) => daily.travelHours > 0);

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
            side: BorderSide(
              color: context.colors.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(context.dimensions.borderRadiusM),
                    topRight: Radius.circular(context.dimensions.borderRadiusM),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.onSurface.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (hasAnyTravel) ...[
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Travel',
                          style: context.textStyles.subtitle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(width: context.dimensions.spacingM),
                    ],
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Hours',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Daily rows
              ...dailyHours.map((daily) => _buildDailyRow(context, daily, hasAnyTravel)),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error loading daily hours: $error',
          style: context.textStyles.body.copyWith(
            color: context.colors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyRow(BuildContext context, UserHoursModel daily, bool hasAnyTravel) {
    final dateFormat = DateFormat('EEE, MMM d');
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingM,
        vertical: context.dimensions.spacingM,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.onSurface.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dateFormat.format(daily.date),
              style: context.textStyles.body,
            ),
          ),
          if (hasAnyTravel) ...[
            SizedBox(
              width: 80,
              child: Text(
                daily.travelHours > 0 ? daily.travelHours.toStringAsFixed(2) : '-',
                style: context.textStyles.body.copyWith(
                  color: daily.travelHours > 0 
                      ? context.colors.textSecondary 
                      : context.colors.textSecondary.withOpacity(0.3),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: context.dimensions.spacingM),
          ],
          SizedBox(
            width: 60,
            child: Text(
              daily.regularHours.toStringAsFixed(2),
              style: context.textStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'No hours recorded',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimensions.spacingS),
          Text(
            'No work hours found for the selected period',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDateSelectedState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'Select a date range',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimensions.spacingS),
          Text(
            'Please select a date range to view hours',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoEmployeeState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 120,
              color: context.colors.textSecondary.withOpacity(0.3),
            ),
            SizedBox(height: context.dimensions.spacingL),
            Text(
              'No Employee Profile',
              style: context.textStyles.title.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimensions.spacingS),
            Text(
              'Your user account is not associated with an employee profile.',
              style: context.textStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Please contact your administrator to link your account.',
              style: context.textStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectThisWeek(WidgetRef ref) {
    final now = DateTime.now();
    
    // Calculate the Friday of current week
    DateTime friday;
    final dayOfWeek = now.weekday;
    
    if (dayOfWeek == 5) { // Is Friday
      friday = now;
    } else if (dayOfWeek < 5) { // Monday to Thursday
      // Go back to the previous Friday
      friday = now.subtract(Duration(days: dayOfWeek + 2));
    } else { // Saturday or Sunday
      // Go back to the most recent Friday
      friday = now.subtract(Duration(days: dayOfWeek - 5));
    }
    
    // Create dates with only year, month, day (no time)
    final fridayDate = DateTime(friday.year, friday.month, friday.day);
    final thursdayDate = fridayDate.add(const Duration(days: 6));
    
    ref.read(dateRangeSelectionProvider.notifier)
        .updateDateRange(fridayDate, thursdayDate);
  }
  
  void _selectLastWeek(WidgetRef ref) {
    final now = DateTime.now();
    
    // Calculate the Friday of current week first
    DateTime currentFriday;
    final dayOfWeek = now.weekday;
    
    if (dayOfWeek == 5) { // Is Friday
      currentFriday = now;
    } else if (dayOfWeek < 5) { // Monday to Thursday
      // Go back to the previous Friday
      currentFriday = now.subtract(Duration(days: dayOfWeek + 2));
    } else { // Saturday or Sunday
      // Go back to the most recent Friday
      currentFriday = now.subtract(Duration(days: dayOfWeek - 5));
    }
    
    // Last week's Friday is 7 days before current week's Friday
    final lastFriday = currentFriday.subtract(const Duration(days: 7));
    
    // Create dates with only year, month, day (no time)
    final lastFridayDate = DateTime(lastFriday.year, lastFriday.month, lastFriday.day);
    final lastThursdayDate = lastFridayDate.add(const Duration(days: 6));
    
    ref.read(dateRangeSelectionProvider.notifier)
        .updateDateRange(lastFridayDate, lastThursdayDate);
  }

  Widget _buildEmployeeSelector(
    BuildContext context,
    WidgetRef ref,
  ) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final selectedEmployeeId = ref.watch(selectedEmployeeProvider);
    final employeesAsync = ref.watch(activeEmployeesProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        side: BorderSide(
          color: context.colors.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Employee',
              style: context.textStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.dimensions.spacingM),
            employeesAsync.when(
              data: (employees) {
                final allEmployees = [
                  null, // Representa "My Hours"
                  ...employees,
                ];

                return AppDropdownField<EmployeeModel?>(
                  label: 'Employee',
                  hintText: 'Select an employee',
                  value: selectedEmployeeId != null 
                      ? employees.firstWhere((e) => e.id == selectedEmployeeId, orElse: () => employees.first)
                      : null,
                  items: allEmployees,
                  itemLabelBuilder: (employee) {
                    if (employee == null) {
                      return currentUserAsync.valueOrNull != null
                          ? 'My Hours (${currentUserAsync.valueOrNull!.firstName} ${currentUserAsync.valueOrNull!.lastName})'
                          : 'My Hours';
                    }
                    return '${employee.firstName} ${employee.lastName}';
                  },
                  onChanged: (employee) {
                    ref.read(selectedEmployeeProvider.notifier).selectEmployee(employee?.id);
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(
                'Error loading employees: $error',
                style: context.textStyles.body.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}