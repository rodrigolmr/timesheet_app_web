import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class to handle timezone-safe date operations
/// 
/// This class ensures that dates are stored and retrieved consistently
/// across different timezones by using noon (12:00) as the reference time
/// instead of midnight (00:00).
class TimezoneSafeDate {
  /// Converts a date to a timezone-safe format for storage
  /// 
  /// Uses noon (12:00) instead of midnight to prevent date changes
  /// when converting between timezones.
  /// 
  /// Example:
  /// - Input: 2024-01-15 (any time)
  /// - Output: 2024-01-15 12:00:00
  static DateTime toSafeDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      12, // Noon instead of midnight
      0,
      0,
    );
  }

  /// Converts a Firestore Timestamp to a timezone-safe date
  /// 
  /// Normalizes the date to ensure consistent display across timezones
  static DateTime fromTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    // Return just the date part, ignoring time
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  /// Creates a Firestore Timestamp from a date using noon as reference
  /// 
  /// This ensures the date won't change when viewed in different timezones
  static Timestamp toTimestamp(DateTime date) {
    return Timestamp.fromDate(toSafeDate(date));
  }

  /// Checks if two dates are the same day, ignoring time and timezone
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Gets the start of day (midnight) in local timezone
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end of day (23:59:59) in local timezone
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}