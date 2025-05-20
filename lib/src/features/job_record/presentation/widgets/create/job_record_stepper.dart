import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

class JobRecordStepper extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const JobRecordStepper({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingL,
        vertical: context.responsive<double>(
          xs: context.dimensions.spacingXS, // Very small padding on mobile
          sm: context.dimensions.spacingXS,
          md: context.dimensions.spacingS, // Slightly larger on desktop
        ),
      ),
      child: Row(
        children: [
          _buildStep(
            context,
            stepNumber: 1,
            title: 'Job Info',
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
            title: 'Review',
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
        mainAxisSize: MainAxisSize.min, // Minimiza altura
        mainAxisAlignment: MainAxisAlignment.center, // Centro vertical
        children: [
          Container(
            width: context.responsive<double>(
              xs: 24, // Much smaller on mobile
              sm: 26, // Small on tablets
              md: 28, // Medium size on tablets
              lg: 30, // Reduced size on desktop
            ),
            height: context.responsive<double>(
              xs: 24, // Much smaller on mobile
              sm: 26, // Small on tablets
              md: 28, // Medium size on tablets
              lg: 30, // Reduced size on desktop
            ),
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
                    : context.colors.outline,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: context.colors.onPrimary,
                      size: 16, // Smaller icon
                    )
                  : Text(
                      stepNumber.toString(),
                      style: context.textStyles.caption.copyWith( // Smaller text
                        fontWeight: FontWeight.bold,
                        color: isCurrent
                            ? context.colors.onPrimary
                            : isActive
                                ? context.colors.primary
                                : context.colors.textSecondary,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 2), // Espaçamento mínimo possível
          Container(
            constraints: BoxConstraints(maxWidth: 90), // Slightly reduced width
            child: Text(
              title,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10, // Smaller on mobile but still readable
                  sm: 11,
                  md: 12, // Original caption size
                ),
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
      height: 1, // Linha ainda mais fina
      margin: EdgeInsets.only(bottom: 10), // Margem inferior mínima
      color: isActive
          ? context.colors.primary
          : context.colors.outline.withOpacity(0.5), // Mais transparente
    );
  }
}