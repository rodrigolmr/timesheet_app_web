/// Build configuration with deployment information
class BuildConfig {
  /// Current build version (should match pubspec.yaml)
  static const String version = '1.0.3';
  
  /// Build number
  static const String buildNumber = '35';
  
  /// Build timestamp - UPDATE THIS BEFORE EACH DEPLOYMENT
  /// Format: yyyy-MM-dd HH:mm:ss
  static const String buildTimestamp = '2025-11-20 15:43:58';
  
  /// Build environment
  static const String environment = 'production';
  
  /// Git commit hash (optional - can be updated during CI/CD)
  static const String commitHash = 'latest';
  
  /// Get formatted build info
  static String get buildInfo => 'v$version+$buildNumber';
  
  /// Get formatted build date
  static DateTime get buildDate {
    try {
      return DateTime.parse(buildTimestamp);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  /// Check if this is a development build
  static bool get isDevelopment => environment == 'development';
  
  /// Check if this is a production build
  static bool get isProduction => environment == 'production';
}