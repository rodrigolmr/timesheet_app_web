import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class TimesheetLegacyDesign extends StatefulWidget {
  final List<Map<String, dynamic>> timesheets;
  final Function(String) onTimesheetSelected;

  const TimesheetLegacyDesign({
    super.key,
    required this.timesheets,
    required this.onTimesheetSelected,
  });

  @override
  State<TimesheetLegacyDesign> createState() => _TimesheetLegacyDesignState();
}

class _TimesheetLegacyDesignState extends State<TimesheetLegacyDesign> {
  // Selected timesheet IDs for batch operations
  final Set<String> _selectedTimesheetIds = {};

  void _toggleSelection(String id, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedTimesheetIds.add(id);
      } else {
        _selectedTimesheetIds.remove(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedTimesheetIds.addAll(widget.timesheets.map((t) => t['id'] as String));
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedTimesheetIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control bar with select/deselect and count
        Container(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          color: context.colors.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side
              Text(
                'Timesheets',
                style: context.textStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Right side - Icon
              Icon(
                Icons.format_list_bulleted,
                color: context.colors.primary,
              ),
            ],
          ),
        ),
        
        // Timesheet list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            itemCount: widget.timesheets.length,
            itemBuilder: (context, index) {
              final timesheet = widget.timesheets[index];
              return _buildTimesheetRow(
                context, 
                timesheet, 
                _selectedTimesheetIds.contains(timesheet['id']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimesheetRow(
    BuildContext context, 
    Map<String, dynamic> timesheet, 
    bool isSelected,
  ) {
    final date = timesheet['date'] as DateTime;
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
    
    final contentWidth = rowWidth; // Use full width since checkbox is removed
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: SizedBox(
          width: rowWidth,
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main container
                GestureDetector(
                  onTap: () => widget.onTimesheetSelected(timesheet['id']),
                  child: Container(
                    width: contentWidth,
                    height: 45,
                    decoration: BoxDecoration(
                      color: context.colors.surface.withOpacity(0.8),
                      border: Border.all(color: context.colors.primary, width: 1),
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
                              timesheet['jobName'],
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
                          child: Text(
                            timesheet['creator'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: context.textStyles.caption.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
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
      ),
    );
  }
}