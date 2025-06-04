import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';

/// Widget de filtros para job records seguindo padrões do GUIDE.md
class JobRecordFilters extends ConsumerStatefulWidget {
  final TextEditingController dateRangeController;
  final TextEditingController searchController;
  final DateFormat dateFormat;
  final DateTimeRange? selectedDateRange;
  final String searchQuery;
  final String? selectedCreator;
  final JobRecordStatus? selectedStatus;
  final bool filtersExpanded;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCreatorChanged;
  final ValueChanged<JobRecordStatus?> onStatusChanged;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onClearFilters;

  const JobRecordFilters({
    super.key,
    required this.dateRangeController,
    required this.searchController,
    required this.dateFormat,
    required this.selectedDateRange,
    required this.searchQuery,
    required this.selectedCreator,
    required this.selectedStatus,
    required this.filtersExpanded,
    required this.onDateRangeChanged,
    required this.onSearchChanged,
    required this.onCreatorChanged,
    required this.onStatusChanged,
    required this.onExpandedChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<JobRecordFilters> createState() => _JobRecordFiltersState();
}

class _JobRecordFiltersState extends ConsumerState<JobRecordFilters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(xs: 12, sm: 16, md: 20),
        vertical: context.responsive<double>(xs: 8, sm: 10, md: 12),
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
      child: widget.filtersExpanded
          ? _buildExpandedFilters()
          : _buildMinimizedFilters(),
    );
  }

  Widget _buildExpandedFilters() {
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primeira linha - Date range e Creator (se admin/manager)
        userRoleAsync.when(
          data: (role) {
            if (role == UserRole.admin || role == UserRole.manager) {
              if (isSmallScreen) {
                // Em telas pequenas, usar Flex ao invés de Expanded
                return IntrinsicHeight(
                  child: Row(
                    children: [
                      Flexible(flex: 1, child: _buildDateRangeFieldCompact()),
                      const SizedBox(width: 6),
                      Flexible(flex: 1, child: _buildCreatorDropdownCompact()),
                    ],
                  ),
                );
              } else {
                // Em telas maiores
                return Row(
                  children: [
                    Expanded(child: _buildDateRangeFieldCompact()),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCreatorDropdownCompact()),
                  ],
                );
              }
            } else {
              // Usuário normal - apenas date range
              return _buildDateRangeFieldCompact();
            }
          },
          loading: () => _buildDateRangeFieldCompact(),
          error: (_, __) => _buildDateRangeFieldCompact(),
        ),
        const SizedBox(height: 8),
        // Segunda linha - Search, Status e Actions
        IntrinsicHeight(
          child: Row(
            children: [
              Flexible(
                flex: isSmallScreen ? 3 : 2, 
                child: _buildSearchFieldCompact()
              ),
              const SizedBox(width: 6),
              if (isSmallScreen) ...[
                _buildStatusDropdownCompact(),
              ] else ...[
                Flexible(flex: 1, child: _buildStatusDropdownCompact()),
              ],
              const SizedBox(width: 6),
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinimizedFilters() {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: context.colors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Filters',
            style: context.textStyles.body.copyWith(
              fontSize: 14,
              color: context.colors.textSecondary,
            ),
          ),
          // Indicadores dos filtros ativos
          if (widget.searchQuery.isNotEmpty || 
              widget.selectedCreator != null || 
              widget.selectedStatus != null ||
              widget.selectedDateRange != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getActiveFiltersCount().toString(),
                style: context.textStyles.caption.copyWith(
                  fontSize: 12,
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          // Botão para expandir
          IconButton(
            onPressed: () => widget.onExpandedChanged(true),
            icon: const Icon(Icons.expand_more),
            iconSize: 18,
            tooltip: 'Expand filters',
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
      ),
    );
  }

  Widget _buildDateRangeFieldCompact() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              initialDateRange: widget.selectedDateRange,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: context.colors.primary,
                      onPrimary: context.colors.onPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            
            if (picked != null) {
              widget.onDateRangeChanged(picked);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 16,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.selectedDateRange != null 
                            ? widget.dateFormat.format(widget.selectedDateRange!.start)
                            : "Start date",
                        style: context.textStyles.caption.copyWith(
                          fontSize: 11,
                          color: widget.selectedDateRange != null 
                              ? context.colors.textPrimary 
                              : context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.selectedDateRange != null 
                            ? widget.dateFormat.format(widget.selectedDateRange!.end)
                            : "End date",
                        style: context.textStyles.caption.copyWith(
                          fontSize: 11,
                          color: widget.selectedDateRange != null 
                              ? context.colors.textPrimary 
                              : context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: context.colors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorDropdownCompact() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final creatorsAsync = ref.watch(jobRecordCreatorsProvider);
          
          return creatorsAsync.when(
            data: (creators) {
              return DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String?>(
                    value: widget.selectedCreator,
                    hint: Text(
                      'All Creators',
                      style: context.textStyles.caption.copyWith(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    isDense: true,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    style: context.textStyles.caption.copyWith(
                      fontSize: 12,
                      color: context.colors.textPrimary,
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(
                          'All Creators',
                          style: context.textStyles.caption.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ...creators.map((creator) => DropdownMenuItem<String?>(
                        value: creator.id,
                        child: Text(
                          creator.name,
                          style: context.textStyles.caption.copyWith(
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                    ],
                    onChanged: widget.onCreatorChanged,
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const Center(
              child: Icon(Icons.error_outline, size: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchFieldCompact() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.search,
              size: 16,
              color: context.colors.primary,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.searchController,
              onChanged: widget.onSearchChanged,
              autocorrect: false,
              enableSuggestions: false,
              autofillHints: const [], // Desabilita autofill
              style: context.textStyles.caption.copyWith(
                fontSize: 12,
                color: context.colors.textPrimary,
                backgroundColor: Colors.transparent,
              ),
              cursorColor: context.colors.primary,
              decoration: InputDecoration(
                hintText: 'Search records',
                hintStyle: context.textStyles.caption.copyWith(
                  fontSize: 12,
                  color: context.colors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
            ),
          ),
          if (widget.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  widget.searchController.clear();
                  widget.onSearchChanged('');
                },
                child: Icon(
                  Icons.clear,
                  size: 16,
                  color: context.colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdownCompact() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 90 : 120,
        maxWidth: isSmallScreen ? 110 : 150,
      ),
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: context.colors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<JobRecordStatus?>(
            value: widget.selectedStatus,
            hint: Text(
              'All Status',
              style: context.textStyles.caption.copyWith(
                fontSize: 12,
                color: context.colors.textSecondary,
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: context.colors.primary,
            ),
            isDense: true,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            style: context.textStyles.caption.copyWith(
              fontSize: 12,
              color: context.colors.textPrimary,
            ),
            items: [
              DropdownMenuItem<JobRecordStatus?>(
                value: null,
                child: Text(
                  'All Status',
                  style: context.textStyles.caption.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              ...JobRecordStatus.values.map((status) => DropdownMenuItem<JobRecordStatus?>(
                value: status,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status.icon,
                      style: context.textStyles.caption.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        status.displayName,
                        style: context.textStyles.caption.copyWith(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )),
            ],
            onChanged: widget.onStatusChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clear button
        IconButton(
          onPressed: widget.onClearFilters,
          icon: const Icon(Icons.filter_alt_off),
          iconSize: 18,
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
        // Minimize button
        IconButton(
          onPressed: () => widget.onExpandedChanged(false),
          icon: const Icon(Icons.expand_less),
          iconSize: 18,
          tooltip: 'Minimize filters',
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

  int _getActiveFiltersCount() {
    int count = 0;
    if (widget.searchQuery.isNotEmpty) count++;
    if (widget.selectedCreator != null) count++;
    if (widget.selectedStatus != null) count++;
    if (widget.selectedDateRange != null) count++;
    return count;
  }
}