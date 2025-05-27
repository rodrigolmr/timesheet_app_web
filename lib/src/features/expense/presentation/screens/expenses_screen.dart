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

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Expenses',
        subtitle: 'View and manage expense reports',
        actionIcon: Icons.add,
        onActionPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateExpenseDialog(),
          );
        },
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
    
    final cardLastFour = cardAsync.maybeWhen(
      data: (card) => card != null ? card.lastFourDigits : '****',
      orElse: () => '****',
    );
    
    return InkWell(
      onTap: () => context.push('/expenses/${expense.id}'),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.colors.outline.withOpacity(0.3)),
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
              color: context.colors.primary.withOpacity(0.1),
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
        ],
      ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No expenses found',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first expense',
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
}