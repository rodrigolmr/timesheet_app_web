import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/services/update_check_service.dart';
import 'package:timesheet_app_web/src/core/config/build_config.dart';
import 'package:intl/intl.dart';

class AboutAppDialog extends ConsumerStatefulWidget {
  const AboutAppDialog({super.key});

  @override
  ConsumerState<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends ConsumerState<AboutAppDialog> {
  bool _isCheckingUpdate = false;
  String? _updateStatus;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = info;
        });
      }
    } catch (e) {
      // In web, some package info might not be available
      debugPrint('Error loading package info: $e');
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isCheckingUpdate = true;
      _updateStatus = null;
    });

    try {
      // Add a minimum delay for better UX
      await Future.delayed(const Duration(seconds: 1));
      
      // Check for updates using the service
      final bool hasUpdate = await UpdateCheckService.checkForUpdates();
      
      if (mounted) {
        setState(() {
          _isCheckingUpdate = false;
          _updateStatus = hasUpdate 
              ? 'New version available! Click refresh to update.'
              : 'You are running the latest version (v${BuildConfig.version}+${BuildConfig.buildNumber}).';
        });

        if (hasUpdate) {
          // Haptic feedback
          HapticFeedback.mediumImpact();
          
          final confirmed = await showAppConfirmDialog(
            context: context,
            title: 'Update Available! 🎉',
            message: 'A new version of the app is available. Would you like to refresh now to get the latest features and improvements?',
            confirmText: 'Update Now',
            cancelText: 'Later',
          );
          
          if (confirmed == true) {
            // Don't show progress dialog, just refresh immediately
            UpdateCheckService.skipWaitingAndReload();
          }
        } else {
          // Success feedback
          HapticFeedback.selectionClick();
        }
      }
    } catch (e) {
      debugPrint('Update check error: $e');
      if (mounted) {
        setState(() {
          _isCheckingUpdate = false;
          _updateStatus = 'Unable to check for updates. Please try again later.';
        });
        
        // Error feedback
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.access_time_filled,
                size: 48,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'Timesheet App',
              style: textStyles.headline.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            
            // Version
            Text(
              'Version ${BuildConfig.version} (Build ${BuildConfig.buildNumber})',
              style: textStyles.body.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Build Date
            Text(
              'Deployed: ${DateFormat('MMM dd, yyyy - HH:mm').format(BuildConfig.buildDate)}',
              style: textStyles.caption.copyWith(
                color: colors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            
            // Company Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.business,
                    label: 'Company',
                    value: 'Central Island Floors, Inc.',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    icon: Icons.code,
                    label: 'Developer',
                    value: 'Rodrigo Rocha',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Update Status
            if (_updateStatus != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _updateStatus!.contains('available') 
                      ? colors.success.withOpacity(0.1)
                      : colors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _updateStatus!.contains('available')
                        ? colors.success.withOpacity(0.3)
                        : colors.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _updateStatus!.contains('available') 
                          ? Icons.update
                          : Icons.check_circle,
                      size: 20,
                      color: _updateStatus!.contains('available')
                          ? colors.success
                          : colors.info,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _updateStatus!,
                        style: textStyles.caption.copyWith(
                          color: _updateStatus!.contains('available')
                              ? colors.success
                              : colors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isCheckingUpdate ? null : _checkForUpdates,
                  icon: _isCheckingUpdate
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : const Icon(Icons.refresh, size: 18),
                  label: Text(_isCheckingUpdate ? 'Checking...' : 'Check for Updates'),
                ),
              ],
            ),
            
            // Footer
            const SizedBox(height: 16),
            Text(
              '© 2025 Central Island Floors, Inc. All rights reserved.',
              style: textStyles.caption.copyWith(
                color: colors.textSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: colors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textStyles.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    value,
                    style: textStyles.body.copyWith(
                      color: onTap != null ? colors.primary : colors.textPrimary,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Timesheet App Support - Central Island Floors',
      },
    );
    
    try {
      if (!await launchUrl(emailUri)) {
        if (mounted) {
          showErrorDialog(
            context: context,
            title: 'Error',
            message: 'Could not launch email client',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to open email: $e',
        );
      }
    }
  }
}