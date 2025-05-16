import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class TimesheetStepper extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const TimesheetStepper({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingL,
        vertical: context.dimensions.spacingM,
      ),
      child: Row(
        children: [
          _buildStep(
            context,
            stepNumber: 1,
            title: 'General Info',
            isActive: currentStep >= 0,
            isCurrent: currentStep == 0,
          ),
          Expanded(child: _buildStepConnector(context, isActive: currentStep >= 1)),
          _buildStep(
            context,
            stepNumber: 2,
            title: 'Employees',
            isActive: currentStep >= 1,
            isCurrent: currentStep == 1,
          ),
          Expanded(child: _buildStepConnector(context, isActive: currentStep >= 2)),
          _buildStep(
            context,
            stepNumber: 3,
            title: 'Review & Submit',
            isActive: currentStep >= 2,
            isCurrent: currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int stepNumber,
    required String title,
    required bool isActive,
    required bool isCurrent,
  }) {
    final stepIndex = stepNumber - 1;
    final isCompleted = currentStep > stepIndex;
    
    return GestureDetector(
      onTap: () => onStepTapped(stepIndex),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? context.colors.primary
                  : isCompleted
                      ? context.colors.success
                      : isActive
                          ? context.colors.primary.withOpacity(0.3)
                          : context.colors.surface,
              border: Border.all(
                color: isActive
                    ? context.colors.primary
                    : context.colors.textSecondary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      stepNumber.toString(),
                      style: context.textStyles.body.copyWith(
                        color: isCurrent
                            ? Colors.white
                            : isActive
                                ? context.colors.textPrimary
                                : context.colors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: context.dimensions.spacingXS),
          Container(
            constraints: BoxConstraints(maxWidth: 100),
            child: Text(
              title,
              style: context.textStyles.caption.copyWith(
                color: isActive
                    ? context.colors.textPrimary
                    : context.colors.textSecondary,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(BuildContext context, {required bool isActive}) {
    return Container(
      height: 2,
      margin: EdgeInsets.only(bottom: 40),
      color: isActive
          ? context.colors.primary
          : context.colors.textSecondary.withOpacity(0.3),
    );
  }
}