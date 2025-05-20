import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/timesheet/data/models/timesheet_model.dart';

class TimesheetLegacyCard extends StatelessWidget {
  final TimesheetModel timesheet;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final VoidCallback onTap;
  final bool showCheckbox;

  const TimesheetLegacyCard({
    super.key,
    required this.timesheet,
    this.isSelected = false,
    this.onSelectionChanged,
    required this.onTap,
    this.showCheckbox = false,
  });

  @override
  Widget build(BuildContext context) {
    final date = timesheet.date;
    final day = DateFormat('d').format(date);
    final month = DateFormat('MMM').format(date);
    
    // Make the row width responsive to the screen size
    final rowWidth = context.responsive<double>(
      xs: 280,
      sm: 320,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    // Content width adjusts based on whether checkbox is shown
    final contentWidth = showCheckbox ? rowWidth - 24 : rowWidth;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: SizedBox(
          width: rowWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checkbox (optional)
              if (showCheckbox)
                Checkbox(
                  value: isSelected,
                  onChanged: onSelectionChanged != null 
                    ? (value) => onSelectionChanged!(value ?? false)
                    : null,
                  activeColor: context.colors.primary,
                ),
              
              // Main container
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: contentWidth,
                  height: 45,
                  decoration: BoxDecoration(
                    color: context.colors.surface.withOpacity(0.8),
                    border: Border.all(
                      color: isSelected ? context.colors.secondary : context.colors.primary, 
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      // Date section
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Day
                            SizedBox(
                              height: 25,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.error,
                                  ),
                                ),
                              ),
                            ),
                            // Month
                            SizedBox(
                              height: 16,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Job name
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            timesheet.jobName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: context.textStyles.body,
                          ),
                        ),
                      ),
                      
                      // Vertical divider
                      Container(
                        width: 2, 
                        height: double.infinity, 
                        color: context.colors.background,
                      ),
                      
                      // Creator
                      Container(
                        width: 72,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timesheet.getFormattedCreator(timesheet.userId),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: context.textStyles.caption.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            if (timesheet.status != 'pending')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(timesheet.status),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  timesheet.status,
                                  style: context.textStyles.caption.copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}