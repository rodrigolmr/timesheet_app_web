import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/timesheet.dart';
import '../models/user.dart';
import '../providers.dart';
import '../widgets/base_layout.dart';
import '../widgets/app_button.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/loading_button.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/timesheet_row.dart';
import '../widgets/sort_field.dart';
import '../widgets/toast_message.dart';

// Provider para lista de timesheets
final timesheetsProvider = FutureProvider<List<TimesheetModel>>((ref) async {
  // Usar apenas o repositório local para exibir timesheets,
  // evitando que dados excluídos sejam recarregados do Firestore
  final repository = ref.read(timesheetRepositoryProvider);
  return repository.getLocalTimesheets();
});

// Provider para usuário atual
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.read(authServiceProvider);
  final userRepository = ref.read(userRepositoryProvider);
  
  final user = auth.currentUser;
  if (user == null) return null;
  
  return userRepository.getUser(user.uid);
});

// Provider para lista de usuários
final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.read(userRepositoryProvider);
  return repository.getLocalUsers();
});

// Provider para filtros de timesheet
final timesheetFiltersProvider = StateProvider((ref) => TimesheetFilters());

class TimesheetFilters {
  final bool isDescending;
  final DateTimeRange? dateRange;
  final String? creatorId;
  final String searchText; // Campo unificado de busca

  TimesheetFilters({
    this.isDescending = true,
    this.dateRange,
    this.creatorId,
    this.searchText = '',
  });

  TimesheetFilters copyWith({
    bool? isDescending,
    DateTimeRange? dateRange,
    String? creatorId,
    String? searchText,
    bool clearDateRange = false,
    bool clearCreatorId = false,
  }) {
    return TimesheetFilters(
      isDescending: isDescending ?? this.isDescending,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      creatorId: clearCreatorId ? null : (creatorId ?? this.creatorId),
      searchText: searchText ?? this.searchText,
    );
  }
}

class TimesheetListPage extends ConsumerStatefulWidget {
  const TimesheetListPage({super.key});

  @override
  ConsumerState<TimesheetListPage> createState() => _TimesheetListPageState();
}

class _TimesheetListPageState extends ConsumerState<TimesheetListPage> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedDocIds = {};
  bool _showFilters = false;

  // Variáveis para o modo de seleção
  bool _isInSelectionMode = false;
  bool _isDragging = false;

  // Controlador unificado para busca
  final TextEditingController _searchController = TextEditingController();

  // Filtros candidatos (antes de aplicar)
  TimesheetFilters _candidateFilters = TimesheetFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncTimesheets();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncTimesheets() async {
    try {
      // Para evitar ressuscitar dados excluídos, não vamos usar o SyncManager
      // que sobrescreve exclusões locais. Em vez disso, vamos manter os dados locais
      // como fonte da verdade.

      // Recarregar dados locais
      ref.invalidate(timesheetsProvider);

      print('🔄 _syncTimesheets: Usando dados locais como fonte da verdade');

      // Verificar se existem exclusões locais que precisam ser sincronizadas com o Firestore
      final deletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
      if (deletedKeys.isNotEmpty) {
        print('🗑️ Existem ${deletedKeys.length} timesheets excluídos localmente que precisam ser excluídos do Firestore');

        // Usar o FirestoreWriteService para excluir do Firestore
        final firestoreService = ref.read(firestoreWriteServiceProvider);
        for (final id in deletedKeys) {
          try {
            await firestoreService.deleteTimesheet(id);
            print('✅ Timesheet $id excluído com sucesso do Firestore');
          } catch (e) {
            print('⚠️ Erro ao excluir timesheet $id do Firestore: $e');
            // Não relançamos o erro para continuar com os próximos IDs
          }
        }
      }
    } catch (e) {
      // Apenas log do erro, sem mostrar ao usuário
      print('❌ Erro na sincronização manual de timesheets: ${e.toString()}');
    }
  }

  List<TimesheetModel> _applyFilters(List<TimesheetModel> timesheets, TimesheetFilters filters, UserModel? currentUser) {
    // Cópia da lista para não modificar a original
    List<TimesheetModel> result = List.from(timesheets);

    // Filtrar por criador se o usuário não for admin
    if (currentUser != null && currentUser.role.toLowerCase() != 'admin') {
      result = result.where((ts) => ts.userId == currentUser.id).toList();
    }
    // Filtrar por criador específico se selecionado (apenas para admin)
    else if (filters.creatorId != null && filters.creatorId!.isNotEmpty) {
      print('Filtrando pelo criador ID: ${filters.creatorId}');
      result = result.where((ts) => ts.userId == filters.creatorId).toList();
    }

    // Filtrar por intervalo de datas
    if (filters.dateRange != null) {
      final start = filters.dateRange!.start;
      final end = filters.dateRange!.end;
      result = result.where((ts) {
        return ts.date.isAfter(start.subtract(const Duration(days: 1))) &&
            ts.date.isBefore(end.add(const Duration(days: 1)));
      }).toList();
    }

    // Busca unificada em múltiplos campos
    if (filters.searchText.isNotEmpty) {
      // Dividir o texto de busca em palavras individuais e remover espaços vazios
      final searchTerms = filters.searchText.toLowerCase().split(' ')
          .where((term) => term.isNotEmpty).toList();

      if (searchTerms.isNotEmpty) {
        result = result.where((ts) {
          // Criando um texto consolidado de todos os campos pesquisáveis
          final allFields = [
            ts.jobName.toLowerCase(),
            ts.tm.toLowerCase(),
            ts.material.toLowerCase(),
            ts.notes.toLowerCase(),
            ts.foreman.toLowerCase(),
            ts.jobDesc.toLowerCase(),
            ts.jobSize.toLowerCase(),
            ts.vehicle.toLowerCase(),
          ].join(' ');

          // Verificar se TODAS as palavras da busca estão em pelo menos um dos campos
          return searchTerms.every((term) => allFields.contains(term));
        }).toList();
      }
    }

    // Ordenar por data
    result.sort((a, b) {
      if (filters.isDescending) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final timesheetsAsync = ref.watch(timesheetsProvider);
    final usersAsync = ref.watch(usersProvider);
    final filters = ref.watch(timesheetFiltersProvider);
    final responsive = ResponsiveSizing(context);

    return BaseLayout(
      title: "Timesheets",
      child: ResponsiveContainer(
        center: false, // Desativar centralização para manter alinhamento top
        padding: EdgeInsets.symmetric(
          horizontal: responsive.responsiveValue(
            mobile: 8.0,
            tablet: 16.0,
            desktop: 24.0,
          ),
        ),
        // Aplicar espaçamento automático entre elementos
        childSpacing: responsive.responsiveValue(
          mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
          tablet: AppTheme.mediumSpacing, // 20px para tablets
          desktop: AppTheme.largeSpacing, // 24px para desktop
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinhamento principal no topo
          mainAxisSize: MainAxisSize.min, // Minimizar o tamanho vertical
          children: [
            // Sem espaçamento manual - o childSpacing e o padding do BaseLayout cuidarão disso

            // Barra superior com botões
            _buildTopBar(currentUserAsync),

            // Painel de filtros (condicional)
            if (_showFilters)
              _buildFilterPanel(currentUserAsync, usersAsync),

            // Barra de ações para modo de seleção
            if (_isInSelectionMode)
              _buildSelectionActionBar(responsive),

            // Lista de timesheets
            Expanded(
              child: Column(
                children: [
                  // Sem SizedBox redundante
                  Expanded(
                    child: _buildTimesheetsList(timesheetsAsync, currentUserAsync, filters),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionActionBar(ResponsiveSizing responsive) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.responsiveValue(
          mobile: 8.0,
          tablet: 16.0,
          desktop: 24.0,
        ),
        vertical: 8.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${_selectedDocIds.length} selected",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),

          // Botão para selecionar todos
          IconButton(
            icon: const Icon(Icons.select_all, color: AppTheme.primaryBlue),
            tooltip: "Select all items",
            onPressed: _selectAllVisible,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0FF),
            ),
          ),

          // Botão para imprimir selecionados
          IconButton(
            icon: const Icon(Icons.print, color: AppTheme.primaryBlue),
            tooltip: "Print selected",
            onPressed: _selectedDocIds.isNotEmpty ? _generatePdf : null,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0FF),
              disabledBackgroundColor: Colors.grey.shade200,
            ),
          ),

          // Botão para deletar selecionados
          IconButton(
            icon: Icon(Icons.delete, color: _selectedDocIds.isNotEmpty ? AppTheme.primaryRed : Colors.grey),
            tooltip: "Delete selected",
            onPressed: _selectedDocIds.isNotEmpty
                ? () => _showDeleteMultipleConfirmation(context)
                : null,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0FF),
              disabledBackgroundColor: Colors.grey.shade200,
            ),
          ),

          // Botão para cancelar seleção
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.primaryBlue),
            tooltip: "Cancel selection",
            onPressed: _exitSelectionMode,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AsyncValue<UserModel?> currentUserAsync) {
    final responsive = ResponsiveSizing(context);

    // Exibir informações de debug sobre o usuário
    currentUserAsync.whenData((user) {
      print("User role: ${user?.role}");
      if (user?.role?.toLowerCase() != 'admin') {
        print("User is not admin. User: ${user?.firstName} ${user?.lastName}");
      } else {
        print("User is admin: ${user?.firstName} ${user?.lastName}");
      }
    });

    // Nova interface com botões na mesma linha
    return ResponsiveContainer(
      padding: EdgeInsets.zero, // Remover padding que causa duplicação
      child: Column(
        children: [
          // Linha principal com botões
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Grupo de botões à esquerda (NEW + PDF)
              currentUserAsync.when(
                data: (user) {
                  // Verifica se é admin (case insensitive)
                  final isAdmin = user?.role?.toLowerCase() == 'admin';
                  
                  return Row(
                    children: [
                      // Botão NEW sempre visível
                      AppButton(
                        config: ButtonType.newButton.config,
                        onPressed: () => context.pushNamed(AppRoutes.timesheetNewName),
                      ),
                      
                      // Botão PDF - apenas para admin
                      if (isAdmin) ...[
                        const SizedBox(width: 10),
                        AppButton(
                          config: ButtonType.pdfButton.config,
                          onPressed: _selectedDocIds.isEmpty
                              ? () {
                                  ToastMessage.showWarning(
                                    context,
                                    "No timesheet selected.",
                                  );
                                }
                              : _generatePdf,
                        ),
                      ],
                    ],
                  );
                },
                loading: () => AppButton(
                  config: ButtonType.newButton.config,
                  onPressed: () => context.pushNamed(AppRoutes.timesheetNewName),
                ),
                error: (_, __) => AppButton(
                  config: ButtonType.newButton.config,
                  onPressed: () => context.pushNamed(AppRoutes.timesheetNewName),
                ),
              ),
              
              // Grupo de botões à direita (sort + selection)
              currentUserAsync.when(
                data: (user) {
                  // Verifica se é admin (case insensitive)
                  final isAdmin = user?.role?.toLowerCase() == 'admin';
                  
                  return Row(
                    children: [
                      // Botão de filtro/ordenação - disponível para todos
                      AppButton(
                        config: ButtonType.sortButton.config,
                        onPressed: () {
                          // Inicializar filtros candidatos
                          _candidateFilters = ref.read(timesheetFiltersProvider);
                          // Definir valor no controlador de busca
                          _searchController.text = _candidateFilters.searchText;
                          // Mostrar painel de filtros
                          setState(() {
                            _showFilters = true;
                          });
                        },
                      ),
                      
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          
          // Removido contador de selecionados que aparecia abaixo do botão de sort
        ],
      ),
    );
  }

  Widget _buildFilterPanel(AsyncValue<UserModel?> currentUserAsync, AsyncValue<List<UserModel>> usersAsync) {
    print("Building filter panel. _showFilters = $_showFilters");
    // Lista de usuários para o dropdown
    List<String> creatorOptions = ['Creator'];  // Valor padrão
    String selectedCreator = 'Creator';

    if (_candidateFilters.creatorId != null) {
      // Tentar encontrar o nome do usuário selecionado
      usersAsync.whenData((users) {
        final user = users.firstWhere(
          (u) => u.id == _candidateFilters.creatorId,
          orElse: () => UserModel(
            userId: '',
            email: '',
            firstName: 'Unknown',
            lastName: 'User',
            role: 'user',
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        selectedCreator = '${user.firstName} ${user.lastName}';
      });
    }

    // Montar lista de opções de criadores
    creatorOptions = usersAsync.when(
      data: (users) {
        final options = ['Creator']; // Valor padrão no topo
        for (var user in users) {
          options.add('${user.firstName} ${user.lastName}');
        }
        return options;
      },
      loading: () => ['Creator'],
      error: (_, __) => ['Creator'],
    );

    // Inicializar o controlador de busca com o valor atual
    if (_searchController.text.isEmpty && _candidateFilters.searchText.isNotEmpty) {
      _searchController.text = _candidateFilters.searchText;
    }

    return SortField(
      // Configurações de data e ordem
      selectedRange: _candidateFilters.dateRange,
      isDescending: _candidateFilters.isDescending,

      // Configurações de criador
      selectedCreator: selectedCreator,
      creatorOptions: creatorOptions,

      // Controlador unificado de busca
      searchController: _searchController,

      // Callbacks
      onPickRange: () => _pickDateRange(context),
      onSortOrderChanged: (isDescending) {
        setState(() {
          _candidateFilters = _candidateFilters.copyWith(isDescending: isDescending);
          // Aplicar filtros imediatamente
          ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters;
          // Recarregar os timesheets filtrados
          ref.invalidate(timesheetsProvider);
        });
      },
      onCreatorChanged: (creator) {
        if (creator == null || creator == 'Creator') {
          setState(() {
            _candidateFilters = _candidateFilters.copyWith(clearCreatorId: true);

            // Aplicar filtros imediatamente
            ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters;
            // Recarregar os timesheets filtrados
            ref.invalidate(timesheetsProvider);
          });
        } else {
          // Encontrar o ID do usuário pelo nome
          final usersList = ref.read(usersProvider).value ?? [];

          // Encontrar usuário pelo nome completo
          final fullName = creator;
          final user = usersList.firstWhere(
            (u) => '${u.firstName} ${u.lastName}' == fullName,
            orElse: () => UserModel(
              userId: '',
              email: '',
              firstName: '',
              lastName: '',
              role: 'user',
              status: 'active',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          if (user.id.isNotEmpty) {
            print('Selecionado usuário: ${user.firstName} ${user.lastName}, ID: ${user.id}');
            setState(() {
              _candidateFilters = _candidateFilters.copyWith(creatorId: user.id);

              // Aplicar filtros imediatamente
              ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters;
              // Recarregar os timesheets filtrados
              ref.invalidate(timesheetsProvider);
            });
          }
        }
      },
      onSearchChanged: (text) {
        // Atualizar o texto de busca candidato e aplicar imediatamente
        setState(() {
          _candidateFilters = _candidateFilters.copyWith(searchText: text);
          // Aplicar filtros imediatamente
          ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters;
          // Recarregar os timesheets filtrados
          ref.invalidate(timesheetsProvider);
        });
      },
      onClearAll: () {
        setState(() {
          _candidateFilters = TimesheetFilters();
          _searchController.clear();
        });
        // Também limpar os filtros aplicados
        ref.read(timesheetFiltersProvider.notifier).state = TimesheetFilters();
      },
      onClose: () {
        setState(() {
          _showFilters = false;
        });
      },
    );
  }

  Widget _buildTimesheetsList(
    AsyncValue<List<TimesheetModel>> timesheetsAsync,
    AsyncValue<UserModel?> currentUserAsync,
    TimesheetFilters filters,
  ) {
    final responsive = ResponsiveSizing(context);
    return timesheetsAsync.when(
      data: (timesheets) {
        return currentUserAsync.when(
          data: (currentUser) {
            // Aplicar filtros à lista de timesheets
            final filteredTimesheets = _applyFilters(timesheets, filters, currentUser);
            
            if (filteredTimesheets.isEmpty) {
              return const Center(child: Text("No timesheets found."));
            }
            
            // Obter mapa de usuários para mostrar nomes
            final usersAsync = ref.watch(usersProvider);
            final usersMap = usersAsync.when(
              data: (users) {
                return {for (var user in users) user.id: '${user.firstName} ${user.lastName}'};
              },
              loading: () => <String, String>{},
              error: (_, __) => <String, String>{},
            );
            
            return ResponsiveContainer(
              mobileMaxWidth: double.infinity,
              tabletMaxWidth: responsive.responsiveValue(
                mobile: 500.0,
                tablet: 700.0,
                desktop: 900.0,
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredTimesheets.length,
                itemBuilder: (context, index) {
                  final item = filteredTimesheets[index];
                  final docId = item.documentId;

                  final userName = usersMap[item.userId] ?? "User";
                  final jobName = item.jobName;
                  final date = item.date;
                  final bool isChecked = _selectedDocIds.contains(docId);

                  String day = DateFormat('d').format(date);
                  String month = DateFormat('MMM').format(date);

                  return Padding(
                    key: ValueKey(docId),
                    padding: EdgeInsets.only(
                      bottom: responsive.responsiveValue(
                        mobile: 4.0,
                        tablet: 5.0,
                        desktop: 6.0,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Se estiver em modo de seleção, selecionar o item
                        if (_isInSelectionMode) {
                          _toggleItemSelection(docId);
                        } else {
                          // Senão, navegar para a visualização
                          context.goNamed(
                            AppRoutes.timesheetViewName,
                            pathParameters: {'id': docId},
                          );
                        }
                      },
                      child: TimesheetRowItem(
                        day: day,
                        month: month,
                        jobName: jobName,
                        userName: userName,
                        isSelected: isChecked,
                        onSelectionChanged: (_) {
                          if (_isInSelectionMode) {
                            _toggleItemSelection(docId);
                          } else {
                            // Se não estiver em modo de seleção, ativar e selecionar o item
                            _enterSelectionMode(docId);
                          }
                        },
                        onLongPress: () {
                          // Iniciar modo de seleção com toque longo
                          if (!_isInSelectionMode) {
                            _enterSelectionMode(docId);
                          } else {
                            _toggleItemSelection(docId);
                          }

                          // Mostrar feedback ao usuário
                          HapticFeedback.mediumImpact();
                        },
                        onSelectAll: _selectAllVisible,
                        onEdit: () {
                          context.goNamed(
                            AppRoutes.timesheetEditName,
                            pathParameters: {'id': docId},
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmation(context, item);
                        },
                        onDuplicate: () {
                          _duplicateTimesheet(item);
                        },
                        onPrint: () {
                          _printTimesheet(item);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text("Error loading user data")),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading timesheets")),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: _candidateFilters.dateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() {
        _candidateFilters = _candidateFilters.copyWith(dateRange: selected);
        // Aplicar filtros imediatamente
        ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters;
        // Recarregar os timesheets filtrados
        ref.invalidate(timesheetsProvider);
      });
    }
  }

  // Mostrar diálogo de confirmação de exclusão para um timesheet
  Future<void> _showDeleteConfirmation(BuildContext context, TimesheetModel timesheet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timesheet'),
        content: Text('Are you sure you want to delete the timesheet for "${timesheet.jobName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteTimesheet(timesheet);
    }
  }

  // Mostrar diálogo de confirmação de exclusão para múltiplos timesheets
  Future<void> _showDeleteMultipleConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timesheets'),
        content: Text('Are you sure you want to delete ${_selectedDocIds.length} selected timesheets?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteMultipleTimesheets();
    }
  }

  // Excluir múltiplos timesheets
  Future<void> _deleteMultipleTimesheets() async {
    try {
      final firestoreService = ref.read(firestoreWriteServiceProvider);
      int successCount = 0;
      final repo = ref.read(timesheetRepositoryProvider);

      print('🔄 _deleteMultipleTimesheets: Iniciando exclusão de ${_selectedDocIds.length} timesheets');

      for (String docId in _selectedDocIds) {
        try {
          print('🔄 _deleteMultipleTimesheets: Excluindo timesheet $docId');

          // Usar FirestoreWriteService para excluir tanto no Firestore quanto no repositório local
          await firestoreService.deleteTimesheet(docId);

          // Verificar se o documento foi realmente removido
          final stillExists = repo.getTimesheet(docId) != null;
          if (stillExists) {
            print('⚠️ _deleteMultipleTimesheets: Timesheet $docId ainda existe! Tentando novamente...');
            await repo.deleteTimesheet(docId);
          }

          // Verificar lista de exclusões
          final deletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
          if (!deletedKeys.contains(docId)) {
            print('⚠️ _deleteMultipleTimesheets: $docId não está na lista de exclusões! Adicionando...');
            deletedKeys.add(docId);
            await SyncMetadata.setDeletedKeys('timesheets', deletedKeys);
          }

          successCount++;
          print('✅ _deleteMultipleTimesheets: Timesheet $docId excluído com sucesso');
        } catch (e) {
          print('❌ _deleteMultipleTimesheets: Erro ao excluir timesheet $docId: $e');
        }
      }

      // Recarregar a lista de timesheets
      ref.invalidate(timesheetsProvider);

      // Sair do modo de seleção
      _exitSelectionMode();

      if (mounted) {
        ToastMessage.showSuccess(
          context,
          'Deleted $successCount of ${_selectedDocIds.length} timesheets from local and cloud storage',
        );
      }
    } catch (e) {
      print('❌ _deleteMultipleTimesheets: Erro geral ao excluir timesheets: $e');
      if (mounted) {
        ToastMessage.showError(
          context,
          'Error deleting timesheets: ${e.toString()}',
        );
      }
    }
  }

  // Excluir timesheet
  Future<void> _deleteTimesheet(TimesheetModel timesheet) async {
    try {
      final docId = timesheet.documentId;
      print('🔄 _deleteTimesheet: Iniciando exclusão de timesheet: ${timesheet.jobName} (ID: $docId)');

      // Usar FirestoreWriteService para excluir tanto no Firestore quanto no repositório local
      final firestoreService = ref.read(firestoreWriteServiceProvider);
      await firestoreService.deleteTimesheet(docId);

      // Verificar metadados após a exclusão
      final deletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
      final isInDeletedList = deletedKeys.contains(docId);
      print('🔄 _deleteTimesheet: Verificando se o ID $docId está na lista de exclusões: $isInDeletedList');

      // Verificar se o documento foi realmente removido do Hive
      final repo = ref.read(timesheetRepositoryProvider);
      final stillExists = repo.getTimesheet(docId) != null;
      print('🔄 _deleteTimesheet: Timesheet ainda existe no repositório local? $stillExists');

      // Garantir que o documento seja removido
      if (stillExists) {
        print('⚠️ _deleteTimesheet: Timesheet ainda existe após exclusão! Tentando novamente...');
        await repo.deleteTimesheet(docId);
      }

      // Certifique-se de que está na lista de exclusões
      if (!isInDeletedList) {
        print('⚠️ _deleteTimesheet: ID não foi adicionado à lista de exclusões! Adicionando manualmente...');
        deletedKeys.add(docId);
        await SyncMetadata.setDeletedKeys('timesheets', deletedKeys);
      }

      // Recarregar a lista de timesheets
      ref.invalidate(timesheetsProvider);

      if (mounted) {
        ToastMessage.showSuccess(
          context,
          'Timesheet deleted successfully from local and cloud storage',
        );
      }
    } catch (e) {
      print('❌ _deleteTimesheet: Erro ao excluir timesheet: $e');
      if (mounted) {
        ToastMessage.showError(
          context,
          'Error deleting timesheet: ${e.toString()}',
        );
      }
    }
  }

  // Duplicar timesheet
  Future<void> _duplicateTimesheet(TimesheetModel timesheet) async {
    try {
      final repository = ref.read(timesheetRepositoryProvider);

      // Criar uma cópia do timesheet com um novo ID e data de criação
      final newTimesheet = TimesheetModel(
        userId: timesheet.userId,
        jobName: "${timesheet.jobName} (copy)",
        date: DateTime.now(),
        tm: timesheet.tm,
        foreman: timesheet.foreman,
        jobDesc: timesheet.jobDesc,
        jobSize: timesheet.jobSize,
        material: timesheet.material,
        notes: timesheet.notes,
        vehicle: timesheet.vehicle,
        workers: List.from(timesheet.workers),
        timestamp: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addTimesheet(newTimesheet);

      ref.invalidate(timesheetsProvider);

      if (mounted) {
        ToastMessage.showSuccess(
          context,
          'Timesheet duplicated successfully',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastMessage.showError(
          context,
          'Error duplicating timesheet: ${e.toString()}',
        );
      }
    }
  }

  // Imprimir timesheet
  Future<void> _printTimesheet(TimesheetModel timesheet) async {
    try {
      // Adicionar à lista de selecionados se não estiver
      if (!_selectedDocIds.contains(timesheet.documentId)) {
        setState(() {
          _selectedDocIds.clear(); // Limpar seleções existentes
          _selectedDocIds.add(timesheet.documentId);
        });
      } else {
        // Se for o único, apenas usar a lista existente
        if (_selectedDocIds.length > 1) {
          setState(() {
            _selectedDocIds.clear();
            _selectedDocIds.add(timesheet.documentId);
          });
        }
      }

      // Gerar PDF usando a função existente
      await _generatePdf();
    } catch (e) {
      if (mounted) {
        ToastMessage.showError(
          context,
          'Error printing timesheet: ${e.toString()}',
        );
      }
    }
  }

  // Inicia o modo de seleção a partir de um item
  void _enterSelectionMode(String docId) {
    setState(() {
      _isInSelectionMode = true;
      _selectedDocIds.clear();
      _selectedDocIds.add(docId);
    });
  }

  // Sai do modo de seleção
  void _exitSelectionMode() {
    setState(() {
      _isInSelectionMode = false;
      _selectedDocIds.clear();
    });
  }

  // Alterna a seleção de um item
  void _toggleItemSelection(String docId) {
    setState(() {
      if (_selectedDocIds.contains(docId)) {
        _selectedDocIds.remove(docId);
        // Se não houver mais itens selecionados, sai do modo de seleção
        if (_selectedDocIds.isEmpty) {
          _isInSelectionMode = false;
        }
      } else {
        _selectedDocIds.add(docId);
      }
    });
  }

  // Seleciona todos os timesheets visíveis
  void _selectAllVisible() {
    final timesheetsAsync = ref.read(timesheetsProvider);
    final currentUserAsync = ref.read(currentUserProvider);
    final filters = ref.read(timesheetFiltersProvider);

    // Entrar no modo de seleção se ainda não estiver
    if (!_isInSelectionMode) {
      setState(() {
        _isInSelectionMode = true;
      });
    }

    timesheetsAsync.whenData((timesheets) {
      currentUserAsync.whenData((currentUser) {
        final filteredTimesheets = _applyFilters(timesheets, filters, currentUser);

        setState(() {
          _selectedDocIds.clear();
          for (var ts in filteredTimesheets) {
            _selectedDocIds.add(ts.documentId);
          }
        });
      });
    });
  }

  Future<void> _generatePdf() async {
    if (_selectedDocIds.isEmpty) {
      ToastMessage.showWarning(
        context,
        'No timesheets selected.',
      );
      return;
    }

    try {
      // Mostrar indicador de progresso para geração de PDF
      // Este feedback específico é mantido porque está relacionado à ação explícita do usuário
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FeedbackController.showLoading(
            context,
            message: 'Generating PDF...',
          );
        }
      });

      // Simular um processo de geração de PDF
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar geração de PDF após termos o serviço disponível

      // Esconder o overlay de carregamento usando WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Esconder o overlay de carregamento
          FeedbackController.hide();

          // Mostrar feedback de informação
          ToastMessage.showInfo(
            context,
            'PDF generation not implemented yet',
          );
        }
      });
    } catch (e) {
      // Esconder o overlay de carregamento usando WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Esconder o overlay de carregamento
          FeedbackController.hide();

          // Mostrar feedback de erro
          ToastMessage.showError(
            context,
            'Error generating PDF: ${e.toString()}',
          );
        }
      });
    }
  }
}