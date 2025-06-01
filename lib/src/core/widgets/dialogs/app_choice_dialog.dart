import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class ChoiceItem<T> {
  final T value;
  final String label;
  final String? description;
  final IconData? icon;
  final Color? color;

  const ChoiceItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.color,
  });
}

class AppChoiceDialog<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<ChoiceItem<T>> items;
  final T? selectedValue;
  final bool allowMultiple;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onMultipleChanged;
  final String? confirmText;
  final String? cancelText;

  const AppChoiceDialog({
    super.key,
    required this.title,
    required this.items,
    this.subtitle,
    this.selectedValue,
    this.allowMultiple = false,
    this.onChanged,
    this.onMultipleChanged,
    this.confirmText,
    this.cancelText,
  });

  @override
  State<AppChoiceDialog<T>> createState() => _AppChoiceDialogState<T>();
}

class _AppChoiceDialogState<T> extends State<AppChoiceDialog<T>> {
  late T? _selectedValue;
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _selectedValues = widget.selectedValue != null ? [widget.selectedValue as T] : [];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: context.textStyles.title,
          ),
          if (widget.subtitle != null) ...[
            SizedBox(height: context.dimensions.spacingXS),
            Text(
              widget.subtitle!,
              style: context.textStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 400,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((item) {
              final isSelected = widget.allowMultiple
                  ? _selectedValues.contains(item.value)
                  : _selectedValue == item.value;
              
              return Padding(
                padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
                child: InkWell(
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  onTap: () {
                    setState(() {
                      if (widget.allowMultiple) {
                        if (_selectedValues.contains(item.value)) {
                          _selectedValues.remove(item.value);
                        } else {
                          _selectedValues.add(item.value);
                        }
                      } else {
                        _selectedValue = item.value;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.dimensions.spacingM),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? item.color ?? context.colors.primary
                            : context.colors.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                      color: isSelected
                          ? (item.color ?? context.colors.primary).withOpacity(0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            color: item.color ?? (isSelected
                                ? context.colors.primary
                                : context.colors.textSecondary),
                            size: 24,
                          ),
                          SizedBox(width: context.dimensions.spacingM),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: context.textStyles.subtitle.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : null,
                                  color: isSelected
                                      ? item.color ?? context.colors.primary
                                      : null,
                                ),
                              ),
                              if (item.description != null) ...[
                                SizedBox(height: context.dimensions.spacingXS),
                                Text(
                                  item.description!,
                                  style: context.textStyles.caption.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (widget.allowMultiple)
                          Checkbox(
                            value: isSelected,
                            onChanged: null,
                            activeColor: item.color ?? context.colors.primary,
                          )
                        else
                          Radio<T>(
                            value: item.value,
                            groupValue: _selectedValue,
                            onChanged: null,
                            activeColor: item.color ?? context.colors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.allowMultiple) {
              widget.onMultipleChanged?.call(_selectedValues);
            } else {
              widget.onChanged?.call(_selectedValue);
            }
            Navigator.of(context).pop(
              widget.allowMultiple ? _selectedValues : _selectedValue,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: Text(widget.confirmText ?? 'Select'),
        ),
      ],
    );
  }
}

// Helper function to show choice dialog
Future<T?> showAppChoiceDialog<T>({
  required BuildContext context,
  required String title,
  required List<ChoiceItem<T>> items,
  String? subtitle,
  T? selectedValue,
  String? confirmText,
  String? cancelText,
}) async {
  return showDialog<T>(
    context: context,
    builder: (_) => AppChoiceDialog<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      selectedValue: selectedValue,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}

// Helper function to show multiple choice dialog
Future<List<T>?> showAppMultipleChoiceDialog<T>({
  required BuildContext context,
  required String title,
  required List<ChoiceItem<T>> items,
  String? subtitle,
  List<T>? selectedValues,
  String? confirmText,
  String? cancelText,
}) async {
  return showDialog<List<T>>(
    context: context,
    builder: (_) => AppChoiceDialog<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      selectedValue: selectedValues?.isNotEmpty == true ? selectedValues!.first : null,
      allowMultiple: true,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}