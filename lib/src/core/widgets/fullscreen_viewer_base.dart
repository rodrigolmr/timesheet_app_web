import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

class FullscreenViewerBase extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClose;

  const FullscreenViewerBase({
    super.key,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background - clickable to close
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ),
          
          // Content area with header space
          Positioned.fill(
            child: Column(
              children: [
                // Header area with close button
                Container(
                  height: 80,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: onClose ?? () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content area with responsive padding
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: context.isMobile ? 8.0 : 24.0,
                      right: context.isMobile ? 8.0 : 24.0,
                      bottom: context.isMobile ? 8.0 : 24.0,
                    ),
                    child: Center(
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}