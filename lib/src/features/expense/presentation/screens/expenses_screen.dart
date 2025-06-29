import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/widgets/expense_filters.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/widgets/create_expense_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';

// Group expenses by month
class ExpensePeriod {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<ExpenseModel> expenses;
  
  ExpensePeriod({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.expenses,
  });
  
  double get totalAmount => expenses.fold(0, (sum, expense) => sum + expense.amount);
}

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  // Controllers and state for filters
  final _dateRangeController = TextEditingController();
  final _dateFormat = DateFormat('MM/dd/yyyy');
  DateTimeRange? _selectedDateRange;
  String? _selectedCard;
  String? _selectedCreator;
  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = null;
    _dateRangeController.text = '';
  }

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    final selectionState = ref.watch(expenseSelectionProvider);
    
    if (selectionState.isSelectionMode) {
      final canDeleteAsync = ref.watch(canDeleteExpenseProvider);
      final canDelete = canDeleteAsync.valueOrNull ?? false;
      
      return AppBar(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        title: Text(
          '${selectionState.selectionCount} selected',
          style: context.textStyles.title.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(expenseSelectionProvider.notifier).exitSelectionMode(),
          tooltip: 'Cancel selection',
        ),
        actions: [
          if (selectionState.hasSelection) ...[
            if (canDelete)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmDialog(selectionState.selectedIds),
                tooltip: 'Delete selected',
              ),
          ],
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleSelectionAction(value),
            itemBuilder: (context) => [
              if (selectionState.hasSelection) ...[
                PopupMenuItem(
                  value: 'generate_pdf',
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: const Text('Generate PDF'),
                    subtitle: Text('${selectionState.selectionCount} selected'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
              ],
              const PopupMenuItem(
                value: 'select_all',
                child: Text('Select All'),
              ),
              const PopupMenuItem(
                value: 'select_none',
                child: Text('Select None'),
              ),
            ],
          ),
        ],
      );
    }
    
    // Check if user can use selection mode (only managers and admins)
    final canUseSelectionModeAsync = ref.watch(canDeleteExpenseProvider);
    final canUseSelectionMode = canUseSelectionModeAsync.valueOrNull ?? false;
    
    return AppHeader(
      title: 'Expenses',
      subtitle: 'View and manage expense reports',
      actions: [
        if (canUseSelectionMode)
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => ref.read(expenseSelectionProvider.notifier).enterSelectionMode(),
            tooltip: 'Select expenses',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(filteredExpensesStreamProvider);
    
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateExpenseDialog(),
          );
        },
        backgroundColor: context.colors.primary,
        tooltip: 'Add expense',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: expensesAsync.when(
              data: (expenses) => _buildExpenseList(context, expenses),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading expenses',
                      style: context.textStyles.title,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return ExpenseFilters(
      dateRangeController: _dateRangeController,
      dateFormat: _dateFormat,
      selectedDateRange: _selectedDateRange,
      selectedCard: _selectedCard,
      selectedCreator: _selectedCreator,
      filtersExpanded: _filtersExpanded,
      onDateRangeChanged: (dateRange) {
        setState(() {
          _selectedDateRange = dateRange;
          if (dateRange != null) {
            _dateRangeController.text = '${_dateFormat.format(dateRange.start)} - ${_dateFormat.format(dateRange.end)}';
          }
        });
      },
      onCardChanged: (card) {
        setState(() {
          _selectedCard = card;
        });
      },
      onCreatorChanged: (creator) {
        setState(() {
          _selectedCreator = creator;
        });
      },
      onExpandedChanged: (expanded) {
        setState(() {
          _filtersExpanded = expanded;
        });
      },
      onClearFilters: _clearAllFilters,
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCard = null;
      _selectedCreator = null;
      _selectedDateRange = null;
      _dateRangeController.text = '';
    });
  }

  Widget _buildExpenseList(BuildContext context, List<ExpenseModel> expenses) {
    // Filter expenses based on selected filters
    var filteredExpenses = expenses;
    
    if (_selectedDateRange != null) {
      filteredExpenses = filteredExpenses.where((expense) {
        return expense.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
               expense.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    
    if (_selectedCard != null) {
      filteredExpenses = filteredExpenses.where((expense) => expense.cardId == _selectedCard).toList();
    }
    
    if (_selectedCreator != null) {
      filteredExpenses = filteredExpenses.where((expense) => expense.userId == _selectedCreator).toList();
    }
    
    if (filteredExpenses.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group expenses by month
    final groupedExpenses = _groupExpensesByMonth(filteredExpenses);
    
    final isMobile = context.screenWidth < 400;
    
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      itemCount: groupedExpenses.length,
      itemBuilder: (context, groupIndex) {
        final group = groupedExpenses[groupIndex];
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: isMobile ? 8 : 12,
                  height: isMobile ? 8 : 12,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (groupIndex < groupedExpenses.length - 1)
                  Container(
                    width: 2,
                    height: (group.expenses.length * 34.0) + 50,
                    color: context.colors.outline,
                  ),
              ],
            ),
            
            SizedBox(width: isMobile ? 8 : 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period header
                  Text(
                    group.title,
                    style: context.textStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 14 : null,
                    ),
                  ),
                  Text(
                    '\$${group.totalAmount.toStringAsFixed(2)} • ${group.expenses.length} expenses',
                    style: context.textStyles.caption.copyWith(
                      fontSize: isMobile ? 11 : null,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Compact expense items
                  ...group.expenses.map((expense) => _buildCompactExpenseItem(
                    context, 
                    expense,
                  )),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Cache para armazenar nomes de usuários já consultados
  static final Map<String, String> _userNameCache = {};
  
  Future<String> _getUserName(WidgetRef ref, String userId) async {
    if (userId.isEmpty) {
      return 'Admin';
    }
    
    // Se já temos o nome em cache, retorna imediatamente
    if (_userNameCache.containsKey(userId)) {
      return _userNameCache[userId]!;
    }
    
    // Primeiro, tenta obter diretamente por ID (forma mais rápida)
    try {
      final user = await ref.read(userRepositoryProvider).getById(userId);
      if (user != null) {
        final name = '${user.firstName} ${user.lastName}';
        _userNameCache[userId] = name; // Armazena em cache
        return name;
      }
    } catch (e) {
      // Ignora o erro e tenta o próximo método
    }
    
    // Tenta obter a lista completa de usuários
    try {
      final users = await ref.read(usersProvider.future);
      for (final user in users) {
        // Compara tanto o ID quanto o authUid
        if (user.id == userId || user.authUid == userId) {
          final name = '${user.firstName} ${user.lastName}';
          _userNameCache[userId] = name; // Armazena em cache
          return name;
        }
      }
    } catch (e) {
      // Ignora o erro
    }
    
    // Define um valor padrão para o cache
    _userNameCache[userId] = 'Unknown User';
    return 'Unknown User';
  }

  Widget _buildCompactExpenseItem(BuildContext context, ExpenseModel expense) {
    // Get card information
    final cardAsync = ref.watch(companyCardProvider(expense.cardId));
    final selectionState = ref.watch(expenseSelectionProvider);
    final isSelected = selectionState.isSelected(expense.id);
    
    final cardLastFour = cardAsync.maybeWhen(
      data: (card) => card != null ? card.lastFourDigits : '****',
      orElse: () => '****',
    );
    
    return InkWell(
      onTap: () {
        if (selectionState.isSelectionMode) {
          ref.read(expenseSelectionProvider.notifier).toggleSelection(expense.id);
        } else {
          context.push('/expenses/${expense.id}');
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? context.colors.primary.withValues(alpha: 0.1)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected 
                ? context.colors.primary 
                : context.colors.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
        children: [
          // Date
          SizedBox(
            width: 45,
            child: Text(
              DateFormat('MMM d').format(expense.date),
              style: context.textStyles.caption.copyWith(
                fontSize: 11,
                color: context.colors.textSecondary,
              ),
            ),
          ),
          
          // Card last 4 digits
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              cardLastFour,
              style: context.textStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Creator name (expandable) - usando FutureBuilder como no job_record_card
          Expanded(
            child: FutureBuilder<String>(
              future: _getUserName(ref, expense.userId),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? 'Loading...';
                return Text(
                  userName,
                  style: context.textStyles.caption.copyWith(
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Amount
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: context.textStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          
          // Selection checkbox on the right
          if (selectionState.isSelectionMode) ...[
            const SizedBox(width: 8),
            Checkbox(
              value: isSelected,
              onChanged: (_) => ref.read(expenseSelectionProvider.notifier).toggleSelection(expense.id),
              activeColor: context.colors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ],
      ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    // Verifica se há filtros ativos
    final hasFilters = _selectedCard != null || 
                      _selectedDateRange != null || 
                      _selectedCreator != null;
    
    // Mensagem baseada no role e filtros
    final userRoleAsync = ref.read(currentUserRoleProvider);
    final message = userRoleAsync.when(
      data: (role) {
        if (hasFilters) {
          return 'No expenses found matching your filters';
        }
        if (role == UserRole.user) {
          return 'You have no expenses yet';
        } else {
          return 'No expenses found';
        }
      },
      loading: () => 'No expenses found',
      error: (_, __) => 'No expenses found',
    );
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 120,
            color: context.colors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters ? 'Try adjusting your filters' : 'Start by adding your first expense',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const CreateExpenseDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Expense'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  List<ExpensePeriod> _groupExpensesByMonth(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    
    for (final expense in expenses) {
      final key = DateFormat('yyyy-MM').format(expense.date);
      grouped[key] = (grouped[key] ?? [])..add(expense);
    }
    
    // Sort by date within each group
    grouped.forEach((key, list) {
      list.sort((a, b) => b.date.compareTo(a.date));
    });
    
    // Convert to ExpensePeriod objects
    final periods = grouped.entries.map((entry) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      return ExpensePeriod(
        title: DateFormat('MMMM yyyy').format(startDate),
        startDate: startDate,
        endDate: endDate,
        expenses: entry.value,
      );
    }).toList();
    
    // Sort periods by date (most recent first)
    periods.sort((a, b) => b.startDate.compareTo(a.startDate));
    
    return periods;
  }

  Color _getStatusColor(BuildContext context, ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return context.colors.success;
      case ExpenseStatus.pending:
        return context.colors.warning;
      case ExpenseStatus.rejected:
        return context.colors.error;
    }
  }

  void _handleSelectionAction(String action) {
    final expenses = ref.read(filteredExpensesStreamProvider).valueOrNull ?? [];
    final filteredExpenses = _getFilteredExpenses(expenses);
    final allIds = filteredExpenses.map((expense) => expense.id).toList();
    
    switch (action) {
      case 'select_all':
        ref.read(expenseSelectionProvider.notifier).selectAll(allIds);
        break;
      case 'select_none':
        ref.read(expenseSelectionProvider.notifier).selectNone();
        break;
      case 'generate_pdf':
        _generatePdfForSelected();
        break;
    }
  }

  List<ExpenseModel> _getFilteredExpenses(List<ExpenseModel> expenses) {
    var filteredExpenses = expenses;
    
    if (_selectedDateRange != null) {
      filteredExpenses = filteredExpenses.where((expense) {
        return expense.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
               expense.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    
    if (_selectedCard != null) {
      filteredExpenses = filteredExpenses.where((expense) => expense.cardId == _selectedCard).toList();
    }
    
    if (_selectedCreator != null) {
      filteredExpenses = filteredExpenses.where((expense) => expense.userId == _selectedCreator).toList();
    }
    
    return filteredExpenses;
  }

  void _showDeleteConfirmDialog(Set<String> selectedIds) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete Expenses',
      message: 'Are you sure you want to delete ${selectedIds.length} expense${selectedIds.length > 1 ? 's' : ''}? This action cannot be undone.',
      confirmText: 'Delete',
      actionType: ConfirmActionType.danger,
    );
    
    if (confirmed == true) {
      _deleteSelectedExpenses(selectedIds);
    }
  }

  void _deleteSelectedExpenses(Set<String> selectedIds) async {
    // Verificar permissão para deletar
    final canDelete = await ref.read(canDeleteExpenseProvider.future);
    
    if (!canDelete) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Permission Denied',
          message: 'You do not have permission to delete expenses.',
        );
      }
      return;
    }
    
    // Mostrar loading
    showAppProgressDialog(
      context: context,
      title: 'Deleting Expenses',
      message: 'Please wait...',
    );
    
    try {
      // Deletar cada despesa
      int successCount = 0;
      int errorCount = 0;
      
      for (final id in selectedIds) {
        try {
          await ref.read(expenseStateProvider(id).notifier).delete(id);
          successCount++;
        } catch (e) {
          errorCount++;
          debugPrint('Error deleting expense $id: $e');
        }
      }
      
      // Fechar loading
      if (mounted) Navigator.of(context).pop();
      
      // Mostrar resultado
      if (mounted) {
        if (errorCount == 0) {
          await showSuccessDialog(
            context: context,
            title: 'Success',
            message: 'Successfully deleted $successCount expense${successCount > 1 ? 's' : ''}.',
          );
        } else {
          await showWarningDialog(
            context: context,
            title: 'Partial Success',
            message: 'Deleted $successCount expense${successCount > 1 ? 's' : ''}, $errorCount failed.',
          );
        }
      }
      
      // Remover despesas deletadas da seleção e sair do modo seleção se necessário
      ref.read(expenseSelectionProvider.notifier).removeDeletedExpenses(
        selectedIds.where((id) => successCount > 0).toSet()
      );
      
      // Se todos foram deletados, sair do modo seleção
      if (successCount == selectedIds.length) {
        ref.read(expenseSelectionProvider.notifier).exitSelectionMode();
      }
    } catch (e) {
      // Fechar loading
      if (mounted) Navigator.of(context).pop();
      
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to delete expenses: $e',
        );
      }
    }
  }

  void _generatePdfForSelected() async {
    final selectionState = ref.read(expenseSelectionProvider);
    
    // Show progress dialog
    showAppProgressDialog(
      context: context,
      title: 'Generating PDF',
      message: 'Processing ${selectionState.selectionCount} expenses...',
    );
    
    try {
      // Generate PDF
      final pdfBytes = await ref.read(expenseSelectionProvider.notifier).generatePdfForSelected(ref);
      
      // Close progress dialog
      if (mounted) Navigator.of(context).pop();
      
      // Open PDF in new window
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      
      // Show success message
      if (mounted) {
        await showSuccessDialog(
          context: context,
          title: 'PDF Generated',
          message: 'Your expense report has been opened in a new window.',
        );
      }
    } catch (e) {
      // Close progress dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to generate PDF: $e',
        );
      }
    }
  }
}