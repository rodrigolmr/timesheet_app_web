import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class AppProgressDialog extends StatelessWidget {
  final String title;
  final String? message;
  final double? progress;
  final bool showProgress;
  final bool canCancel;
  final VoidCallback? onCancel;
  final Widget? content;

  const AppProgressDialog({
    super.key,
    required this.title,
    this.message,
    this.progress,
    this.showProgress = false,
    this.canCancel = false,
    this.onCancel,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return PopScope(
      canPop: canCancel,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          constraints: BoxConstraints(
            minWidth: isMobile ? 280 : 350,
            maxWidth: isMobile ? double.infinity : 400,
          ),
          padding: EdgeInsets.all(context.dimensions.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showProgress && progress != null)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: context.colors.outline.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.primary,
                        ),
                      ),
                      Text(
                        '${(progress! * 100).toInt()}%',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.colors.primary,
                    ),
                  ),
                ),
              SizedBox(height: context.dimensions.spacingL),
              Text(
                title,
                style: context.textStyles.title,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  message!,
                  style: context.textStyles.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (content != null) ...[
                SizedBox(height: context.dimensions.spacingM),
                content!,
              ],
              if (canCancel) ...[
                SizedBox(height: context.dimensions.spacingL),
                TextButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Progress controller for managing progress dialog
class ProgressDialogController {
  final String title;
  final bool showProgress;
  final bool canCancel;
  
  String? _message;
  double? _progress;
  final ValueNotifier<_ProgressState> _state = ValueNotifier(_ProgressState());
  
  ProgressDialogController({
    required this.title,
    this.showProgress = false,
    this.canCancel = false,
  });

  void updateMessage(String message) {
    _message = message;
    _state.value = _ProgressState(message: message, progress: _progress);
  }

  void updateProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);
    _state.value = _ProgressState(message: _message, progress: _progress);
  }

  void updateBoth(String message, double progress) {
    _message = message;
    _progress = progress.clamp(0.0, 1.0);
    _state.value = _ProgressState(message: message, progress: _progress);
  }

  void dispose() {
    _state.dispose();
  }
}

class _ProgressState {
  final String? message;
  final double? progress;

  _ProgressState({this.message, this.progress});
}

// Helper function to show progress dialog
Future<T?> showAppProgressDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  double? progress,
  bool showProgress = false,
  bool canCancel = false,
  VoidCallback? onCancel,
  Widget? content,
}) async {
  return showDialog<T>(
    context: context,
    barrierDismissible: canCancel,
    builder: (_) => AppProgressDialog(
      title: title,
      message: message,
      progress: progress,
      showProgress: showProgress,
      canCancel: canCancel,
      onCancel: onCancel,
      content: content,
    ),
  );
}

// Helper function to show progress dialog with controller
Future<T?> showAppProgressDialogWithController<T>({
  required BuildContext context,
  required ProgressDialogController controller,
  required Future<T> Function() task,
}) async {
  showDialog(
    context: context,
    barrierDismissible: controller.canCancel,
    builder: (dialogContext) => ValueListenableBuilder<_ProgressState>(
      valueListenable: controller._state,
      builder: (context, state, _) => AppProgressDialog(
        title: controller.title,
        message: state.message,
        progress: state.progress,
        showProgress: controller.showProgress,
        canCancel: controller.canCancel,
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    ),
  );

  try {
    final result = await task();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    return result;
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    rethrow;
  } finally {
    controller.dispose();
  }
}