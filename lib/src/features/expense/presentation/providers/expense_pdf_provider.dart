import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/expense/domain/services/expense_pdf_service.dart';
import 'package:timesheet_app_web/src/features/expense/data/services/expense_pdf_service_impl.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';

part 'expense_pdf_provider.g.dart';

@riverpod
ExpensePdfService expensePdfService(ExpensePdfServiceRef ref) {
  return ExpensePdfServiceImpl();
}

@riverpod
Future<Uint8List> expenseBulkPdfGenerator(
  ExpenseBulkPdfGeneratorRef ref,
  List<String> expenseIds,
) async {
  final pdfService = ref.watch(expensePdfServiceProvider);
  
  // Load all selected expenses
  final expenses = <ExpenseModel>[];
  for (final id in expenseIds) {
    try {
      final expense = await ref.read(expenseProvider(id).future);
      if (expense != null) {
        expenses.add(expense);
      }
    } catch (e) {
      // Skip expenses that can't be loaded
      print('Error loading expense $id: $e');
    }
  }

  if (expenses.isEmpty) {
    throw Exception('No valid expenses found');
  }

  // Sort expenses by date
  expenses.sort((a, b) => a.date.compareTo(b.date));

  // Load company cards
  final cards = <String, CompanyCardModel>{};
  final uniqueCardIds = expenses.map((e) => e.cardId).toSet();
  
  for (final cardId in uniqueCardIds) {
    try {
      final card = await ref.read(companyCardProvider(cardId).future);
      if (card != null) {
        cards[cardId] = card;
      }
    } catch (e) {
      print('Error loading card $cardId: $e');
    }
  }

  // Generate PDF
  return await pdfService.generateBulkPdf(
    expenses: expenses,
    cards: cards,
  );
}