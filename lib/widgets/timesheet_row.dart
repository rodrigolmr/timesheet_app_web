import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:timesheet_app_web/core/responsive/responsive.dart';

/// A widget that displays a timesheet entry as a row item.
///
/// This widget is used to display timesheet entries in a list, showing:
/// - The day and month
/// - The job name
/// - The user's name (split into first and last name)
/// - A checkbox for selection
///
/// The widget has a responsive design with fixed dimensions for the date and user name sections,
/// while the job name section expands to fill available space.
class TimesheetRowItem extends StatefulWidget {
  /// The day number to display
  final String day;
  
  /// The month abbreviation to display
  final String month;
  
  /// The job name to display
  final String jobName;
  
  /// The full user name to display (will be split into first and last name)
  final String userName;
  
  /// Whether the checkbox should be initially checked
  final bool initialChecked;
  
  /// Callback when the checkbox value changes
  final ValueChanged<bool>? onCheckChanged;

  /// Creates a TimesheetRowItem widget.
  const TimesheetRowItem({
    Key? key,
    required this.day,
    required this.month,
    required this.jobName,
    required this.userName,
    this.initialChecked = false,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  State<TimesheetRowItem> createState() => _TimesheetRowItemState();
}

class _TimesheetRowItemState extends State<TimesheetRowItem> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialChecked;
  }

  @override
  void didUpdateWidget(covariant TimesheetRowItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update checkbox state if initialChecked changes
    if (widget.initialChecked != oldWidget.initialChecked) {
      setState(() {
        _isChecked = widget.initialChecked;
      });
    }
  }

  void _onCheckboxChanged(bool? value) {
    if (value == null) return;
    setState(() => _isChecked = value);
    widget.onCheckChanged?.call(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0205D3);
    final theme = Theme.of(context);
    final responsive = ResponsiveSizing(context);
    
    // Get screen width for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Screen size breakpoints for responsive sizing
    final isVerySmall = screenWidth < 340;
    final isSmall = screenWidth < 360;
    final isMedium = screenWidth < 400;

    // Split full name into first and last name parts
    final parts = widget.userName.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    
    // Semantic label for accessibility
    final semanticLabel = 'Timesheet for ${widget.jobName} on ${widget.day} ${widget.month} by ${widget.userName}';

    return Padding(
      padding: EdgeInsets.only(
        left: isVerySmall ? 1 : 4,
        right: isVerySmall ? 1 : 4,
        bottom: isVerySmall ? 3 : 5
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.responsiveValue(
              mobile: isVerySmall ? screenWidth - 10 : screenWidth - 16,
              tablet: 600.0,
              desktop: 800.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onCheckChanged?.call(!_isChecked),
                    borderRadius: BorderRadius.circular(5),
                    child: Semantics(
                      label: semanticLabel,
                      excludeSemantics: true,
                      child: Container(
                        height: isVerySmall ? 40 : 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDD0), // Light yellow background
                          border: Border.all(color: primaryBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            // Day and month section (adaptive width)
                            Container(
                              width: isVerySmall ? 32 : 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E5FF), // Light purple
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Day display
                                  SizedBox(
                                    height: isVerySmall ? 22 : 25,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.day,
                                        style: TextStyle(
                                          fontSize: isVerySmall ? 18 : 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF0000), // Red color for day
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Month display
                                  SizedBox(
                                    height: isVerySmall ? 14 : 16,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.month,
                                        style: TextStyle(
                                          fontSize: isVerySmall ? 11 : 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Job name section (flexible width)
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isVerySmall ? 3 : 6
                                ),
                                child: Text(
                                  widget.jobName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isVerySmall ? 11 : 12,
                                    color: const Color(0xFF3B3B3B),
                                  ),
                                ),
                              ),
                            ),
                            
                            // User name section (adaptive width)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Adjust the width based on available space
                                final nameWidth = isVerySmall ? 52.0 :
                                                 isSmall ? 60.0 :
                                                 isMedium ? 70.0 : 90.0;

                                // For very small screens, show initials instead of full names
                                final showInitials = isVerySmall;
                                final initialFirst = firstName.isNotEmpty ? firstName[0] : '';
                                final initialLast = lastName.isNotEmpty ? lastName[0] : '';

                                return Container(
                                  width: nameWidth,
                                  height: isVerySmall ? 40 : 45,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmall ? 2 : 4
                                  ),
                                  decoration: const BoxDecoration(
                                    // White border between jobName and userName
                                    border: Border(
                                      left: BorderSide(color: Colors.white, width: 1),
                                    ),
                                  ),
                                  child: showInitials
                                    // Show initials for very small screens
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            initialFirst,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF3B3B3B),
                                            ),
                                          ),
                                          if (initialLast.isNotEmpty)
                                            Text(
                                              initialLast,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF3B3B3B),
                                              ),
                                            ),
                                        ],
                                      )
                                    // Show full names for larger screens
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // First name
                                          SizedBox(
                                            height: 20,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                firstName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFF3B3B3B),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Last name
                                          SizedBox(
                                            height: 20,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                lastName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFF3B3B3B),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Checkbox section
              SizedBox(
                width: isVerySmall ? 30 : 34,
                child: Semantics(
                  label: _isChecked ? 'Selected' : 'Not selected',
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: _onCheckboxChanged,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: primaryBlue,
                    materialTapTargetSize: isVerySmall ?
                        MaterialTapTargetSize.shrinkWrap :
                        MaterialTapTargetSize.padded,
                    visualDensity: isVerySmall ?
                        VisualDensity.compact :
                        VisualDensity.standard,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}