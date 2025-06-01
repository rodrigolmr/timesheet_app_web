import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

/// Widget de filtros para job records seguindo padrões do GUIDE.md
class JobRecordFilters extends ConsumerStatefulWidget {
  final TextEditingController dateRangeController;
  final TextEditingController searchController;
  final DateFormat dateFormat;
  final DateTimeRange? selectedDateRange;
  final String searchQuery;
  final String? selectedCreator;
  final bool filtersExpanded;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCreatorChanged;
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
    required this.filtersExpanded,
    required this.onDateRangeChanged,
    required this.onSearchChanged,
    required this.onCreatorChanged,
    required this.onExpandedChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<JobRecordFilters> createState() => _JobRecordFiltersState();
}

class _JobRecordFiltersState extends ConsumerState<JobRecordFilters> {
  @override
  Widget build(BuildContext context) {
    // Check if user can view all records (only managers and admins)
    final canViewAllAsync = ref.watch(canViewAllJobRecordsProvider);
    final canViewAll = canViewAllAsync.valueOrNull ?? false;
    
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
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primeira linha: Date Range + Creator (se não for user regular)
        userRoleAsync.when(
          data: (role) {
            if (role == UserRole.admin || role == UserRole.manager) {
              return Row(
                children: [
                  _buildDateRangeField(),
                  const SizedBox(width: 8),
                  _buildCreatorDropdown(),
                ],
              );
            } else {
              return _buildDateRangeField();
            }
          },
          loading: () => _buildDateRangeField(),
          error: (_, __) => _buildDateRangeField(),
        ),
        const SizedBox(height: 6),
        // Segunda linha: Search + Botões
        Row(
          children: [
            _buildSearchField(),
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
          // Indicadores dos filtros ativos
          if (widget.searchQuery.isNotEmpty || widget.selectedCreator != null) ...[
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
          // Botão para expandir usando IconButton padrão do Flutter
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

  Widget _buildDateRangeField() {
    return Expanded(
      flex: 1,
      child: GestureDetector(
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
                Icons.date_range,
                size: 12,
                color: context.colors.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.selectedDateRange != null 
                          ? widget.dateFormat.format(widget.selectedDateRange!.start) 
                          : "Start date",
                      style: context.textStyles.body.copyWith(
                        fontSize: 14,
                        height: 1.0,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.selectedDateRange != null 
                          ? widget.dateFormat.format(widget.selectedDateRange!.end) 
                          : "End date",
                      style: context.textStyles.body.copyWith(
                        fontSize: 14,
                        height: 1.0,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 12,
                color: context.colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorDropdown() {
    return Expanded(
      flex: 1,
      child: Container(
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
                        'Creator',
                        style: context.textStyles.body.copyWith(
                          fontSize: 12,
                          color: context.colors.textSecondary,
                        ),
                      ),
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
                            'All',
                            style: context.textStyles.body.copyWith(fontSize: 12),
                          ),
                        ),
                        ...creators.map((creator) => DropdownMenuItem<String?>(
                          value: creator.id,
                          child: Text(
                            creator.name,
                            style: context.textStyles.body.copyWith(fontSize: 12),
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
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const Center(
                child: Icon(Icons.error_outline, size: 14),
              ),
            );
          },
        ),
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
                    hintText: 'Search records',
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Clear button using Flutter's IconButton
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
        // Minimize/Expand button using Flutter's IconButton
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