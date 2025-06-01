import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

/// Widget de filtros para expenses seguindo o mesmo padrão de job_record_filters
class ExpenseFilters extends ConsumerStatefulWidget {
  final TextEditingController dateRangeController;
  final DateFormat dateFormat;
  final DateTimeRange? selectedDateRange;
  final String? selectedCard;
  final String? selectedCreator;
  final bool filtersExpanded;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final ValueChanged<String?> onCardChanged;
  final ValueChanged<String?> onCreatorChanged;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onClearFilters;

  const ExpenseFilters({
    super.key,
    required this.dateRangeController,
    required this.dateFormat,
    required this.selectedDateRange,
    required this.selectedCard,
    required this.selectedCreator,
    required this.filtersExpanded,
    required this.onDateRangeChanged,
    required this.onCardChanged,
    required this.onCreatorChanged,
    required this.onExpandedChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<ExpenseFilters> createState() => _ExpenseFiltersState();
}

class _ExpenseFiltersState extends ConsumerState<ExpenseFilters> {
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
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primeira linha: Date Range + Card
        Row(
          children: [
            _buildDateRangeField(),
            const SizedBox(width: 8),
            _buildCardDropdown(),
          ],
        ),
        const SizedBox(height: 6),
        // Segunda linha: Creator (se não for user regular) + Botões
        userRoleAsync.when(
          data: (role) {
            if (role == UserRole.admin || role == UserRole.manager) {
              return Row(
                children: [
                  _buildCreatorDropdown(),
                  const SizedBox(width: 8),
                  _buildActionButtons(),
                ],
              );
            }
            return _buildActionButtons();
          },
          loading: () => _buildActionButtons(),
          error: (_, __) => _buildActionButtons(),
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
          if (widget.selectedCard != null || widget.selectedCreator != null || widget.selectedDateRange != null) ...[
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

  Widget _buildCardDropdown() {
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
            final cardsAsync = ref.watch(companyCardsProvider);
            
            return cardsAsync.when(
              data: (cards) {
                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String?>(
                      value: widget.selectedCard,
                      hint: Text(
                        'Card',
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
                            'All Cards',
                            style: context.textStyles.body.copyWith(fontSize: 12),
                          ),
                        ),
                        ...cards.map((card) => DropdownMenuItem<String?>(
                          value: card.id,
                          child: Text(
                            '${card.holderName} (${card.lastFourDigits})',
                            style: context.textStyles.body.copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ],
                      onChanged: widget.onCardChanged,
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
            final creatorsAsync = ref.watch(expenseCreatorsProvider);
            
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