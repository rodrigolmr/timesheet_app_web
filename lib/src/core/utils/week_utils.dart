import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

/// Utility class for week-based date operations
/// Implements Friday-to-Thursday week structure
class WeekUtils {
  /// Get unique week identifier for a given date
  /// Week starts on Friday and ends on Thursday
  static String getWeekId(DateTime date) {
    // Determine the Friday of the current week
    DateTime fridayOfWeek;
    
    // Day of the week: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
    final dayOfWeek = date.weekday;
    
    if (dayOfWeek == 5) { // Is Friday
      fridayOfWeek = date; // The date itself is Friday
    } else if (dayOfWeek < 5) { // Is Monday to Thursday
      // Go back to the previous Friday
      fridayOfWeek = date.subtract(Duration(days: dayOfWeek + 2));
    } else { // Is Saturday or Sunday
      // Go back to the most recent Friday
      fridayOfWeek = date.subtract(Duration(days: dayOfWeek - 5));
    }
    
    // Create unique ID based on year and day of year of Friday
    final dayOfYear = getDayOfYear(fridayOfWeek);
    final weekNumber = ((dayOfYear - 1) / 7).floor() + 1;
    
    // Format as YYYYWW (year+week)
    return '${fridayOfWeek.year}${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Calculate the day of the year (1-366)
  static int getDayOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    return date.difference(startOfYear).inDays + 1;
  }

  /// Get the start date (Friday) of a week based on week ID
  static DateTime getWeekStartDateFromId(String weekId) {
    // Extract year and week number from ID
    final year = int.parse(weekId.substring(0, 4));
    final weekNumber = int.parse(weekId.substring(4));
    
    // First day of the year
    final firstDayOfYear = DateTime(year, 1, 1);
    
    // Find the first Friday of the year
    final firstDayWeekday = firstDayOfYear.weekday;
    final daysUntilFirstFriday = (5 - firstDayWeekday + 7) % 7; // 5 = Friday
    final firstFriday = firstDayOfYear.add(Duration(days: daysUntilFirstFriday));
    
    // Add the remaining weeks (n-1 weeks)
    return firstFriday.add(Duration(days: (weekNumber - 1) * 7));
  }

  /// Group job records by week
  static List<WeekGroup> groupRecordsByWeek(List<JobRecordModel> records) {
    // Map to group records by week ID
    final Map<String, List<JobRecordModel>> groupedByWeekId = {};
    
    // Group records by week ID
    for (final record in records) {
      final weekId = getWeekId(record.date);
      
      if (!groupedByWeekId.containsKey(weekId)) {
        groupedByWeekId[weekId] = [];
      }
      
      groupedByWeekId[weekId]!.add(record);
    }
    
    // Convert to list of WeekGroup
    final List<WeekGroup> result = [];
    for (final weekId in groupedByWeekId.keys) {
      // Get week start date from ID
      final startDate = getWeekStartDateFromId(weekId);
      
      // Sort records within the week by date (most recent first)
      final weekRecords = groupedByWeekId[weekId]!;
      weekRecords.sort((a, b) => b.date.compareTo(a.date));
      
      // Add to result list
      result.add(WeekGroup(weekId, startDate, weekRecords));
    }
    
    // Sort weeks (most recent first)
    result.sort((a, b) => b.startDate.compareTo(a.startDate));
    
    return result;
  }
}

/// Class to represent a week with records
class WeekGroup {
  final String weekId;
  final DateTime startDate; // Friday
  final DateTime endDate;   // Thursday
  final List<JobRecordModel> records;
  
  WeekGroup(this.weekId, this.startDate, this.records)
      : endDate = startDate.add(const Duration(days: 6));
      
  String get weekRange {
    final dateFormat = DateFormat('MMM d');
    return '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
  }
  
  String get weekTitle {
    final now = DateTime.now();
    final thisWeekId = WeekUtils.getWeekId(now);
    final lastWeekId = WeekUtils.getWeekId(now.subtract(const Duration(days: 7)));
    
    if (weekId == thisWeekId) {
      return 'This Week';
    } else if (weekId == lastWeekId) {
      return 'Last Week';
    } else {
      // More compact format to save space
      return 'Week ${startDate.day}-${endDate.day} ${DateFormat('MMM').format(startDate)}';
    }
  }
}