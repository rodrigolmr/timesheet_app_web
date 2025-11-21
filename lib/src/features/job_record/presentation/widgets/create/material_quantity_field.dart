import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Modelo para uma linha de Material/Quantity
class MaterialQuantityRow {
  final TextEditingController materialController;
  final TextEditingController quantityController;
  final FocusNode materialFocusNode;
  final FocusNode quantityFocusNode;

  MaterialQuantityRow({
    TextEditingController? materialController,
    TextEditingController? quantityController,
    FocusNode? materialFocusNode,
    FocusNode? quantityFocusNode,
  })  : materialController = materialController ?? TextEditingController(),
        quantityController = quantityController ?? TextEditingController(),
        materialFocusNode = materialFocusNode ?? FocusNode(),
        quantityFocusNode = quantityFocusNode ?? FocusNode();

  void dispose() {
    materialController.dispose();
    quantityController.dispose();
    materialFocusNode.dispose();
    quantityFocusNode.dispose();
  }
}

/// Widget para múltiplas linhas de Material/Quantity que parecem um único campo
class MaterialQuantityField extends StatefulWidget {
  final List<MaterialQuantityRow> rows;
  final ValueChanged<int>? onMaterialChanged;
  final ValueChanged<int>? onQuantityChanged;

  const MaterialQuantityField({
    Key? key,
    required this.rows,
    this.onMaterialChanged,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<MaterialQuantityField> createState() => _MaterialQuantityFieldState();
}

class _MaterialQuantityFieldState extends State<MaterialQuantityField> {
  late List<MaterialQuantityRow> _rows;
  int? _lastFocusedRowIndex;

  @override
  void initState() {
    super.initState();
    _rows = widget.rows;
    for (var row in _rows) {
      row.materialFocusNode.addListener(_updateFocusedRow);
      row.quantityFocusNode.addListener(_updateFocusedRow);
    }
  }

  @override
  void dispose() {
    for (var row in _rows) {
      row.materialFocusNode.removeListener(_updateFocusedRow);
      row.quantityFocusNode.removeListener(_updateFocusedRow);
    }
    super.dispose();
  }

  void _updateFocusedRow() {
    setState(() {
      // Update which row currently has focus
      for (int i = 0; i < _rows.length; i++) {
        if (_rows[i].materialFocusNode.hasFocus || _rows[i].quantityFocusNode.hasFocus) {
          _lastFocusedRowIndex = i;
          break;
        }
      }
    });
  }

  void _addRow() {
    setState(() {
      final newRow = MaterialQuantityRow();
      newRow.materialFocusNode.addListener(_updateFocusedRow);
      newRow.quantityFocusNode.addListener(_updateFocusedRow);

      // If we know which row had focus last, insert after it; otherwise add at the end
      if (_lastFocusedRowIndex != null && _lastFocusedRowIndex! < _rows.length) {
        _rows.insert(_lastFocusedRowIndex! + 1, newRow);
        // Update the last focused index to the new row
        _lastFocusedRowIndex = _lastFocusedRowIndex! + 1;
      } else {
        _rows.add(newRow);
      }
    });
  }

  bool _anyHasFocus() {
    return _rows.any((row) =>
        row.materialFocusNode.hasFocus || row.quantityFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = context.dimensions;

    // Padding para o glow effect
    const glowPadding = 4.0;

    // Define o padding interno
    final contentPadding = EdgeInsets.symmetric(
      horizontal: dimensions.paddingMedium,
      vertical: dimensions.paddingSmall,
    );

    final anyHasFocus = _anyHasFocus();

    return Padding(
      padding: const EdgeInsets.all(glowPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _rows.length; i++)
            _buildRow(
              context,
              _rows[i],
              i,
              colors,
              dimensions,
              contentPadding,
              anyHasFocus,
            ),

          // Add row button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: dimensions.spacingXS),
              child: TextButton.icon(
                onPressed: _addRow,
                icon: Icon(
                  Icons.add,
                  size: 20,
                ),
                label: Text('Add line'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    MaterialQuantityRow row,
    int index,
    dynamic colors,
    dynamic dimensions,
    EdgeInsets contentPadding,
    bool anyHasFocus,
  ) {
    final isFirst = index == 0;
    final isLast = index == _rows.length - 1;
    final materialHasFocus = row.materialFocusNode.hasFocus;
    final quantityHasFocus = row.quantityFocusNode.hasFocus;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Material field (2/3 width)
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.materialController,
              focusNode: row.materialFocusNode,
              onChanged: (value) => widget.onMaterialChanged?.call(index),
              textCapitalization: TextCapitalization.words,
              style: context.textStyles.bodyMedium.copyWith(
                color: colors.onSurface,
              ),
              decoration: InputDecoration(
                labelText: isFirst ? 'Material' : null,
                labelStyle: context.textStyles.labelMedium.copyWith(
                  color: materialHasFocus
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
                floatingLabelStyle: context.textStyles.labelSmall.copyWith(
                  color: colors.primary,
                ),
                hintText: isFirst ? 'Enter material type and details' : 'Material',
                hintStyle: context.textStyles.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant.withOpacity(0.6),
                ),
                filled: true,
                fillColor: colors.surfaceAccent.withOpacity(0.85),
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: anyHasFocus ? colors.primary : colors.secondary,
                    width: anyHasFocus ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomLeft: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.secondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomLeft: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomLeft: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
              ),
            ),
          ),

          // Quantity field (1/3 width)
          Expanded(
            flex: 1,
            child: TextField(
              controller: row.quantityController,
              focusNode: row.quantityFocusNode,
              onChanged: (value) => widget.onQuantityChanged?.call(index),
              style: context.textStyles.bodyMedium.copyWith(
                color: colors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Quantity',
                hintStyle: context.textStyles.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant.withOpacity(0.6),
                ),
                filled: true,
                fillColor: colors.surfaceAccent.withOpacity(0.85),
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: anyHasFocus ? colors.primary : colors.secondary,
                    width: anyHasFocus ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.secondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: isFirst ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(dimensions.borderRadiusMedium) : Radius.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
