import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';

// Classe para agrupar expenses por período
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
  
  int get pendingCount => expenses.where((e) => e.status == ExpenseStatus.pending).length;
  int get approvedCount => expenses.where((e) => e.status == ExpenseStatus.approved).length;
  int get rejectedCount => expenses.where((e) => e.status == ExpenseStatus.rejected).length;
}

/// Página de demonstração com várias opções de visualização de expenses
class ExpenseVisualizationsDemo extends ConsumerStatefulWidget {
  const ExpenseVisualizationsDemo({super.key});

  @override
  ConsumerState<ExpenseVisualizationsDemo> createState() => _ExpenseVisualizationsDemoState();
}

class _ExpenseVisualizationsDemoState extends ConsumerState<ExpenseVisualizationsDemo> {
  int _selectedViewOption = 0;
  String _groupingMode = 'month'; // month, week, category, status
  
  // Lista de opções de visualização
  final List<String> _viewOptions = [
    'Cards Grid',
    'Detailed List',
    'Compact Timeline',
    'Summary Cards',
    'Analytics View',
  ];
  
  final List<Map<String, dynamic>> _groupingOptions = [
    {'value': 'month', 'label': 'By Month', 'icon': Icons.calendar_month},
    {'value': 'week', 'label': 'By Week', 'icon': Icons.view_week},
    {'value': 'category', 'label': 'By Category', 'icon': Icons.category},
    {'value': 'status', 'label': 'By Status', 'icon': Icons.flag},
  ];
  
  // Helper to extract category from description
  String _getCategoryFromExpense(ExpenseModel expense) {
    // Extract category from description pattern "Expense for CATEGORY - Item X"
    final match = RegExp(r'Expense for (\w+) -').firstMatch(expense.description);
    return match?.group(1) ?? 'Other';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Visualizations Demo'),
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
      ),
      body: Column(
        children: [
          // View selector
          Container(
            color: context.colors.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  _viewOptions.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_viewOptions[index]),
                      selected: _selectedViewOption == index,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedViewOption = index;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Grouping selector (only for some views)
          if ([0, 1, 2].contains(_selectedViewOption))
            Container(
              color: context.colors.background,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _groupingOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        avatar: Icon(option['icon'], size: 18),
                        label: Text(option['label']),
                        selected: _groupingMode == option['value'],
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _groupingMode = option['value'];
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          
          // Main content
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectedView() {
    switch (_selectedViewOption) {
      case 0:
        return _buildCardsGridView();
      case 1:
        return _buildDetailedListView();
      case 2:
        return _buildCompactTimelineView();
      case 3:
        return _buildSummaryCardsView();
      case 4:
        return _buildAnalyticsView();
      default:
        return _buildCardsGridView();
    }
  }
  
  // Generate mock expense data
  List<ExpenseModel> _getMockExpenses() {
    final now = DateTime.now();
    final expenses = <ExpenseModel>[];
    
    // Categories for variety
    final categories = ['Food', 'Transportation', 'Accommodation', 'Equipment', 'Supplies', 'Other'];
    final statuses = ExpenseStatus.values;
    
    // Generate expenses for the last 3 months
    for (int monthOffset = 0; monthOffset < 3; monthOffset++) {
      final month = DateTime(now.year, now.month - monthOffset, 1);
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      
      // Generate 5-10 expenses per month
      final expenseCount = 5 + (monthOffset * 2);
      for (int i = 0; i < expenseCount; i++) {
        final day = (i * 3 + 1) % daysInMonth + 1;
        final date = DateTime(month.year, month.month, day);
        final category = categories[i % categories.length];
        
        expenses.add(ExpenseModel(
          id: 'exp-${date.millisecondsSinceEpoch}-$i',
          userId: 'user-1',
          cardId: 'card-${i % 3}',
          description: 'Expense for $category - Item ${i + 1}',
          amount: 50.0 + (i * 25.5),
          imageUrl: 'https://example.com/receipt-$i.jpg',
          date: date,
          status: statuses[i % statuses.length],
          createdAt: date,
          updatedAt: date,
        ));
      }
    }
    
    return expenses..sort((a, b) => b.date.compareTo(a.date));
  }
  
  // Group expenses based on selected mode
  List<ExpensePeriod> _groupExpenses(List<ExpenseModel> expenses) {
    switch (_groupingMode) {
      case 'week':
        return _groupByWeek(expenses);
      case 'category':
        return _groupByCategory(expenses);
      case 'status':
        return _groupByStatus(expenses);
      default:
        return _groupByMonth(expenses);
    }
  }
  
  List<ExpensePeriod> _groupByMonth(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    
    for (final expense in expenses) {
      final key = DateFormat('yyyy-MM').format(expense.date);
      grouped[key] = (grouped[key] ?? [])..add(expense);
    }
    
    return grouped.entries.map((entry) {
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
  }
  
  List<ExpensePeriod> _groupByWeek(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    
    for (final expense in expenses) {
      final weekStart = _getWeekStart(expense.date);
      final key = DateFormat('yyyy-MM-dd').format(weekStart);
      grouped[key] = (grouped[key] ?? [])..add(expense);
    }
    
    return grouped.entries.map((entry) {
      final startDate = DateTime.parse(entry.key);
      final endDate = startDate.add(const Duration(days: 6));
      
      return ExpensePeriod(
        title: 'Week of ${DateFormat('MMM d').format(startDate)}',
        startDate: startDate,
        endDate: endDate,
        expenses: entry.value,
      );
    }).toList();
  }
  
  List<ExpensePeriod> _groupByCategory(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    
    for (final expense in expenses) {
      final category = _getCategoryFromExpense(expense);
      grouped[category] = (grouped[category] ?? [])..add(expense);
    }
    
    final now = DateTime.now();
    return grouped.entries.map((entry) {
      return ExpensePeriod(
        title: entry.key,
        startDate: DateTime(now.year, now.month - 2, 1),
        endDate: now,
        expenses: entry.value,
      );
    }).toList()..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }
  
  List<ExpensePeriod> _groupByStatus(List<ExpenseModel> expenses) {
    final grouped = <ExpenseStatus, List<ExpenseModel>>{};
    
    for (final expense in expenses) {
      grouped[expense.status] = (grouped[expense.status] ?? [])..add(expense);
    }
    
    final now = DateTime.now();
    return grouped.entries.map((entry) {
      return ExpensePeriod(
        title: entry.key.name.toUpperCase(),
        startDate: DateTime(now.year, now.month - 2, 1),
        endDate: now,
        expenses: entry.value,
      );
    }).toList();
  }
  
  DateTime _getWeekStart(DateTime date) {
    final dayOfWeek = date.weekday;
    return date.subtract(Duration(days: dayOfWeek - 1));
  }
  
  // VIEW 1: Cards Grid
  Widget _buildCardsGridView() {
    final expenses = _getMockExpenses();
    final groups = _groupExpenses(expenses);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    group.title,
                    style: context.textStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$${group.totalAmount.toStringAsFixed(2)}',
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Expense cards grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.responsive<int>(xs: 1, sm: 2, md: 3, lg: 4),
                childAspectRatio: context.responsive<double>(xs: 3, sm: 2.5, md: 2.2),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: group.expenses.length,
              itemBuilder: (context, expenseIndex) {
                final expense = group.expenses[expenseIndex];
                return _buildExpenseCard(expense);
              },
            ),
            
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
  
  Widget _buildExpenseCard(ExpenseModel expense) {
    final statusColor = _getStatusColor(expense.status);
    
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getCategoryFromExpense(expense),
                    style: context.textStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Description
            Text(
              expense.description,
              style: context.textStyles.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            // Footer with amount and date
            Row(
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: context.textStyles.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM d').format(expense.date),
                  style: context.textStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // VIEW 2: Detailed List
  Widget _buildDetailedListView() {
    final expenses = _getMockExpenses();
    final groups = _groupExpenses(expenses);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header with summary
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.title,
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${group.expenses.length} expenses',
                        style: context.textStyles.caption,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${group.totalAmount.toStringAsFixed(2)}',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          if (group.approvedCount > 0) ...[
                            Icon(Icons.check_circle, size: 12, color: context.colors.success),
                            const SizedBox(width: 2),
                            Text('${group.approvedCount}', style: context.textStyles.caption),
                            const SizedBox(width: 8),
                          ],
                          if (group.pendingCount > 0) ...[
                            Icon(Icons.pending, size: 12, color: context.colors.warning),
                            const SizedBox(width: 2),
                            Text('${group.pendingCount}', style: context.textStyles.caption),
                            const SizedBox(width: 8),
                          ],
                          if (group.rejectedCount > 0) ...[
                            Icon(Icons.cancel, size: 12, color: context.colors.error),
                            const SizedBox(width: 2),
                            Text('${group.rejectedCount}', style: context.textStyles.caption),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Expense list items
            ...group.expenses.map((expense) => _buildDetailedListItem(expense)),
            
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
  
  Widget _buildDetailedListItem(ExpenseModel expense) {
    final statusColor = _getStatusColor(expense.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.outline),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(_getCategoryFromExpense(expense)),
            color: statusColor,
          ),
        ),
        title: Text(
          expense.description,
          style: context.textStyles.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Row(
          children: [
            Text(_getCategoryFromExpense(expense)),
            const SizedBox(width: 8),
            Text('•'),
            const SizedBox(width: 8),
            Text(DateFormat('MMM d, yyyy').format(expense.date)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: context.textStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                expense.status.name,
                style: context.textStyles.caption.copyWith(
                  color: statusColor,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // VIEW 3: Compact Timeline
  Widget _buildCompactTimelineView() {
    final expenses = _getMockExpenses();
    final groups = _groupExpenses(expenses);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (groupIndex < groups.length - 1)
                  Container(
                    width: 2,
                    height: 100.0 * group.expenses.length,
                    color: context.colors.outline,
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
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
                    ),
                  ),
                  Text(
                    '\$${group.totalAmount.toStringAsFixed(2)} • ${group.expenses.length} expenses',
                    style: context.textStyles.caption,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Compact expense items
                  ...group.expenses.map((expense) => _buildCompactTimelineItem(expense)),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildCompactTimelineItem(ExpenseModel expense) {
    final statusColor = _getStatusColor(expense.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.outline.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          
          // Category icon
          Icon(
            _getCategoryIcon(_getCategoryFromExpense(expense)),
            size: 16,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: 8),
          
          // Description
          Expanded(
            child: Text(
              expense.description,
              style: context.textStyles.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Amount
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: context.textStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // VIEW 4: Summary Cards
  Widget _buildSummaryCardsView() {
    final expenses = _getMockExpenses();
    final totalAmount = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final averageAmount = totalAmount / expenses.length;
    
    // Group by status for summary
    final statusGroups = <ExpenseStatus, List<ExpenseModel>>{};
    for (final expense in expenses) {
      statusGroups[expense.status] = (statusGroups[expense.status] ?? [])..add(expense);
    }
    
    // Group by category for top categories
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      final category = _getCategoryFromExpense(expense);
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
    }
    final topCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: context.responsive<int>(xs: 2, sm: 2, md: 4),
            childAspectRatio: context.responsive<double>(xs: 1.5, sm: 1.8, md: 1.5),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildSummaryCard(
                'Total Expenses',
                '\$${totalAmount.toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                context.colors.primary,
              ),
              _buildSummaryCard(
                'Average Expense',
                '\$${averageAmount.toStringAsFixed(2)}',
                Icons.analytics,
                context.colors.secondary,
              ),
              _buildSummaryCard(
                'Total Count',
                expenses.length.toString(),
                Icons.receipt_long,
                context.colors.info,
              ),
              _buildSummaryCard(
                'This Month',
                '\$${_getCurrentMonthTotal(expenses).toStringAsFixed(2)}',
                Icons.calendar_today,
                context.colors.success,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Status breakdown
          Text(
            'Status Breakdown',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: ExpenseStatus.values.map((status) {
              final count = statusGroups[status]?.length ?? 0;
              final amount = statusGroups[status]?.fold(0.0, (sum, e) => sum + e.amount) ?? 0.0;
              final percentage = expenses.isEmpty ? 0.0 : (count / expenses.length) * 100;
              
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(status).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        status.name.toUpperCase(),
                        style: context.textStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: context.textStyles.caption,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: context.textStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Top categories
          Text(
            'Top Categories',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ...topCategories.take(5).map((entry) {
            final percentage = (entry.value / totalAmount) * 100;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(entry.key),
                        size: 20,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(entry.key),
                      const Spacer(),
                      Text(
                        '\$${entry.value.toStringAsFixed(2)}',
                        style: context.textStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 8,
                      backgroundColor: context.colors.outline,
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            title,
            style: context.textStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  // VIEW 5: Analytics View
  Widget _buildAnalyticsView() {
    final expenses = _getMockExpenses();
    
    // Monthly breakdown
    final monthlyTotals = <String, double>{};
    for (final expense in expenses) {
      final key = DateFormat('MMM').format(expense.date);
      monthlyTotals[key] = (monthlyTotals[key] ?? 0) + expense.amount;
    }
    
    // Find highest amount for scaling
    final maxAmount = monthlyTotals.values.fold(0.0, (max, value) => value > max ? value : max);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly trend chart
          Text(
            'Monthly Trend',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyTotals.entries.map((entry) {
                final height = maxAmount > 0 ? (entry.value / maxAmount) * 150 : 0.0;
                
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '\$${entry.value.toStringAsFixed(0)}',
                        style: context.textStyles.caption.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.key,
                        style: context.textStyles.caption,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Category distribution
          Text(
            'Category Distribution',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildCategoryDistribution(expenses),
          
          const SizedBox(height: 24),
          
          // Recent activity
          Text(
            'Recent Activity',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ...expenses.take(5).map((expense) => _buildRecentActivityItem(expense)),
        ],
      ),
    );
  }
  
  Widget _buildCategoryDistribution(List<ExpenseModel> expenses) {
    final categoryTotals = <String, double>{};
    final totalAmount = expenses.fold(0.0, (sum, e) => sum + e.amount);
    
    for (final expense in expenses) {
      final category = _getCategoryFromExpense(expense);
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
    }
    
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: sortedCategories.map((entry) {
          final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0.0;
          final color = _getCategoryColor(entry.key);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Text(entry.key),
                ),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    textAlign: TextAlign.right,
                    style: context.textStyles.caption,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildRecentActivityItem(ExpenseModel expense) {
    final statusColor = _getStatusColor(expense.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(_getCategoryFromExpense(expense)),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: context.textStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(expense.date),
                  style: context.textStyles.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: context.textStyles.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper methods
  Color _getStatusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return context.colors.success;
      case ExpenseStatus.pending:
        return context.colors.warning;
      case ExpenseStatus.rejected:
        return context.colors.error;
    }
  }
  
  IconData _getStatusIcon(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return Icons.check_circle;
      case ExpenseStatus.pending:
        return Icons.pending;
      case ExpenseStatus.rejected:
        return Icons.cancel;
    }
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'accommodation':
        return Icons.hotel;
      case 'equipment':
        return Icons.build;
      case 'supplies':
        return Icons.inventory;
      default:
        return Icons.receipt;
    }
  }
  
  Color _getCategoryColor(String category) {
    final colors = [
      context.colors.primary,
      context.colors.secondary,
      context.colors.info,
      context.colors.error,
      context.colors.warning,
      context.colors.info,
    ];
    
    return colors[category.hashCode % colors.length];
  }
  
  double _getCurrentMonthTotal(List<ExpenseModel> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}