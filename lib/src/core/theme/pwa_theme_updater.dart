import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class PwaThemeUpdater {
  static void updateThemeColor(String hexColor) {
    if (kIsWeb) {
      try {
        // Direct DOM manipulation - most reliable method
        final metaTag = html.document.querySelector('meta[name="theme-color"]');
        if (metaTag != null && metaTag is html.MetaElement) {
          metaTag.content = hexColor;
        }
        
        // Also try to call the JavaScript function if available
        try {
          js.context.callMethod('updateThemeColor', [hexColor]);
        } catch (e) {
          // Ignore if method doesn't exist
        }
      } catch (e) {
        print('Error updating PWA theme color: $e');
      }
    }
  }
}