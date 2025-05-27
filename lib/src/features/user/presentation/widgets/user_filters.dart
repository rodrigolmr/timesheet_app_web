import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class UserFilters extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedStatus;
  final bool filtersExpanded;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onClearFilters;

  const UserFilters({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedStatus,
    required this.filtersExpanded,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onExpandedChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<UserFilters> createState() => _UserFiltersState();
}

class _UserFiltersState extends ConsumerState<UserFilters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(xs: 12, sm: 16, md: 20),
        vertical: context.responsive<double>(xs: 4, sm: 6, md: 8),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildSearchField(),
            const SizedBox(width: 8),
            _buildStatusFilter(),
            const SizedBox(width: 8),
            _buildActionButtons(),
          ],
        ),
      ],
    );
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
          if (widget.searchQuery.isNotEmpty || widget.selectedStatus != 'all') ...[
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
      flex: 2,
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
                    hintText: 'Search users',
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
    return Container(
      width: 120,
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
                value: 'active',
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
                      'Active',
                      style: context.textStyles.body.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<String>(
                value: 'inactive',
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
                      'Inactive',
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