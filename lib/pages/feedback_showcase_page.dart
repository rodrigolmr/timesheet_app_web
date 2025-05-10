// lib/pages/feedback_showcase_page.dart

import 'package:flutter/material.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'package:timesheet_app_web/widgets/app_button.dart';
import 'package:timesheet_app_web/widgets/base_layout.dart';
import 'package:timesheet_app_web/widgets/feedback_overlay.dart';
import 'package:timesheet_app_web/widgets/loading_button.dart';
import 'package:timesheet_app_web/widgets/progress_indicator.dart';
import 'package:timesheet_app_web/widgets/toast_message.dart';

class FeedbackShowcasePage extends StatefulWidget {
  const FeedbackShowcasePage({Key? key}) : super(key: key);

  @override
  State<FeedbackShowcasePage> createState() => _FeedbackShowcasePageState();
}

class _FeedbackShowcasePageState extends State<FeedbackShowcasePage> {
  bool _isLoading = false;
  double _progressValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Feedback Components',
      child: LoadingProgressOverlay(
        isLoading: _isLoading,
        message: 'Processing request...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultSpacing),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: AppTheme.maxFormWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSection(
                    'Toast Messages',
                    [
                      AppButton.fromType(
                        type: ButtonType.submitButton,
                        onPressed: () => ToastMessage.showSuccess(
                          context,
                          'Operation completed successfully!',
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.cancelButton,
                        onPressed: () => ToastMessage.showError(
                          context,
                          'An error occurred during the operation.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.editButton,
                        onPressed: () => ToastMessage.showInfo(
                          context,
                          'This is an information message.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.columnsButton,
                        onPressed: () => ToastMessage.showWarning(
                          context,
                          'Warning: This action cannot be undone!',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.largeSpacing),
                  _buildSection(
                    'Feedback Overlay',
                    [
                      AppButton.fromType(
                        type: ButtonType.saveButton,
                        onPressed: () => FeedbackController.showSuccess(
                          context,
                          message: 'Data saved successfully!',
                          position: FeedbackPosition.center,
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.deleteButton,
                        onPressed: () => FeedbackController.showError(
                          context,
                          message: 'Failed to delete the record.',
                          position: FeedbackPosition.top,
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.settingsButton,
                        onPressed: () => FeedbackController.showWarning(
                          context,
                          message: 'The process may take a few minutes.',
                          position: FeedbackPosition.bottom,
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.pdfButton,
                        onPressed: () => FeedbackController.showInfo(
                          context,
                          message: 'PDF is ready for download.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      AppButton.fromType(
                        type: ButtonType.uploadReceiptButton,
                        onPressed: () {
                          FeedbackController.showLoading(
                            context,
                            message: 'Uploading file...',
                          );
                          Future.delayed(const Duration(seconds: 3), () {
                            FeedbackController.hide();
                            FeedbackController.showSuccess(
                              context,
                              message: 'File uploaded successfully!',
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.largeSpacing),
                  _buildSection(
                    'Progress Indicators',
                    [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppProgressIndicator(
                                type: ProgressType.circular,
                                value: _progressValue,
                                label: 'Circular',
                                showPercentage: true,
                              ),
                              const SizedBox(width: AppTheme.largeSpacing),
                              AppProgressIndicator(
                                type: ProgressType.sync,
                                label: 'Sync',
                              ),
                              const SizedBox(width: AppTheme.largeSpacing),
                              AppProgressIndicator(
                                type: ProgressType.upload,
                                value: _progressValue,
                                label: 'Upload',
                                showPercentage: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.largeSpacing),
                          AppProgressIndicator(
                            type: ProgressType.linear,
                            value: _progressValue,
                            label: 'Linear Progress',
                            showPercentage: true,
                          ),
                          const SizedBox(height: AppTheme.smallSpacing),
                          Slider(
                            value: _progressValue,
                            onChanged: (value) {
                              setState(() {
                                _progressValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.largeSpacing),
                  _buildSection(
                    'Loading Buttons',
                    [
                      LoadingButton.fromType(
                        type: ButtonType.loginButton,
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2));
                        },
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      LoadingButton.fromType(
                        type: ButtonType.saveButton,
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2));
                        },
                        loadingText: 'Saving...',
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      StateButton.fromType(
                        type: ButtonType.submitButton,
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2));
                          return true; // Success
                        },
                        successText: 'Done!',
                      ),
                      const SizedBox(width: AppTheme.smallSpacing),
                      StateButton.fromType(
                        type: ButtonType.pdfButton,
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2));
                          return false; // Error
                        },
                        loadingText: 'Generating...',
                        errorText: 'Failed',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.largeSpacing),
                  _buildSection(
                    'Page Loading Overlay',
                    [
                      AppButton.fromType(
                        type: ButtonType.searchButton,
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              _isLoading = false;
                            });
                            
                            ToastMessage.showSuccess(
                              context,
                              'Loading completed successfully!',
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.smallSpacing),
          decoration: AppTheme.containerDecoration(
            backgroundColor: AppTheme.primaryBlue,
            radius: AppTheme.defaultRadius,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textLightColor,
              fontWeight: FontWeight.bold,
              fontSize: AppTheme.bodyTextSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppTheme.smallSpacing),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.defaultSpacing),
            child: Wrap(
              spacing: AppTheme.smallSpacing,
              runSpacing: AppTheme.smallSpacing,
              alignment: WrapAlignment.center,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}