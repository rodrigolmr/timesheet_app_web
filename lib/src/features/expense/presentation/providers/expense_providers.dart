import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/data/repositories/firestore_expense_repository.dart';
import 'package:timesheet_app_web/src/features/expense/domain/repositories/expense_repository.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

part 'expense_providers.g.dart';

/// Estado para gerenciar seleção múltipla de expenses
class ExpenseSelectionState {
  const ExpenseSelectionState({
    this.isSelectionMode = false,
    this.selectedIds = const <String>{},
  });

  final bool isSelectionMode;
  final Set<String> selectedIds;

  ExpenseSelectionState copyWith({
    bool? isSelectionMode,
    Set<String>? selectedIds,
  }) {
    return ExpenseSelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  bool get hasSelection => selectedIds.isNotEmpty;
  int get selectionCount => selectedIds.length;
  
  bool isSelected(String id) => selectedIds.contains(id);
}

/// Provider notifier para gerenciar seleção múltipla
@riverpod
class ExpenseSelection extends _$ExpenseSelection {
  @override
  ExpenseSelectionState build() {
    return const ExpenseSelectionState();
  }

  /// Entra no modo de seleção
  void enterSelectionMode() {
    state = state.copyWith(
      isSelectionMode: true,
      selectedIds: <String>{},
    );
  }

  /// Sai do modo de seleção
  void exitSelectionMode() {
    state = const ExpenseSelectionState();
  }

  /// Seleciona ou deseleciona um expense
  void toggleSelection(String id) {
    if (!state.isSelectionMode) return;
    
    final newSelectedIds = Set<String>.from(state.selectedIds);
    if (newSelectedIds.contains(id)) {
      newSelectedIds.remove(id);
    } else {
      newSelectedIds.add(id);
    }
    
    state = state.copyWith(selectedIds: newSelectedIds);
  }

  /// Seleciona todos os expenses visíveis
  void selectAll(List<String> allExpenseIds) {
    if (!state.isSelectionMode) return;
    
    state = state.copyWith(
      selectedIds: Set<String>.from(allExpenseIds),
    );
  }

  /// Deseleciona todos
  void selectNone() {
    if (!state.isSelectionMode) return;
    
    state = state.copyWith(selectedIds: <String>{});
  }

  /// Remove expenses selecionados do estado após exclusão
  void removeDeletedExpenses(Set<String> deletedIds) {
    final newSelectedIds = Set<String>.from(state.selectedIds);
    newSelectedIds.removeAll(deletedIds);
    
    state = state.copyWith(
      selectedIds: newSelectedIds,
      // Sai do modo seleção se não há mais nada selecionado
      isSelectionMode: newSelectedIds.isNotEmpty || state.isSelectionMode,
    );
  }
}

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

/// Provider para observar despesas filtradas por permissão do usuário
@Riverpod(keepAlive: true)
Stream<List<ExpenseModel>> filteredExpensesStream(FilteredExpensesStreamRef ref) async* {
  try {
    final userProfile = await ref.watch(currentUserProfileProvider.future);
    
    if (userProfile == null) {
      yield [];
      return;
    }
    
    final role = UserRole.fromString(userProfile.role);
    
    // Admin e Manager veem todas as despesas
    if (role == UserRole.admin || role == UserRole.manager) {
      yield* ref.watch(expensesStreamProvider.stream);
    } else {
      // User vê apenas suas próprias despesas
      // Precisa verificar tanto pelo ID do usuário quanto pelo authUid
      yield* ref.watch(expensesStreamProvider.stream).map((expenses) {
        return expenses.where((expense) => 
          expense.userId == userProfile.id || 
          expense.userId == userProfile.authUid
        ).toList();
      });
    }
  } catch (e) {
    // Em caso de erro, retorna lista vazia
    yield [];
  }
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

/// Provider para obter a lista de criadores das despesas com nomes
@Riverpod(keepAlive: true)
Future<List<({String id, String name})>> expenseCreators(ExpenseCreatorsRef ref) async {
  try {
    // Busca apenas as despesas filtradas por permissão
    final expenses = await ref.watch(filteredExpensesStreamProvider.future);
    
    // Extraímos os IDs únicos dos criadores
    final creatorIds = expenses.map((expense) => expense.userId).toSet().toList();
    
    // Lista para armazenar criadores com nomes
    final List<({String id, String name})> creatorsWithNames = [];
    
    // Buscar todos os usuários uma vez só
    final allUsers = await ref.read(usersProvider.future);
    final usersMap = { for (var user in allUsers) user.id: user };
    
    // Para cada ID, buscar informações do usuário
    for (final creatorId in creatorIds) {
      // Busca por ID ou authUid
      var user = usersMap[creatorId];
      if (user == null) {
        // Tenta buscar por authUid
        try {
          user = allUsers.firstWhere((u) => u.authUid == creatorId);
        } catch (e) {
          user = null;
        }
      }
                   
      if (user != null) {
        final name = '${user.firstName} ${user.lastName}'.trim();
        creatorsWithNames.add((id: creatorId, name: name));
      } else {
        creatorsWithNames.add((id: creatorId, name: 'Unknown User'));
      }
    }
    
    return creatorsWithNames..sort((a, b) => a.name.compareTo(b.name));
  } catch (e) {
    // Em caso de erro, retorna lista vazia
    return [];
  }
}