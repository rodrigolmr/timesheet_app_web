import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:timesheet_app_web/src/core/config/build_config.dart';

class UpdateCheckService {
  static const String _versionKey = 'app_version';
  static const String _buildKey = 'app_build';
  
  /// Check if there's a new version available
  static Future<bool> checkForUpdates() async {
    if (!kIsWeb) return false;
    
    try {
      // First try to check service worker
      final swCheck = await _checkServiceWorker();
      if (swCheck) return true;
      
      // Then check version file
      final versionCheck = await _checkVersionFile();
      return versionCheck;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }
  
  /// Check service worker for updates
  static Future<bool> _checkServiceWorker() async {
    try {
      if (html.window.navigator.serviceWorker != null) {
        final registration = await html.window.navigator.serviceWorker!.ready;
        
        // Force update check
        await registration.update();
        
        // Check if there's a waiting service worker
        if (registration.waiting != null) {
          debugPrint('Service worker update available');
          return true;
        }
        
        // Check if installing
        if (registration.installing != null) {
          debugPrint('Service worker installing');
          return true;
        }
      }
    } catch (e) {
      debugPrint('Service worker check error: $e');
    }
    return false;
  }
  
  /// Check version by fetching a version file
  static Future<bool> _checkVersionFile() async {
    try {
      // Get current version from BuildConfig
      final currentVersion = BuildConfig.version;
      final currentBuild = BuildConfig.buildNumber;
      
      // Fetch version.json with cache busting
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await html.HttpRequest.getString(
        '/version.json?_t=$timestamp',
      );
      
      // Parse JSON response
      final versionData = json.decode(response);
      final remoteVersion = versionData['version'] as String?;
      final remoteBuild = versionData['buildNumber'] as String?;
      
      debugPrint('Current: v$currentVersion+$currentBuild');
      debugPrint('Remote: v$remoteVersion+$remoteBuild');
      
      if (remoteVersion != null && remoteBuild != null) {
        // Compare versions
        if (remoteVersion != currentVersion || 
            int.parse(remoteBuild) > int.parse(currentBuild)) {
          debugPrint('Update available!');
          return true;
        }
      }
      
      return false;
    } catch (e) {
      debugPrint('Version check failed: $e');
      return false;
    }
  }
  
  /// Force refresh the application
  static void forceRefresh() {
    if (kIsWeb) {
      // Always redirect to home page before reload to avoid access denied issues
      html.window.location.href = '/';
    }
  }
  
  /// Skip waiting service worker and activate immediately
  static Future<void> skipWaitingAndReload() async {
    if (!kIsWeb) return;
    
    // Always redirect to home page before reload to avoid access denied issues
    html.window.location.href = '/';
  }
}