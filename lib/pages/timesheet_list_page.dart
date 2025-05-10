import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
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
      // Usar o SyncManager para sincronização silenciosa em segundo plano
      final syncManager = ref.read(syncManagerProvider);
      await syncManager.performInitialSync();

      // Recarregar dados após sincronização
      ref.invalidate(timesheetsProvider);

      // Não mostrar nenhum feedback visual ao usuário
    } catch (e) {
      // Apenas log do erro, sem mostrar ao usuário
      print('Erro na sincronização silenciosa: ${e.toString()}');
    }
  }

  List<TimesheetModel> _applyFilters(List<TimesheetModel> timesheets, TimesheetFilters filters, UserModel? currentUser) {
    // Cópia da lista para não modificar a original
    List<TimesheetModel> result = List.from(timesheets);

    // Filtrar por criador se o usuário não for admin
    if (currentUser != null && currentUser.role != 'admin') {
      result = result.where((ts) => ts.userId == currentUser.id).toList();
    }
    // Filtrar por criador específico se selecionado (apenas para admin)
    else if (filters.creatorId != null) {
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
      final search = filters.searchText.toLowerCase();
      result = result.where((ts) => 
        ts.jobName.toLowerCase().contains(search) || 
        ts.tm.toLowerCase().contains(search) || 
        ts.material.toLowerCase().contains(search) ||
        ts.notes.toLowerCase().contains(search) ||
        ts.foreman.toLowerCase().contains(search) ||
        ts.jobDesc.toLowerCase().contains(search)
      ).toList();
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
        padding: EdgeInsets.symmetric(
          horizontal: responsive.responsiveValue(
            mobile: 8.0,
            tablet: 16.0,
            desktop: 24.0,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: responsive.responsiveValue(
              mobile: 12.0,
              tablet: 16.0,
              desktop: 20.0,
            )),

            // Barra superior com botões
            _buildTopBar(currentUserAsync),

            // Painel de filtros (condicional)
            if (_showFilters) ...[
              SizedBox(height: responsive.responsiveValue(
                mobile: 12.0,
                tablet: 16.0,
                desktop: 20.0,
              )),
              _buildFilterPanel(currentUserAsync, usersAsync),
            ],

            // Lista de timesheets
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: responsive.responsiveValue(
                    mobile: 12.0,
                    tablet: 16.0,
                    desktop: 20.0,
                  )),
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
      padding: EdgeInsets.all(8.0),
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
                      AppButton.mini(
                        type: MiniButtonType.sortMiniButton,
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
                      
                      // Botões de seleção - mesmo que não sejam admin, o layout fica consistente
                      const SizedBox(width: 4),
                      AppButton.mini(
                        type: MiniButtonType.selectAllMiniButton,
                        onPressed: isAdmin ? () {
                          final timesheetsAsync = ref.read(timesheetsProvider);
                          final currentUserAsync = ref.read(currentUserProvider);
                          final filters = ref.read(timesheetFiltersProvider);
                          
                          timesheetsAsync.whenData((timesheets) {
                            currentUserAsync.whenData((currentUser) {
                              final filteredTimesheets = _applyFilters(timesheets, filters, currentUser);
                              setState(() {
                                _selectedDocIds.clear();
                                for (var ts in filteredTimesheets) {
                                  _selectedDocIds.add(ts.uniqueId);
                                }
                              });
                            });
                          });
                        } : () {}, // Função vazia para não-admin em vez de null
                      ),
                      const SizedBox(width: 4),
                      AppButton.mini(
                        type: MiniButtonType.deselectAllMiniButton,
                        onPressed: isAdmin ? () {
                          setState(() {
                            _selectedDocIds.clear();
                          });
                        } : () {}, // Função vazia para não-admin em vez de null
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          
          // Contador de selecionados - posicionado logo abaixo dos botões à direita
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              currentUserAsync.when(
                data: (user) {
                  final isAdmin = user?.role?.toLowerCase() == 'admin';
                  
                  if (isAdmin) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Selected: ${_selectedDocIds.length}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
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
        });
      },
      onCreatorChanged: (creator) {
        setState(() {
          if (creator == null || creator == 'Creator') {
            _candidateFilters = _candidateFilters.copyWith(clearCreatorId: true);
          } else {
            // Encontrar o ID do usuário pelo nome
            usersAsync.whenData((users) {
              final fullName = creator;
              final user = users.firstWhere(
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
                _candidateFilters = _candidateFilters.copyWith(creatorId: user.id);
              }
            });
          }
        });
      },
      onSearchChanged: (text) {
        // Atualizar o texto de busca candidato
        setState(() {
          _candidateFilters = _candidateFilters.copyWith(searchText: text);
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
      onApply: () {
        // Aplicar filtros
        ref.read(timesheetFiltersProvider.notifier).state = _candidateFilters.copyWith(
          searchText: _searchController.text.trim(),
        );
        // Fechar painel de filtros
        setState(() {
          _showFilters = false;
        });
        // Recarregar os timesheets filtrados
        ref.invalidate(timesheetsProvider);
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
                  final docId = item.uniqueId;

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
                        context.goNamed(
                          AppRoutes.timesheetViewName,
                          pathParameters: {'id': docId},
                        );
                      },
                      child: TimesheetRowItem(
                        day: day,
                        month: month,
                        jobName: jobName,
                        userName: userName,
                        initialChecked: isChecked,
                        onCheckChanged: (checked) {
                          setState(() {
                            if (checked) {
                              _selectedDocIds.add(docId);
                            } else {
                              _selectedDocIds.remove(docId);
                            }
                          });
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
      });
    }
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