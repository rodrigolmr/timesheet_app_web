import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/data/repositories/firestore_expense_repository.dart';
import 'package:timesheet_app_web/src/features/expense/domain/repositories/expense_repository.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';

part 'expense_providers.g.dart';

/// Provider que fornece o repositório de despesas
@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return FirestoreExpenseRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todas as despesas
@riverpod
Future<List<ExpenseModel>> expenses(ExpensesRef ref) {
  return ref.watch(expenseRepositoryProvider).getAll();
}

/// Provider para observar todas as despesas em tempo real
@riverpod
Stream<List<ExpenseModel>> expensesStream(ExpensesStreamRef ref) {
  return ref.watch(expenseRepositoryProvider).watchAll();
}

/// Provider para obter uma despesa específica por ID
@riverpod
Future<ExpenseModel?> expense(ExpenseRef ref, String id) {
  return ref.watch(expenseRepositoryProvider).getById(id);
}

/// Provider para observar uma despesa específica em tempo real
@riverpod
Stream<ExpenseModel?> expenseStream(ExpenseStreamRef ref, String id) {
  return ref.watch(expenseRepositoryProvider).watchById(id);
}

/// Provider para observar uma despesa específica em tempo real (alternativo para telas)
@riverpod
Stream<ExpenseModel?> expenseByIdStream(ExpenseByIdStreamRef ref, String id) {
  return ref.watch(expenseRepositoryProvider).watchById(id);
}

/// Provider para obter despesas por status
@riverpod
Future<List<ExpenseModel>> expensesByStatus(ExpensesByStatusRef ref, ExpenseStatus status) {
  return ref.watch(expenseRepositoryProvider).getExpensesByStatus(status);
}

/// Provider para observar despesas por status em tempo real
@riverpod
Stream<List<ExpenseModel>> expensesByStatusStream(ExpensesByStatusStreamRef ref, ExpenseStatus status) {
  return ref.watch(expenseRepositoryProvider).watchExpensesByStatus(status);
}

/// Provider para obter despesas pendentes
@riverpod
Future<List<ExpenseModel>> pendingExpenses(PendingExpensesRef ref) {
  return ref.watch(expenseRepositoryProvider).getExpensesByStatus(ExpenseStatus.pending);
}

/// Provider para observar despesas pendentes em tempo real
@riverpod
Stream<List<ExpenseModel>> pendingExpensesStream(PendingExpensesStreamRef ref) {
  return ref.watch(expenseRepositoryProvider).watchExpensesByStatus(ExpenseStatus.pending);
}

/// Provider para obter despesas por usuário
@riverpod
Future<List<ExpenseModel>> expensesByUser(ExpensesByUserRef ref, String userId) {
  return ref.watch(expenseRepositoryProvider).getExpensesByUser(userId);
}

/// Provider para observar despesas por usuário em tempo real
@riverpod
Stream<List<ExpenseModel>> expensesByUserStream(ExpensesByUserStreamRef ref, String userId) {
  return ref.watch(expenseRepositoryProvider).watchExpensesByUser(userId);
}

/// Provider para obter despesas por cartão
@riverpod
Future<List<ExpenseModel>> expensesByCard(ExpensesByCardRef ref, String cardId) {
  return ref.watch(expenseRepositoryProvider).getExpensesByCard(cardId);
}

/// Provider para gerenciar o estado de uma despesa
@riverpod
class ExpenseState extends _$ExpenseState {
  @override
  FutureOr<ExpenseModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(expenseProvider(id).future);
  }

  /// Atualiza o status de uma despesa
  Future<void> updateStatus(ExpenseStatus status, {String? reviewerNote}) async {
    if (state.value == null) return;
    
    state = const AsyncLoading();
    try {
      await ref.read(expenseRepositoryProvider).updateExpenseStatus(
        state.value!.id,
        status,
        reviewerNote: reviewerNote,
      );
      
      final updatedExpense = state.value!.copyWith(
        status: status,
        reviewerNote: reviewerNote ?? state.value!.reviewerNote,
        reviewedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      state = AsyncData(updatedExpense);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Aprova uma despesa
  Future<void> approve({String? reviewerNote}) async {
    await updateStatus(ExpenseStatus.approved, reviewerNote: reviewerNote);
  }

  /// Rejeita uma despesa
  Future<void> reject({String? reviewerNote}) async {
    await updateStatus(ExpenseStatus.rejected, reviewerNote: reviewerNote);
  }

  /// Atualiza uma despesa
  Future<void> updateExpense(ExpenseModel expense) async {
    state = const AsyncLoading();
    try {
      await ref.read(expenseRepositoryProvider).update(
        expense.id,
        expense,
      );
      state = AsyncData(expense);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Cria uma nova despesa
  Future<String> create(ExpenseModel expense) async {
    try {
      return await ref.read(expenseRepositoryProvider).create(expense);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui uma despesa
  Future<void> delete(String id) async {
    try {
      await ref.read(expenseRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}