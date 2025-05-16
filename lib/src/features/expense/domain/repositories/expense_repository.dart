import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';

abstract class ExpenseRepository implements BaseRepository<ExpenseModel> {
  /// Busca despesas por status
  Future<List<ExpenseModel>> getExpensesByStatus(ExpenseStatus status);
  
  /// Stream de despesas por status
  Stream<List<ExpenseModel>> watchExpensesByStatus(ExpenseStatus status);
  
  /// Busca despesas por usuário
  Future<List<ExpenseModel>> getExpensesByUser(String userId);
  
  /// Stream de despesas por usuário
  Stream<List<ExpenseModel>> watchExpensesByUser(String userId);
  
  /// Busca despesas por cartão
  Future<List<ExpenseModel>> getExpensesByCard(String cardId);
  
  /// Atualiza o status de uma despesa
  Future<void> updateExpenseStatus(String id, ExpenseStatus status, {String? reviewerNote});
}