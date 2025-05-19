import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/providers/timesheet_create_providers.dart';

class Step3ReviewForm extends ConsumerWidget {
  const Step3ReviewForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(timesheetFormStateProvider);

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Submit',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingL),

            // Header Information
            _buildSection(
              context,
              title: 'General Information',
              child: Column(
                children: [
                  _buildReadOnlyField(context, 'Job Name', formState.jobName),
                  _buildReadOnlyField(
                    context,
                    'Date',
                    DateFormat('MMM-dd-yyyy, EEEE').format(formState.date),
                  ),
                  _buildReadOnlyField(context, 'Job Description', formState.jobDescription),
                  if (formState.territorialManager.isNotEmpty)
                    _buildReadOnlyField(context, 'Territorial Manager', formState.territorialManager),
                  if (formState.jobSize.isNotEmpty)
                    _buildReadOnlyField(context, 'Job Size', formState.jobSize),
                  if (formState.material.isNotEmpty)
                    _buildReadOnlyField(context, 'Material', formState.material),
                  if (formState.foreman.isNotEmpty)
                    _buildReadOnlyField(context, 'Foreman', formState.foreman),
                  if (formState.vehicle.isNotEmpty)
                    _buildReadOnlyField(context, 'Vehicle', formState.vehicle),
                ],
              ),
            ),

            SizedBox(height: context.dimensions.spacingXL),

            // Employees Information
            _buildSection(
              context,
              title: 'Employees',
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: context.dimensions.spacingL,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Start')),
                        DataColumn(label: Text('Finish')),
                        DataColumn(label: Text('Hours')),
                        DataColumn(label: Text('Travel')),
                        DataColumn(label: Text('Meal')),
                      ],
                      rows: formState.employees.map((employee) {
                        return DataRow(
                          cells: [
                            DataCell(Text(employee.employeeName)),
                            DataCell(Text(employee.startTime)),
                            DataCell(Text(employee.finishTime)),
                            DataCell(Text(employee.hours.toStringAsFixed(1))),
                            DataCell(Text(employee.travelHours.toStringAsFixed(1))),
                            DataCell(Text(employee.meal.toStringAsFixed(1))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingM),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.dimensions.spacingM),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Employees: ${formState.employees.length}',
                          style: context.textStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total Hours: ${formState.employees.fold(0.0, (sum, e) => sum + e.hours).toStringAsFixed(1)}',
                          style: context.textStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.dimensions.spacingXL),

            // Instructions
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: context.colors.warning,
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  Expanded(
                    child: Text(
                      'Please review all information carefully before submitting. Once submitted, this timesheet cannot be edited.',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.warning,
                      ),
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

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyles.title,
          ),
          SizedBox(height: context.dimensions.spacingM),
          child,
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: context.textStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}