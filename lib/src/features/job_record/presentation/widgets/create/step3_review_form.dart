import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_multiline_text_field.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_create_providers.dart';

class Step3ReviewForm extends ConsumerStatefulWidget {
  const Step3ReviewForm({super.key});

  @override
  ConsumerState<Step3ReviewForm> createState() => _Step3ReviewFormState();
}

class _Step3ReviewFormState extends ConsumerState<Step3ReviewForm> {
  bool _showNotesField = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing notes if any
    final formState = ref.read(jobRecordFormStateProvider);
    final isEditMode = ref.read(isEditModeProvider);
    
    _notesController.text = formState.notes;
    
    // In edit mode, always start with notes field closed even if there are notes
    // In create mode, show field if there are existing notes
    _showNotesField = isEditMode ? false : formState.notes.isNotEmpty;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateNotes(String value) {
    final headerData = {
      'notes': value,
    };
    ref.read(jobRecordFormStateProvider.notifier).updateHeader(headerData);
  }

  String _expandSeparators(String text) {
    // Replace 12-character separators with 20-character ones for display
    final lines = text.split('\n');
    final expandedLines = lines.map((line) {
      // Check if line is a separator (only contains ━ characters)
      if (line.isNotEmpty && line.replaceAll('━', '').isEmpty) {
        return '━' * 20;
      }
      return line;
    }).toList();
    return expandedLines.join('\n');
  }

  String _getDateDisplay(DateTime date) {
    // Always show the date, regardless of whether it's today or not
    return intl.DateFormat("M/d/yy, EEEE").format(date);
  }

  // Format number without .0 if it's a whole number
  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(jobRecordFormStateProvider);

    // Calcular largura base responsiva
    final baseWidth = context.responsive<double>(
      xs: 280,  // Mobile pequeno
      sm: 292,  // Mobile
      md: 340,  // Tablet
      lg: 400,  // Desktop pequeno
      xl: 450,  // Desktop grande
    );
    
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > baseWidth + 40 ? baseWidth : screenWidth - 40;
    
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: context.dimensions.spacingL,
        right: context.dimensions.spacingL,
        bottom: context.dimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Job Record Layout
          Center(
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleTimeSheet(context, "JOB RECORD"),
                  _drawHorizontalLine(),
                  _buildLineJobName(context, "JOB NAME:", formState.jobName),
                  _drawHorizontalLine(),
                  _buildLineDateTmRow(
                    context,
                    _getDateDisplay(formState.date),
                    formState.territorialManager,
                  ),
                  _drawHorizontalLine(),
                  // Always show job size field, even when empty
                  _buildLineJobSize(context, "JOB SIZE:", formState.jobSize),
                  _drawHorizontalLine(),
                  
                  // Always show material field, even when empty
                  _buildLineMaterialRow(context, "MATERIAL:", formState.material),
                  _drawHorizontalLine(),
                  _buildLineJobDesc(context, "JOB DESC.:", formState.jobDescription),
                  _drawHorizontalLine(),
                  _buildLineForemanVehicle(context, formState.foreman, formState.vehicle),
                  _drawHorizontalLine(),
                  if (formState.employees.isEmpty)
                    _buildLineText(context, "No Workers added.", "")
                  else
                    _buildWorkersTable(context, formState.employees),
                ],
              ),
            ),
          ),

          // Note field outside the borders
          if (formState.notes.isNotEmpty && !_showNotesField)
            Container(
              width: containerWidth,
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Note: ",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _expandSeparators(formState.notes),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: context.dimensions.spacingXL),

          // Add Note Button or Notes Field
          Container(
            width: containerWidth,
            child: _showNotesField 
              ? Column(
                  children: [
                    AppMultilineTextField(
                      label: 'Notes',
                      hintText: 'Add any additional notes here...',
                      controller: _notesController,
                      onChanged: _updateNotes,
                      minLines: 3,
                      maxLines: 5,
                      autoGrow: true,
                    ),
                    SizedBox(height: context.dimensions.spacingXS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _notesController.clear();
                              _updateNotes('');
                            });
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.error,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimensions.spacingS,
                              vertical: context.dimensions.spacingXS,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final currentText = _notesController.text;
                            final selection = _notesController.selection;

                            // 12 characters for editing field (compact)
                            // Will be displayed as 20 characters when saved
                            final separator = '\n${'━' * 12}\n';

                            String newText;
                            int newCursorPosition;

                            if (selection.isValid && selection.start == selection.end) {
                              // Insert at cursor position
                              newText = currentText.substring(0, selection.start) +
                                  separator +
                                  currentText.substring(selection.start);
                              newCursorPosition = selection.start + separator.length;
                            } else {
                              // Add at the end
                              newText = currentText + separator;
                              newCursorPosition = newText.length;
                            }

                            setState(() {
                              _notesController.value = TextEditingValue(
                                text: newText,
                                selection: TextSelection.collapsed(offset: newCursorPosition),
                              );
                              _updateNotes(newText);
                            });
                          },
                          child: Text(
                            'Add Separator',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.textSecondary,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimensions.spacingS,
                              vertical: context.dimensions.spacingXS,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showNotesField = false;
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimensions.spacingS,
                              vertical: context.dimensions.spacingXS,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        // Load current notes into controller when showing the field
                        _notesController.text = formState.notes;
                        _showNotesField = true;
                      });
                    },
                    icon: Icon(
                      formState.notes.isNotEmpty ? Icons.edit_note : Icons.note_add,
                      size: 20
                    ),
                    label: Text(
                      formState.notes.isNotEmpty ? 'Edit Notes' : 'Add Notes'
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.primary,
                    ),
                  ),
                ),
          ),

          SizedBox(height: context.dimensions.spacingXL),

          // Instructions
          Container(
            width: containerWidth,
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              border: Border.all(color: context.colors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.colors.warning,
                  size: 20,
                ),
                SizedBox(width: context.dimensions.spacingS),
                Expanded(
                  child: Text(
                    'Please review all information carefully before submitting.',
                    style: TextStyle(
                      fontSize: context.responsive<double>(
                        xs: 11,
                        sm: 12,
                        md: 13,
                        lg: 14,
                        xl: 15,
                      ),
                      color: context.colors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleTimeSheet(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      height: context.responsive<double>(
        xs: 22,
        sm: 24,
        md: 26,
        lg: 28,
        xl: 30,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.responsive<double>(
            xs: 16,
            sm: 18,
            md: 20,
            lg: 22,
            xl: 24,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _drawHorizontalLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 60,
              sm: 64,
              md: 70,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineDateTmRow(BuildContext context, String dateValue, String tmValue) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 34,
              sm: 36,
              md: 40,
              lg: 45,
              xl: 50,
            ),
            child: Text(
              "DATE:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 28,
              sm: 31,
              md: 35,
              lg: 40,
              xl: 45,
            ),
            child: Text(
              "T.M.:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              tmValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobSize(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 52,
              sm: 56,
              md: 62,
              lg: 70,
              xl: 80,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineMaterialRow(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );

    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );

    // Parse material|quantity format
    List<String> materialLines = [];
    if (value.isNotEmpty) {
      final lines = value.split('\n');
      for (var line in lines) {
        final parts = line.split('|');
        if (parts.length >= 2) {
          final material = parts[0].trim();
          final quantity = parts[1].trim();
          if (material.isNotEmpty && quantity.isNotEmpty) {
            materialLines.add('$material - $quantity');
          } else if (material.isNotEmpty) {
            materialLines.add(material);
          }
        }
      }
    }

    final displayText = materialLines.isEmpty ? '' : materialLines.join('\n');
    final verticalPadding = materialLines.length > 1 ? 4.0 : 0.0;

    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobDesc(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );
    
    // Adiciona padding vertical quando tem múltiplas linhas
    final verticalPadding = value.contains('\n') ? 4.0 : 0.0;
    
    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineForemanVehicle(BuildContext context, String foreman, String vehicle) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 56,
              sm: 60,
              md: 66,
              lg: 75,
              xl: 85,
            ),
            child: Text(
              "FOREMAN:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              foreman.isEmpty ? '' : foreman,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 46,
              sm: 50,
              md: 56,
              lg: 65,
              xl: 75,
            ),
            child: Text(
              "VEHICLE:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              vehicle.isEmpty ? '' : vehicle,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineText(BuildContext context, String label, String value, {bool multiLine = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minHeight: 18),
      child: Row(
        crossAxisAlignment:
            multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersTable(BuildContext context, List<dynamic> employees) {
    final baseFontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final rows = <TableRow>[
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        children: [
          _buildHeaderCell("NAME", fontSize: baseFontSize, textAlign: TextAlign.center),
          _buildHeaderCell("START", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("FINISH", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("HOUR", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("TRAVEL", fontSize: baseFontSize * 0.65, textAlign: TextAlign.center),
          _buildHeaderCell("MEAL", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
        ],
      ),
      for (final employee in employees)
        TableRow(
          children: [
            _buildDataCell(employee.employeeName,
                fontSize: baseFontSize, textAlign: TextAlign.left),
            _buildDataCell(employee.startTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.finishTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(_formatNumber(employee.hours),
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.travelHours > 0 ? _formatNumber(employee.travelHours) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.meal > 0 ? _formatNumber(employee.meal) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
          ],
        ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Table(
        border: TableBorder(
          top: const BorderSide(width: 0, color: Colors.transparent),
          left: const BorderSide(width: 0, color: Colors.transparent),
          right: const BorderSide(width: 0, color: Colors.transparent),
          bottom: const BorderSide(width: 0, color: Colors.transparent),
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: {
          0: FlexColumnWidth(context.responsive<double>(
            xs: 2.5,
            sm: 3,
            md: 3.5,
            lg: 4,
            xl: 4.5,
          )),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(0.8),
          4: const FlexColumnWidth(0.9),
          5: const FlexColumnWidth(0.8),
        },
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildDataCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }
}