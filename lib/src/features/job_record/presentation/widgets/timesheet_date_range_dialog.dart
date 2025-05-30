import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/timesheet_providers.dart';
import 'package:intl/intl.dart';

class TimeSheetDateRangeDialog extends ConsumerStatefulWidget {
  const TimeSheetDateRangeDialog({super.key});

  @override
  ConsumerState<TimeSheetDateRangeDialog> createState() => _TimeSheetDateRangeDialogState();
}

class _TimeSheetDateRangeDialogState extends ConsumerState<TimeSheetDateRangeDialog> {
  DateTimeRange? _selectedDateRange;
  final _dateFormat = DateFormat('MM/dd/yyyy');
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generatorState = ref.watch(timeSheetGeneratorProvider);
    
    return AlertDialog(
      title: Text(
        'Generate Timesheet',
        style: context.textStyles.title,
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the date range for the timesheet report',
              style: context.textStyles.body,
            ),
            SizedBox(height: context.dimensions.spacingL),
            _buildCustomDateRangePicker(),
            if (_selectedDateRange != null) ...[
              SizedBox(height: context.dimensions.spacingM),
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: context.dimensions.spacingS),
                    Expanded(
                      child: Text(
                        'Report will include ${_calculateDays()} days of data',
                        style: context.textStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: generatorState.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canGenerate() && !generatorState.isLoading
              ? () => _generateTimeSheet(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: generatorState.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.colors.onPrimary,
                    ),
                  ),
                )
              : const Text('Generate'),
        ),
      ],
    );
  }

  bool _canGenerate() {
    return _selectedDateRange != null;
  }

  int _calculateDays() {
    if (_selectedDateRange == null) return 0;
    return _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays + 1;
  }

  Future<void> _generateTimeSheet(BuildContext context) async {
    if (!_canGenerate()) return;

    try {
      await ref.read(timeSheetGeneratorProvider.notifier).generateTimeSheet(
        startDate: _selectedDateRange!.start,
        endDate: _selectedDateRange!.end,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Timesheet generated successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating timesheet: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  Widget _buildCustomDateRangePicker() {
    return AppInputFieldBase(
      label: 'Period',
      hintText: 'Select date range',
      controller: _controller,
      onTap: () => _selectDateRange(context),
      readOnly: true,
      suffixIcon: Icon(
        Icons.date_range,
        color: context.colors.primary,
        size: 20,
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime.now().subtract(const Duration(days: 365));
    final DateTime lastDate = DateTime.now();
    
    // Não define initialDateRange se não há seleção prévia
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: _selectedDateRange, // Será null na primeira vez
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
              onPrimary: context.colors.onPrimary,
              surface: context.colors.surface,
              onSurface: context.colors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _controller.text = '${_dateFormat.format(picked.start)} - ${_dateFormat.format(picked.end)}';
      });
    }
  }
}