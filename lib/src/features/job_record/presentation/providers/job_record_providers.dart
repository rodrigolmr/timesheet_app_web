import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/core/utils/week_utils.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/repositories/firestore_job_record_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/repositories/job_record_repository.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';

part 'job_record_providers.g.dart';

/// Estado para gerenciar seleção múltipla de job records
class JobRecordSelectionState {
  const JobRecordSelectionState({
    this.isSelectionMode = false,
    this.selectedIds = const <String>{},
  });

  final bool isSelectionMode;
  final Set<String> selectedIds;

  JobRecordSelectionState copyWith({
    bool? isSelectionMode,
    Set<String>? selectedIds,
  }) {
    return JobRecordSelectionState(
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
class JobRecordSelection extends _$JobRecordSelection {
  @override
  JobRecordSelectionState build() {
    return const JobRecordSelectionState();
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
    state = const JobRecordSelectionState();
  }

  /// Seleciona ou deseleciona um registro
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

  /// Seleciona todos os registros visíveis
  void selectAll(List<String> allRecordIds) {
    if (!state.isSelectionMode) return;
    
    state = state.copyWith(
      selectedIds: Set<String>.from(allRecordIds),
    );
  }

  /// Deseleciona todos
  void selectNone() {
    if (!state.isSelectionMode) return;
    
    state = state.copyWith(selectedIds: <String>{});
  }

  /// Remove registros selecionados do estado após exclusão
  void removeDeletedRecords(Set<String> deletedIds) {
    final newSelectedIds = Set<String>.from(state.selectedIds);
    newSelectedIds.removeAll(deletedIds);
    
    state = state.copyWith(
      selectedIds: newSelectedIds,
      // Sai do modo seleção se não há mais nada selecionado
      isSelectionMode: newSelectedIds.isNotEmpty || state.isSelectionMode,
    );
  }
}

/// Provider que fornece o repositório de registros de trabalho
@riverpod
JobRecordRepository jobRecordRepository(JobRecordRepositoryRef ref) {
  return FirestoreJobRecordRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os registros
@riverpod
Future<List<JobRecordModel>> jobRecords(JobRecordsRef ref) {
  return ref.watch(jobRecordRepositoryProvider).getAll();
}

/// Provider para obter um registro específico por ID
@riverpod
Future<JobRecordModel?> jobRecordById(JobRecordByIdRef ref, String id) {
  return ref.watch(jobRecordRepositoryProvider).getById(id);
}

/// Provider para observar todos os registros em tempo real com cache
@Riverpod(keepAlive: true)
Stream<List<JobRecordModel>> jobRecordsStream(JobRecordsStreamRef ref) {
  return ref.watch(jobRecordRepositoryProvider).watchAll();
}

/// Provider para observar registros filtrados por permissão do usuário
@Riverpod(keepAlive: true)
Stream<List<JobRecordModel>> filteredJobRecordsStream(FilteredJobRecordsStreamRef ref) async* {
  try {
    final userProfile = await ref.watch(currentUserProfileProvider.future);
    
    if (userProfile == null) {
      yield [];
      return;
    }
    
    final role = UserRole.fromString(userProfile.role);
    
    // Admin e Manager veem todos os registros
    if (role == UserRole.admin || role == UserRole.manager) {
      yield* ref.watch(jobRecordsStreamProvider.stream);
    } else {
      // User vê apenas seus próprios registros
      // Precisa verificar tanto pelo ID do usuário quanto pelo authUid
      yield* ref.watch(jobRecordsStreamProvider.stream).map((records) {
        return records.where((record) => 
          record.userId == userProfile.id || 
          record.userId == userProfile.authUid
        ).toList();
      });
    }
  } catch (e) {
    // Em caso de erro, retorna lista vazia
    yield [];
  }
}

/// Provider para observar registros filtrados por intervalo de data
@riverpod
Stream<List<JobRecordModel>> jobRecordsDateRangeStream(
  JobRecordsDateRangeStreamRef ref, 
  {DateTime? startDate, DateTime? endDate}
) {
  // Observa o provider de todos os registros e aplica filtro
  return ref.watch(jobRecordsStreamProvider.stream).map((records) {
    // Se ambas as datas estão nulas, retornamos todos os registros
    if (startDate == null && endDate == null) {
      return records;
    }
    
    // Aplica o filtro nos registros
    return records.where((record) {
      // Se startDate está definido e o registro é anterior, excluir
      if (startDate != null && record.date.isBefore(startDate)) {
        return false;
      }
      
      // Se endDate está definido, incluir até o final do dia
      if (endDate != null) {
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        if (record.date.isAfter(endOfDay)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  });
}

/// Provider unificado para aplicar todos os filtros
@riverpod
Stream<List<JobRecordModel>> jobRecordsSearchStream(
  JobRecordsSearchStreamRef ref,
  {required String searchQuery, DateTime? startDate, DateTime? endDate, String? creatorId, JobRecordStatus? status}
) async* {
  // Função para aplicar filtros
  List<JobRecordModel> applyFilters(List<JobRecordModel> allRecords) {
    var result = allRecords;
    
    // Filtro por data
    if (startDate != null || endDate != null) {
      result = result.where((record) {
        if (startDate != null && record.date.isBefore(startDate)) {
          return false;
        }
        if (endDate != null) {
          final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
          if (record.date.isAfter(endOfDay)) {
            return false;
          }
        }
        return true;
      }).toList();
    }
    
    // Filtro por criador
    if (creatorId != null && creatorId.isNotEmpty) {
      result = result.where((record) => record.userId == creatorId).toList();
    }
    
    // Filtro por status
    if (status != null) {
      result = result.where((record) => record.status == status).toList();
    }
    
    // Filtro por texto/busca
    if (searchQuery.trim().isNotEmpty) {
      final searchTerms = searchQuery.toLowerCase().split(' ')
        .where((term) => term.isNotEmpty)
        .toList();
        
      result = result.where((record) {
        // Todos os termos devem estar presentes 
        return searchTerms.every((term) => _recordContainsSearchTerm(record, term));
      }).toList();
    }
    
    return result;
  }

  // Tenta obter dados já carregados primeiro
  try {
    final cachedRecords = ref.read(filteredJobRecordsStreamProvider.future);
    if (cachedRecords is Future<List<JobRecordModel>>) {
      final records = await cachedRecords;
      yield applyFilters(records);
    }
  } catch (e) {
    // Se não há dados em cache, continua para o stream
  }

  // Continua ouvindo o stream para futuras atualizações
  await for (final allRecords in ref.watch(filteredJobRecordsStreamProvider.stream)) {
    yield applyFilters(allRecords);
  }
}

/// Verifica se um registro contém um termo de busca em qualquer um de seus campos
bool _recordContainsSearchTerm(JobRecordModel record, String term) {
  // Convertemos o termo para minúsculas para uma comparação sem distinção de maiúsculas/minúsculas
  final lowercaseTerm = term.toLowerCase();
  
  // Verificamos cada campo do registro
  if (record.jobName.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.territorialManager.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.jobSize.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.material.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.jobDescription.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.foreman.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.vehicle.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.notes.toLowerCase().contains(lowercaseTerm)) return true;
  if (record.userId.toLowerCase().contains(lowercaseTerm)) return true;
  
  // Verificamos também os funcionários
  for (final employee in record.employees) {
    if (employee.employeeName.toLowerCase().contains(lowercaseTerm)) return true;
    // Verificamos outros valores numéricos convertendo para string
    if (employee.hours.toString().contains(lowercaseTerm)) return true;
    if (employee.travelHours.toString().contains(lowercaseTerm)) return true;
    if (employee.startTime.toLowerCase().contains(lowercaseTerm)) return true;
    if (employee.finishTime.toLowerCase().contains(lowercaseTerm)) return true;
  }
  
  // Se não encontramos o termo em nenhum campo, retornamos falso
  return false;
}

/// Provider para obter a lista de criadores dos job records com names
@Riverpod(keepAlive: true)
Future<List<({String id, String name})>> jobRecordCreators(JobRecordCreatorsRef ref) async {
  try {
    // Busca apenas os registros filtrados por permissão
    final records = await ref.watch(filteredJobRecordsStreamProvider.future);
    print('DEBUG: Found ${records.length} job records');
    
    // Extraímos os IDs únicos dos criadores
    final creatorIds = records.map((record) => record.userId).toSet().toList();
    print('DEBUG: Creator IDs from job records: $creatorIds');
    
    // Lista para armazenar criadores com nomes
    final List<({String id, String name})> creatorsWithNames = [];
    
    // Buscar todos os usuários uma vez só
    final allUsers = await ref.read(usersProvider.future);
    print('DEBUG: Found ${allUsers.length} users');
    print('DEBUG: User IDs: ${allUsers.map((u) => u.id).toList()}');
    final usersMap = { for (var user in allUsers) user.id: user };
    
    // Para cada ID, buscar informações do usuário
    for (final creatorId in creatorIds) {
      // Busca por ID ou authUid (igual ao job_record_card.dart)
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
        print('DEBUG: Found user for ID $creatorId: $name');
        creatorsWithNames.add((id: creatorId, name: name));
      } else {
        print('DEBUG: NO USER FOUND for ID: $creatorId');
        creatorsWithNames.add((id: creatorId, name: 'Unknown User'));
      }
    }
    
    print('DEBUG: Final creators list: ${creatorsWithNames.map((c) => '${c.id}: ${c.name}').toList()}');
    return creatorsWithNames..sort((a, b) => a.name.compareTo(b.name));
  } catch (e) {
    print('DEBUG: Error in jobRecordCreators: $e');
    // Em caso de erro, retorna lista vazia
    return [];
  }
}

/// Provider para agrupar registros por semana removido - usando agrupamento direto no widget conforme GUIDE.md

/// Provider para obter um registro específico por ID
@riverpod
Future<JobRecordModel?> jobRecord(JobRecordRef ref, String id) {
  return ref.watch(jobRecordRepositoryProvider).getById(id);
}

/// Provider para observar um registro específico em tempo real
@riverpod
Stream<JobRecordModel?> jobRecordStream(JobRecordStreamRef ref, String id) {
  return ref.watch(jobRecordRepositoryProvider).watchById(id);
}

/// Provider para obter registros por usuário
@riverpod
Future<List<JobRecordModel>> jobRecordsByUser(JobRecordsByUserRef ref, String userId) {
  return ref.watch(jobRecordRepositoryProvider).getRecordsByUser(userId);
}

/// Provider para observar registros por usuário em tempo real
@riverpod
Stream<List<JobRecordModel>> jobRecordsByUserStream(JobRecordsByUserStreamRef ref, String userId) {
  return ref.watch(jobRecordRepositoryProvider).watchRecordsByUser(userId);
}

/// Provider para obter registros por funcionário
@riverpod
Future<List<JobRecordModel>> jobRecordsByEmployee(JobRecordsByEmployeeRef ref, String employeeId) {
  return ref.watch(jobRecordRepositoryProvider).getRecordsByEmployee(employeeId);
}

/// Provider para observar registros por funcionário em tempo real
@riverpod
Stream<List<JobRecordModel>> jobRecordsByEmployeeStream(JobRecordsByEmployeeStreamRef ref, String employeeId) {
  return ref.watch(jobRecordRepositoryProvider).watchRecordsByEmployee(employeeId);
}

/// Provider para gerenciar o estado de um registro
@riverpod
class JobRecordState extends _$JobRecordState {
  @override
  FutureOr<JobRecordModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(jobRecordProvider(id).future);
  }

  /// Atualiza um registro
  Future<JobRecordModel?> updateRecord(JobRecordModel record) async {
    state = const AsyncLoading();
    try {
      await ref.read(jobRecordRepositoryProvider).update(
        record.id,
        record,
      );
      state = AsyncData(record);
      return record;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return null;
    }
  }

  /// Cria um novo registro
  Future<String> create(JobRecordModel record) async {
    try {
      return await ref.read(jobRecordRepositoryProvider).create(record);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui um registro
  Future<void> delete(String id) async {
    try {
      await ref.read(jobRecordRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}