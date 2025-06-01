import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/pigtail/presentation/providers/pigtail_search_providers.dart';

class PigtailFilters extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedStatus;
  final String? selectedType;
  final bool filtersExpanded;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onClearFilters;

  const PigtailFilters({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedStatus,
    this.selectedType,
    required this.filtersExpanded,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onExpandedChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<PigtailFilters> createState() => _PigtailFiltersState();
}

class _PigtailFiltersState extends ConsumerState<PigtailFilters> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isMobile || context.isTablet;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(xs: 12, sm: 16, md: 20),
        vertical: widget.filtersExpanded && isSmallScreen 
            ? context.responsive<double>(xs: 10, sm: 12, md: 14)
            : context.responsive<double>(xs: 6, sm: 8, md: 10),
      ),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.15),
        border: Border(
          bottom: BorderSide(
            color: context.colors.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.filtersExpanded) ...[
            _buildExpandedFilters(),
          ] else ...[
            _buildMinimizedFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedFilters() {
    final availableTypes = ref.watch(availablePigtailTypesProvider);
    final isSmallScreen = context.isMobile || context.isTablet;
    
    if (isSmallScreen) {
      // Two-row layout for small screens
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First row: Search and Status
          Row(
            children: [
              _buildSearchField(),
              const SizedBox(width: 8),
              _buildStatusFilter(),
            ],
          ),
          const SizedBox(height: 8),
          // Second row: Type and Action buttons
          Row(
            children: [
              if (availableTypes.isNotEmpty) ...[
                _buildTypeFilter(availableTypes),
                const SizedBox(width: 8),
              ],
              const Spacer(),
              _buildActionButtons(),
            ],
          ),
        ],
      );
    } else {
      // Single-row layout for large screens
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildSearchField(),
                const SizedBox(width: 8),
                _buildStatusFilter(),
                if (availableTypes.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _buildTypeFilter(availableTypes),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionButtons(),
        ],
      );
    }
  }

  Widget _buildMinimizedFilters() {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 14,
            color: context.colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'Filters',
            style: context.textStyles.body.copyWith(
              fontSize: 12,
              color: context.colors.textSecondary,
            ),
          ),
          if (widget.searchQuery.isNotEmpty || 
              widget.selectedStatus != 'all' || 
              widget.selectedType != null) ...[
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            onPressed: () => widget.onExpandedChanged(true),
            icon: const Icon(Icons.expand_more),
            iconSize: 14,
            tooltip: 'Expand filters',
            color: context.colors.primary,
            style: IconButton.styleFrom(
              backgroundColor: context.colors.surface,
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(28, 28),
              maximumSize: const Size(28, 28),
              side: BorderSide(
                color: context.colors.primary.withOpacity(0.2),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
          color: context.colors.surface,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 12,
              color: context.colors.primary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Center(
                child: TextField(
                  controller: widget.searchController,
                  onChanged: widget.onSearchChanged,
                  style: context.textStyles.body.copyWith(
                    fontSize: 14,
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search pigtails',
                    hintStyle: context.textStyles.body.copyWith(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ),
            if (widget.searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  widget.searchController.clear();
                  widget.onSearchChanged('');
                },
                child: Icon(
                  Icons.clear,
                  size: 12,
                  color: context.colors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    final width = context.responsive<double>(
      xs: 100,
      sm: 110,
      md: 120,
      lg: 130,
    );
    
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: widget.selectedStatus,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 14,
              color: context.colors.primary,
            ),
            isDense: true,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            style: context.textStyles.body.copyWith(
              fontSize: 12,
              color: context.colors.textPrimary,
            ),
            items: [
              DropdownMenuItem<String>(
                value: 'all',
                child: Text(
                  'All',
                  style: context.textStyles.body.copyWith(fontSize: 12),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'installed',
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: context.colors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Installed',
                      style: context.textStyles.body.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<String>(
                value: 'removed',
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: context.colors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Removed',
                      style: context.textStyles.body.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.onStatusChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilter(List<String> availableTypes) {
    final width = context.responsive<double>(
      xs: 100,
      sm: 110,
      md: 120,
      lg: 130,
    );
    
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String?>(
            value: widget.selectedType,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 14,
              color: context.colors.primary,
            ),
            isDense: true,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            style: context.textStyles.body.copyWith(
              fontSize: 12,
              color: context.colors.textPrimary,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  'All types',
                  style: context.textStyles.body.copyWith(fontSize: 12),
                ),
              ),
              ...availableTypes.map((type) => 
                DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: context.textStyles.body.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ],
            onChanged: widget.onTypeChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onClearFilters,
          icon: const Icon(Icons.cleaning_services),
          iconSize: 16,
          tooltip: 'Clear all filters',
          color: context.colors.error,
          style: IconButton.styleFrom(
            backgroundColor: context.colors.surface,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
            maximumSize: const Size(32, 32),
            side: BorderSide(
              color: context.colors.error.withOpacity(0.2),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => widget.onExpandedChanged(!widget.filtersExpanded),
          icon: Icon(widget.filtersExpanded ? Icons.expand_less : Icons.expand_more),
          iconSize: 16,
          tooltip: widget.filtersExpanded ? 'Minimize filters' : 'Expand filters',
          color: context.colors.primary,
          style: IconButton.styleFrom(
            backgroundColor: context.colors.surface,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
            maximumSize: const Size(32, 32),
            side: BorderSide(
              color: context.colors.primary.withOpacity(0.2),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}