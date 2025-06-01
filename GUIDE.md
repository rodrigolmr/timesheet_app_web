# Guia Consolidado de Desenvolvimento - Timesheet App

Este documento unifica todas as diretrizes essenciais para o desenvolvimento do Timesheet App. Uma IA ou desenvolvedor deve ser capaz de implementar qualquer funcionalidade seguindo estas instruções.

## Índice

1. [Visão Geral do Projeto](#visão-geral-do-projeto)
2. [Configuração e Comandos](#configuração-e-comandos)
3. [Arquitetura do Projeto](#arquitetura-do-projeto)
4. [Sistema de Temas - PRÁTICAS OBRIGATÓRIAS](#sistema-de-temas---práticas-obrigatórias)
5. [Sistema Responsivo](#sistema-responsivo)
6. [Estrutura do Banco de Dados](#estrutura-do-banco-de-dados)
7. [Gerenciamento de Estado com Riverpod](#gerenciamento-de-estado-com-riverpod)
8. [Implementação de Features](#implementação-de-features)
9. [Sistema de Pesquisa Local](#sistema-de-pesquisa-local)
10. [Navegação](#navegação)
11. [Componentes de UI](#componentes-de-ui)
12. [Fluxo de Autenticação](#fluxo-de-autenticação)
13. [Sistema de Permissões e Roles](#sistema-de-permissões-e-roles)
14. [Exemplos Práticos](#exemplos-práticos)
15. [Decisões Arquiteturais](#decisões-arquiteturais)
16. [Troubleshooting](#troubleshooting)

## Visão Geral do Projeto

### Descrição
O Timesheet App é uma aplicação web desenvolvida em Flutter para gerenciamento de:
- Horas trabalhadas por funcionários em diferentes projetos
- Despesas corporativas com cartões da empresa
- Aprovação de registros de trabalho e despesas

### Idiomas
- **Comunicação com desenvolvedor**: Português (pt-BR)
- **Interface do usuário**: SEMPRE em inglês (en-US) - todos os textos, botões, mensagens
- **Código e comentários**: Inglês

### Tecnologias
- **Frontend**: Flutter Web
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Estado**: Riverpod com geração de código
- **Modelos**: Freezed para imutabilidade
- **Roteamento**: GoRouter
- **Persistência**: Offline-first com cache do Firestore

## Configuração e Comandos

### Dependências Principais
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  firebase_core: ^2.17.0
  firebase_auth: ^4.10.1
  cloud_firestore: ^4.9.3
  go_router: ^13.0.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  riverpod_generator: ^2.3.0
  freezed: ^2.4.1
  json_serializable: ^6.7.1
  build_runner: ^2.4.6
```

### Comandos Essenciais
```bash
# Executar o app
flutter run -d chrome

# Gerar código (Freezed, Riverpod, JSON)
dart run build_runner build --delete-conflicting-outputs

# Watch mode para geração automática
dart run build_runner watch --delete-conflicting-outputs

# Limpar projeto
flutter clean && dart run build_runner clean

# Build para produção
flutter build web --release
```

## Arquitetura do Projeto

### Estrutura de Pastas
```
lib/
├── main.dart                    # Ponto de entrada
└── src/
    ├── core/                    # Funcionalidades centrais
    │   ├── config/             # Firebase e configurações
    │   ├── constants/          # Constantes globais
    │   ├── enums/              # Enumeradores
    │   ├── errors/             # Classes de erro customizadas
    │   ├── interfaces/         # Interfaces base
    │   ├── navigation/         # Rotas e navegação
    │   ├── providers/          # Providers globais
    │   ├── repositories/       # Repositório base Firebase
    │   ├── responsive/         # Sistema responsivo
    │   ├── services/           # Serviços globais (pesquisa)
    │   ├── theme/              # Sistema de temas
    │   ├── utils/              # Utilitários
    │   └── widgets/            # Widgets globais
    │       ├── app_header.dart # AppBar padrão
    │       ├── buttons/        # Botões customizados
    │       ├── input/          # Campos de entrada
    │       ├── logo/           # Logos
    │       └── navigation/     # Componentes de navegação
    └── features/               # Funcionalidades por domínio
        ├── auth/               # Autenticação
        ├── employee/           # Funcionários
        ├── expense/            # Despesas
        ├── company_card/       # Cartões corporativos
        ├── job_record/         # Registros de trabalho
        └── user/               # Usuários
            ├── data/
            │   ├── models/     # Modelos Freezed
            │   └── repositories/ # Implementações
            ├── domain/
            │   └── repositories/ # Interfaces
            └── presentation/
                ├── providers/  # Estado Riverpod
                ├── screens/    # Telas
                └── widgets/    # Widgets específicos
```

### Padrões Clean Architecture

1. **Data Layer**: Implementações concretas, modelos, acesso ao Firebase
2. **Domain Layer**: Interfaces, regras de negócio, entidades
3. **Presentation Layer**: UI, state management, widgets

## Sistema de Temas - PRÁTICAS OBRIGATÓRIAS

### ⚠️ REGRA FUNDAMENTAL ⚠️
**SEMPRE** acesse elementos do tema através das extensões de contexto.
**NUNCA** importe diretamente as classes de tema.

### ✅ CORRETO: Usar extensões
```dart
Widget build(BuildContext context) {
  return Container(
    color: context.colors.primary,
    padding: EdgeInsets.all(context.dimensions.spacingM),
    child: Text(
      'Hello World',
      style: context.textStyles.title,
    ),
  );
}
```

### ❌ INCORRETO: Importar classes
```dart
// NUNCA FAÇA ISSO
import 'package:timesheet_app_web/src/core/theme/app_colors.dart';
import 'package:timesheet_app_web/src/core/theme/app_dimensions.dart';
```

### Extensões Disponíveis

```dart
// Cores
context.colors.primary           // Cor primária
context.colors.secondary         // Cor secundária
context.colors.background        // Cor de fundo
context.colors.surface           // Cor de superfície
context.colors.error             // Cor de erro
context.colors.success           // Cor de sucesso

// Cores de categoria (use strings)
context.categoryColorByName("timesheet")  // Cor para timesheets
context.categoryColorByName("receipt")    // Cor para recibos
context.categoryColorByName("settings")   // Cor para configurações
context.categoryColorByName("add")        // Cor para ações de adicionar
context.categoryColorByName("cancel")     // Cor para ações de cancelar

// Texto
context.textStyles.headline      // Título grande
context.textStyles.title         // Título
context.textStyles.subtitle      // Subtítulo
context.textStyles.body          // Texto principal
context.textStyles.caption       // Texto pequeno
context.textStyles.button        // Texto de botão

// Dimensões
context.dimensions.spacingXS     // 4.0
context.dimensions.spacingS      // 8.0
context.dimensions.spacingM      // 16.0
context.dimensions.spacingL      // 24.0
context.dimensions.spacingXL     // 32.0

// Bordas
context.dimensions.borderRadiusS // 4.0
context.dimensions.borderRadiusM // 8.0
context.dimensions.borderRadiusL // 16.0

// Atalhos úteis
context.isDarkTheme              // Verifica se é tema escuro
context.padding                  // Padding padrão
context.horizontalPadding        // Padding horizontal
```

### Temas Disponíveis

1. **Azul (light)**: Tema padrão corporativo
2. **Escuro (dark)**: Para ambientes com pouca luz
3. **Rosa (feminine)**: Alternativa com tons rosa
4. **Verde (green)**: Tema com tons naturais

### Controle de Tema por Usuário

```dart
// Mudar tema
ref.setTheme(ThemeVariant.dark);

// Alternar entre claro/escuro
ref.toggleLightDark();

// Verificar se usuário pode mudar tema
final canChange = await ref.read(canUserChangeThemeProvider.future);
```

## Sistema Responsivo

### Breakpoints
- **xs**: 320px (mobile pequeno)
- **sm**: 400px (mobile)
- **md**: 600px (tablet pequeno)
- **lg**: 840px (tablet/desktop pequeno)
- **xl**: 1200px (desktop)

### Valores Responsivos

```dart
// Valores diferentes por tamanho de tela
final fontSize = context.responsive<double>(
  xs: 14,  // Mobile
  sm: 16,  // Mobile maior
  md: 18,  // Tablet
  lg: 20,  // Desktop pequeno
  xl: 22,  // Desktop grande
);

// Checagens de tamanho
if (context.isMobile) {
  // Lógica para mobile
}

// Valores pré-definidos
context.fontSizeBody        // 14-18px automático
context.fontSizeTitle       // 18-32px automático
context.iconSizeMedium      // 20-28px automático
context.borderRadiusMedium  // 8-20px automático
```

### Layouts Responsivos

```dart
ResponsiveLayout(
  mobile: MobileLayout(),      // Required
  tablet: TabletLayout(),      // Optional
  desktop: DesktopLayout(),    // Optional
)

ResponsiveContainer(
  xlMaxWidth: 1200,  // Limite máximo em desktop
  child: content,
)
```

### Grid System

```dart
ResponsiveGrid(
  spacing: 16.0,
  xsColumns: 1,   // Mobile
  smColumns: 2,   // Mobile grande
  mdColumns: 3,   // Tablet
  lgColumns: 4,   // Desktop
  children: [...],
)
```

## Estrutura do Banco de Dados

### Coleções Firestore

#### users
```typescript
{
  id: string                  // ID do documento
  auth_uid: string           // UID do Firebase Auth
  email: string              // Email do usuário
  first_name: string         // Primeiro nome
  last_name: string          // Sobrenome
  role: string               // "admin" | "manager" | "user"
  is_active: boolean         // Status ativo
  theme_preference?: string  // Tema preferido
  forced_theme?: boolean     // Se tema é forçado
  created_at: timestamp
  updated_at: timestamp
}
```

#### employees
```typescript
{
  id: string
  first_name: string
  last_name: string
  is_active: boolean
  created_at: timestamp
  updated_at: timestamp
}
```

#### company_cards
```typescript
{
  id: string
  holder_name: string       // Nome do titular
  last_four_digits: string  // Últimos 4 dígitos
  is_active: boolean
  created_at: timestamp
  updated_at: timestamp
}
```

#### expenses
```typescript
{
  id: string
  user_id: string         // Quem registrou
  card_id: string         // Cartão usado
  amount: number          // Valor
  date: timestamp         // Data da transação
  description: string
  image_url?: string      // URL do recibo
  created_at: timestamp
  updated_at: timestamp
}
```

#### job_records
```typescript
{
  id: string
  user_id: string                // Quem criou
  job_name: string               // Nome do projeto
  date: timestamp                // Data do trabalho
  territorial_manager: string    // Gerente territorial
  job_size: string              // Tamanho do trabalho
  material: string              // Material usado
  job_description: string       // Descrição
  foreman: string               // Encarregado
  vehicle: string               // Veículo
  employees: Array<{
    employee_id: string
    employee_name: string
    start_time: string        // HH:MM
    finish_time: string       // HH:MM
    hours: number
    travel_hours: number
    meal: number
  }>
  created_at: timestamp
  updated_at: timestamp
}
```

## Gerenciamento de Estado com Riverpod

### Provider Básico

```dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
Future<List<UserModel>> users(UsersRef ref) {
  return ref.watch(userRepositoryProvider).getAll();
}

@riverpod
Stream<List<UserModel>> usersStream(UsersStreamRef ref) {
  return ref.watch(userRepositoryProvider).watchAll();
}
```

### Notifier para Estado Mutável

```dart
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}
```

### AsyncValue para Estados Assíncronos

```dart
// No provider
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<User?> build() {
    return const AsyncData(null);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _authenticate(email, password);
      state = AsyncData(user);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

// Na UI
ref.watch(authStateProvider).when(
  data: (user) => HomePage(),
  loading: () => LoadingScreen(),
  error: (e, st) => ErrorScreen(error: e),
);
```

### Providers com Cache (offline-first)

```dart
@Riverpod(keepAlive: true)
Stream<List<UserModel>> cachedUsers(CachedUsersRef ref) {
  return ref.watch(usersStreamProvider);
}
```

## Implementação de Features

### 1. Criar Modelo com Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required bool isActive,
    String? themePreference,
    bool? forcedTheme,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      firstName: data['first_name'] as String,
      lastName: data['last_name'] as String,
      role: data['role'] as String,
      isActive: data['is_active'] as bool,
      themePreference: data['theme_preference'] as String?,
      forcedTheme: data['forced_theme'] as bool?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'is_active': isActive,
      'theme_preference': themePreference,
      'forced_theme': forcedTheme,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### 2. Implementar Repositório

```dart
// Interface
abstract class UserRepository {
  Future<UserModel?> getById(String id);
  Future<List<UserModel>> getAll();
  Future<String> create(UserModel user);
  Future<void> update(String id, UserModel user);
  Future<void> delete(String id);
  Stream<List<UserModel>> watchAll();
  Stream<UserModel?> watchById(String id);
}

// Implementação
class FirestoreUserRepository extends FirestoreRepository<UserModel> 
    implements UserRepository {
  FirestoreUserRepository({required FirebaseFirestore firestore})
      : super(collectionPath: 'users', firestore: firestore);

  @override
  UserModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(UserModel entity) {
    return entity.toFirestore();
  }
}
```

### 3. Criar Providers

```dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
Future<List<UserModel>> users(UsersRef ref) {
  return ref.watch(userRepositoryProvider).getAll();
}

@riverpod
Stream<List<UserModel>> usersStream(UsersStreamRef ref) {
  return ref.watch(userRepositoryProvider).watchAll();
}

@riverpod
class UserState extends _$UserState {
  @override
  AsyncValue<UserModel?> build() {
    return const AsyncData(null);
  }

  Future<void> create(UserModel user) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(userRepositoryProvider).create(user);
      state = AsyncData(user.copyWith(id: id));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
```

### 4. Implementar Tela

```dart
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Users',
        subtitle: 'Manage system users',
        showBackButton: true,
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context, ref),
      ),
      body: usersAsync.when(
        data: (users) => _buildUserList(context, users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: context.textStyles.body.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context, List<UserModel> users) {
    if (users.isEmpty) {
      return _buildEmptyState(context);
    }

    return ResponsiveContainer(
      child: ListView.builder(
        padding: context.padding,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(context, user);
        },
      ),
    );
  }
}
```

## Sistema de Pesquisa Local

### Implementação de Pesquisa

```dart
// 1. Provider para query de pesquisa
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

// 2. Provider para filtros
@riverpod
class UserSearchFilters extends _$UserSearchFilters {
  @override
  ({String? role, bool? isActive}) build() {
    return (role: null, isActive: null);
  }

  void updateRole(String? role) {
    state = (role: role, isActive: state.isActive);
  }

  void updateIsActive(bool? isActive) {
    state = (role: state.role, isActive: isActive);
  }
}

// 3. Provider de pesquisa
@riverpod
List<UserModel> searchUsers(
  SearchUsersRef ref, {
  required String query,
  String? role,
  bool? isActive,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final usersAsync = ref.watch(cachedUsersProvider);
  
  return usersAsync.when(
    data: (users) {
      // Filtros
      final filters = <bool Function(UserModel)>[];
      if (role != null) {
        filters.add((user) => user.role == role);
      }
      if (isActive != null) {
        filters.add((user) => user.isActive == isActive);
      }

      // Pesquisa
      return searchService.search(
        items: users,
        query: query,
        searchFields: (user) => [
          user.firstName,
          user.lastName,
          user.email,
        ],
        filters: filters,
        sortBy: (a, b) => a.firstName.compareTo(b.firstName),
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// 4. Provider de resultados
@riverpod
List<UserModel> userSearchResults(UserSearchResultsRef ref) {
  final query = ref.watch(userSearchQueryProvider);
  final filters = ref.watch(userSearchFiltersProvider);
  
  return ref.watch(searchUsersProvider(
    query: query,
    role: filters.role,
    isActive: filters.isActive,
  ));
}
```

## Navegação

### Configuração de Rotas

```dart
// Em routes.dart
enum AppRoute {
  login('/login'),
  home('/'),
  employees('/employees'),
  employeeDetails('/employees/:id'),
  expenseCreate('/expenses/create'),
  // ... outras rotas
  ;

  const AppRoute(this.path);
  final String path;
}

// Em routes.g.dart (gerado) ou configuração do GoRouter
final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.employees.path,
      name: AppRoute.employees.name,
      builder: (context, state) => const EmployeesScreen(),
    ),
    GoRoute(
      path: AppRoute.employeeDetails.path,
      name: AppRoute.employeeDetails.name,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EmployeeDetailsScreen(employeeId: id);
      },
    ),
  ],
);
```

### Navegação na UI

```dart
// Navegar para rota
context.go(AppRoute.employees.path);

// Navegar com parâmetros
context.go('/employees/$id');

// Voltar
context.pop();

// Push com retorno
context.push('/employees/create');
```

## Componentes de UI

### Botões

O projeto oferece duas abordagens para botões:

#### 1. Botões Padrão do Flutter (Recomendado para flexibilidade)

```dart
// ElevatedButton
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: context.colors.primary,
    foregroundColor: context.colors.onPrimary,
  ),
  child: Text('Save'),
)

// TextButton
TextButton(
  onPressed: () {},
  child: Text('Cancel'),
)

// IconButton
IconButton(
  icon: Icon(Icons.edit),
  onPressed: () {},
  color: context.colors.primary,
)

// FloatingActionButton
FloatingActionButton(
  onPressed: () {},
  backgroundColor: context.colors.primary,
  child: Icon(Icons.add),
)
```

#### 2. Componentes Customizados (Para consistência visual)

```dart
AppButton(
  onPressed: () {},
  child: Text('Primary Button'),
)

AppButton.secondary(
  onPressed: () {},
  child: Text('Secondary Button'),
)

AppIconButton(
  icon: Icons.edit,
  onPressed: () {},
  tooltip: 'Edit',
)
```

### Diálogos Padronizados

O projeto oferece um conjunto completo de diálogos padronizados para manter consistência visual e facilitar o desenvolvimento.

#### 1. AppFormDialog - Para formulários

```dart
// Criação de novo item
showAppFormDialog(
  context: context,
  title: 'Add Employee',
  icon: Icons.person_add,
  mode: DialogMode.create,
  content: MyFormWidget(),
  actions: [
    AppFormDialogActions(
      isLoading: _isLoading,
      mode: DialogMode.create,
      onConfirm: _handleSubmit,
    ),
  ],
);

// Edição de item existente
showAppFormDialog(
  context: context,
  title: 'Edit Employee',
  icon: Icons.edit,
  mode: DialogMode.edit,
  content: MyFormWidget(),
);
```

#### 2. AppDetailsDialog - Para visualização de detalhes

```dart
showAppDetailsDialog(
  context: context,
  title: 'Employee Details',
  icon: Icons.person,
  statusBadge: StatusBadgeWidget(), // Opcional
  content: DetailsContentWidget(),
  actions: [ // Opcional
    ElevatedButton(
      onPressed: () => _editEmployee(),
      child: Text('Edit'),
    ),
  ],
);
```

#### 3. AppConfirmDialog - Para confirmações

```dart
// Confirmação normal
final confirmed = await showAppConfirmDialog(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed?',
  confirmText: 'Yes',
  cancelText: 'No',
);

// Ação perigosa (botão vermelho)
final confirmed = await showAppConfirmDialog(
  context: context,
  title: 'Delete Item',
  message: 'This action cannot be undone.',
  actionType: ConfirmActionType.danger,
  confirmText: 'Delete',
);

// Aviso (botão amarelo)
final confirmed = await showAppConfirmDialog(
  context: context,
  title: 'Warning',
  message: 'This will affect other records.',
  actionType: ConfirmActionType.warning,
);
```

#### 4. AppAlertDialog - Para notificações

```dart
// Erro
await showErrorDialog(
  context: context,
  title: 'Operation Failed',
  message: 'Unable to save the record.',
);

// Sucesso
await showSuccessDialog(
  context: context,
  title: 'Success!',
  message: 'Record saved successfully.',
);

// Aviso
await showWarningDialog(
  context: context,
  title: 'Attention',
  message: 'Some fields need review.',
);

// Informação
await showInfoDialog(
  context: context,
  title: 'Information',
  message: 'New features are available.',
);
```

#### 5. AppChoiceDialog - Para seleção de opções

```dart
// Seleção única
final selected = await showAppChoiceDialog<String>(
  context: context,
  title: 'Select Status',
  items: [
    ChoiceItem(
      value: 'active',
      label: 'Active',
      icon: Icons.check_circle,
      color: Colors.green,
    ),
    ChoiceItem(
      value: 'inactive',
      label: 'Inactive',
      icon: Icons.cancel,
      color: Colors.red,
    ),
  ],
  selectedValue: currentStatus,
);

// Seleção múltipla
final selected = await showAppMultipleChoiceDialog<String>(
  context: context,
  title: 'Select Permissions',
  items: permissionsList,
);
```

#### 6. AppProgressDialog - Para operações em andamento

```dart
// Progresso indeterminado
showAppProgressDialog(
  context: context,
  title: 'Loading...',
  message: 'Please wait',
);

// Progresso com porcentagem
showAppProgressDialog(
  context: context,
  title: 'Uploading',
  message: 'Uploading file...',
  progress: 0.75,
  showProgress: true,
);

// Com controller para atualização dinâmica
final controller = ProgressDialogController(
  title: 'Processing',
  showProgress: true,
);

await showAppProgressDialogWithController(
  context: context,
  controller: controller,
  task: () async {
    for (int i = 0; i <= 100; i++) {
      controller.updateBoth(
        'Processing item $i of 100',
        i / 100,
      );
      await Future.delayed(Duration(milliseconds: 50));
    }
  },
);
```

### Boas Práticas para Diálogos

#### Quando usar cada tipo de diálogo:

1. **AppFormDialog**: Criação e edição de registros
2. **AppDetailsDialog**: Visualização de informações detalhadas
3. **AppConfirmDialog**: Confirmações de ações (deletar, alterar status)
4. **AppAlertDialog**: Mensagens de erro, sucesso, avisos
5. **AppChoiceDialog**: Seleção entre opções pré-definidas
6. **AppProgressDialog**: Operações assíncronas longas

#### Padrões de implementação:

```dart
// Exemplo completo: CRUD com diálogos padronizados
class EmployeeScreen extends ConsumerWidget {
  // Criar novo registro
  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _CreateEmployeeDialog(),
    );
  }
  
  // Visualizar detalhes
  void _showDetailsDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (_) => _EmployeeDetailsDialog(employee: employee),
    );
  }
  
  // Deletar com confirmação
  Future<void> _deleteEmployee(BuildContext context, Employee employee) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete Employee?',
      message: 'This action cannot be undone.',
      actionType: ConfirmActionType.danger,
      confirmText: 'Delete',
    );
    
    if (confirmed == true) {
      try {
        // Mostrar progresso
        showAppProgressDialog(
          context: context,
          title: 'Deleting...',
          message: 'Please wait',
        );
        
        await repository.delete(employee.id);
        
        if (context.mounted) {
          Navigator.of(context).pop(); // Fechar progresso
          
          // Mostrar sucesso
          await showSuccessDialog(
            context: context,
            title: 'Success',
            message: 'Employee deleted successfully.',
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Fechar progresso
          
          // Mostrar erro
          await showErrorDialog(
            context: context,
            title: 'Error',
            message: 'Failed to delete employee: $e',
          );
        }
      }
    }
  }
}

// Widget de criação com AppFormDialog
class _CreateEmployeeDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends ConsumerState<_CreateEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Create Employee',
      icon: Icons.person_add,
      mode: DialogMode.create,
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.create,
          onConfirm: _handleSubmit,
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            // Campos do formulário
          ],
        ),
      ),
    );
  }
}

// Widget de detalhes com AppDetailsDialog
class _EmployeeDetailsDialog extends ConsumerWidget {
  final Employee employee;
  
  const _EmployeeDetailsDialog({required this.employee});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppDetailsDialog(
      title: employee.name,
      icon: Icons.person,
      statusBadge: _buildStatusBadge(context),
      content: Column(
        children: [
          // Conteúdo dos detalhes
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Edit'),
                onPressed: () => _showEditDialog(context),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.error,
                ),
                onPressed: () => _deleteEmployee(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

#### Dicas importantes:

1. **Sempre use `context.mounted`** após operações assíncronas
2. **Feche diálogos de progresso** antes de mostrar outros diálogos
3. **Use tipos de ação apropriados** para confirmações (danger para deletar)
4. **Mantenha consistência** nos textos dos botões
5. **Trate erros adequadamente** com diálogos de erro
6. **Use statusBadge** em detalhes para indicar estado visual

### Campos de Entrada

```dart
// Campo de texto
AppTextField(
  label: 'Name',
  hint: 'Enter your name',
  controller: nameController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  },
)

// Campo de email
AppTextField.email(
  label: 'Email',
  controller: emailController,
)

// Campo de senha
AppPasswordField(
  label: 'Password',
  controller: passwordController,
)

// Dropdown
AppDropdownField<String>(
  label: 'Role',
  value: selectedRole,
  items: ['admin', 'manager', 'user'],
  itemBuilder: (role) => Text(role),
  onChanged: (role) => setState(() => selectedRole = role),
)

// Date picker
AppDatePickerField(
  label: 'Date',
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
)
```

### Header Padrão

```dart
AppHeader(
  title: 'Page Title',
  subtitle: 'Page description',
  showBackButton: true,
  showNavigationMenu: false,
  actionIcon: Icons.add,
  onActionPressed: () => _showCreateDialog(),
)
```

## Fluxo de Autenticação

### 1. Login

```dart
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<User?> build() {
    // Observa mudanças de autenticação
    ref.listen(authStateChangesProvider, (_, next) {
      next.when(
        data: (user) => state = AsyncData(user),
        error: (e, st) => state = AsyncError(e, st),
        loading: () => state = const AsyncLoading(),
      );
    });
    
    final currentUser = ref.watch(currentUserProvider);
    return currentUser != null ? AsyncData(currentUser) : const AsyncData(null);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
      // Estado atualizado automaticamente pelo listener
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
```

### 2. Verificação de Perfil

```dart
@riverpod
Future<UserModel?> currentUserProfile(CurrentUserProfileRef ref) async {
  final authChanges = ref.watch(authStateChangesProvider);
  
  return authChanges.when(
    data: (authUser) async {
      if (authUser == null) return null;
      return await ref.read(userRepositoryProvider)
          .getUserByAuthUid(authUser.uid);
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
```

### 3. Proteção de Rotas

```dart
// No GoRouter
redirect: (context, state) async {
  final authState = ref.read(authStateProvider);
  final isAuthenticated = authState.valueOrNull != null;
  final isLoginRoute = state.matchedLocation == '/login';
  
  if (!isAuthenticated && !isLoginRoute) {
    return '/login';
  }
  
  if (isAuthenticated && isLoginRoute) {
    return '/';
  }
  
  return null;
},
```

## Exemplos Práticos

### Criar Formulário Completo

```dart
class CreateUserForm extends ConsumerStatefulWidget {
  const CreateUserForm({super.key});

  @override
  ConsumerState<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends ConsumerState<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'user';
  bool _isActive = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(userStateProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _firstNameController,
            label: 'First Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
          SizedBox(height: context.dimensions.spacingM),
          
          AppTextField(
            controller: _lastNameController,
            label: 'Last Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
          SizedBox(height: context.dimensions.spacingM),
          
          AppTextField.email(
            controller: _emailController,
            label: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: context.dimensions.spacingM),
          
          AppDropdownField<String>(
            label: 'Role',
            value: _selectedRole,
            items: const ['admin', 'manager', 'user'],
            itemBuilder: (role) => Text(role.toUpperCase()),
            onChanged: (role) => setState(() => _selectedRole = role!),
          ),
          SizedBox(height: context.dimensions.spacingM),
          
          Row(
            children: [
              Checkbox(
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value!),
              ),
              Text('Active User', style: context.textStyles.body),
            ],
          ),
          SizedBox(height: context.dimensions.spacingL),
          
          createState.when(
            data: (_) => ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                padding: EdgeInsets.symmetric(
                  vertical: context.dimensions.spacingM,
                ),
              ),
              child: Text('Create User'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Column(
              children: [
                Text(
                  'Error: $error',
                  style: context.textStyles.body.copyWith(
                    color: context.colors.error,
                  ),
                ),
                SizedBox(height: context.dimensions.spacingM),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Try Again'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModel(
      id: '',
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      role: _selectedRole,
      isActive: _isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(userStateProvider.notifier).create(user);
    
    if (mounted && ref.read(userStateProvider).hasValue) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User created successfully'),
          backgroundColor: context.colors.success,
        ),
      );
    }
  }
}
```

### Implementar Lista com Pesquisa

```dart
class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(userSearchResultsProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Users',
        subtitle: 'Manage system users',
        actionIcon: Icons.add,
        onActionPressed: () => context.push('/users/create'),
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Container(
            padding: context.padding,
            color: context.colors.surface,
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Search users',
                    hint: 'Search by name or email',
                    onChanged: (value) => ref.read(
                      userSearchQueryProvider.notifier
                    ).updateQuery(value),
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                // Filtros
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (role) => ref.read(
                    userSearchFiltersProvider.notifier
                  ).updateRole(role),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: null, child: Text('All Roles')),
                    PopupMenuItem(value: 'admin', child: Text('Admin')),
                    PopupMenuItem(value: 'manager', child: Text('Manager')),
                    PopupMenuItem(value: 'user', child: Text('User')),
                  ],
                ),
              ],
            ),
          ),
          
          // Lista de resultados
          Expanded(
            child: searchResults.isEmpty
                ? _buildEmptyState(context, searchQuery)
                : _buildUserList(context, searchResults),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context, List<UserModel> users) {
    return ListView.builder(
      padding: context.padding,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: context.colors.primary,
              child: Text(
                user.firstName[0] + user.lastName[0],
                style: TextStyle(color: context.colors.onPrimary),
              ),
            ),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: context.textStyles.subtitle,
            ),
            subtitle: Text(
              user.email,
              style: context.textStyles.body,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(user.role.toUpperCase()),
                  backgroundColor: context.categoryColorByName('user'),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => context.push('/users/${user.id}/edit'),
                ),
              ],
            ),
            onTap: () => context.push('/users/${user.id}'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            query.isEmpty ? Icons.people_outline : Icons.search_off,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            query.isEmpty 
                ? 'No users found' 
                : 'No results for "$query"',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          if (query.isEmpty) ...[
            SizedBox(height: context.dimensions.spacingM),
            ElevatedButton(
              onPressed: () => context.push('/users/create'),
              child: Text('Create First User'),
            ),
          ],
        ],
      ),
    );
  }
}
```

## Decisões Arquiteturais

### Criação de Timesheets
O sistema usa submissão direta ao Firestore, sem drafts intermediários:
- Formulários multi-step com Flutter Stepper
- Estado temporário mantido apenas na memória durante a criação
- Submissão única ao completar todos os passos

### Sistema de Busca
Implementação local para funcionar offline:
- Cache de dados com Firestore persistence
- Busca e filtros executados em memória
- Sem dependência de conexão internet

### Componentes de UI
Duas abordagens disponíveis:
1. Botões padrão do Flutter para máxima flexibilidade
2. Componentes customizados para consistência visual

Escolha baseada no contexto:
- Use componentes customizados para interfaces padrão
- Use Flutter widgets para casos específicos ou layouts complexos

## Sistema de Permissões e Roles

### Visão Geral
O sistema implementa um controle de acesso baseado em roles (RBAC) com três níveis de permissão:
- **admin**: Acesso total ao sistema
- **manager**: Acesso a recursos operacionais e gerenciais
- **user**: Acesso limitado aos próprios recursos

### Estrutura de Permissões

#### 1. Enum UserRole
```dart
enum UserRole {
  admin('admin'),
  manager('manager'),
  user('user');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => UserRole.user,
    );
  }
}
```

#### 2. Permissões de Rotas

| Role | Páginas Permitidas |
|------|-------------------|
| **admin** | Todas as páginas |
| **manager** | Todas exceto: Database |
| **user** | Home, Job Records (próprios), Expenses (próprias), Settings |

#### 3. Permissões de Ações

##### Job Records
- **Criar**: Todos os roles
- **Visualizar**: 
  - User: apenas próprios registros
  - Manager/Admin: todos os registros
- **Editar**:
  - User: apenas próprios registros
  - Manager/Admin: todos os registros
- **Deletar**: Apenas Manager e Admin

##### Expenses
- **Criar**: Todos os roles
- **Visualizar**:
  - User: apenas próprias despesas
  - Manager/Admin: todas as despesas
- **Editar**:
  - User: apenas próprias despesas
  - Manager/Admin: todas as despesas
- **Deletar**: Apenas Manager e Admin

##### Outros Recursos
- **Employees**: Visualização e edição apenas para Manager/Admin
- **Company Cards**: Gerenciamento apenas para Manager/Admin
- **Users**: Gerenciamento apenas para Manager/Admin
- **Database**: Acesso apenas para Admin

### Implementação

#### 1. Verificação de Permissões em Rotas
```dart
// No GoRouter
redirect: (context, state) async {
  // ... autenticação ...
  
  // Verificar permissões da rota
  final hasPermission = await ref.read(
    canAccessRouteProvider(currentRoute).future
  );
  
  if (!hasPermission) {
    return AppRoute.accessDenied.path;
  }
  
  return null;
}
```

#### 2. Providers de Permissão
```dart
// Verificar role do usuário
final role = await ref.watch(currentUserRoleProvider.future);

// Verificar permissões específicas
final canViewAll = await ref.watch(canViewAllJobRecordsProvider.future);
final canEdit = await ref.watch(
  canEditJobRecordProvider(recordCreatorId).future
);
final canDelete = await ref.watch(canDeleteJobRecordProvider.future);
```

#### 3. Filtros em Queries
```dart
// Em providers de Job Records
@riverpod
Stream<List<JobRecordModel>> jobRecordsStream(JobRecordsStreamRef ref) {
  final repository = ref.watch(jobRecordRepositoryProvider);
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  
  if (userProfile == null) return Stream.value([]);
  
  // Aplicar filtro baseado no role
  if (userProfile.userRole == UserRole.user) {
    return repository.watchByUserId(userProfile.id);
  }
  
  // Manager e Admin veem todos
  return repository.watchAll();
}
```

#### 4. Componente PermissionGuard
```dart
// Proteger elementos da UI
PermissionGuard(
  requiredRole: UserRole.manager,
  child: ElevatedButton(
    onPressed: () => _deleteRecord(),
    child: Text('Delete'),
  ),
  fallback: SizedBox.shrink(), // Opcional
)

// Verificação assíncrona
PermissionGuardAsync(
  permissionCheck: (ref) => ref.read(canDeleteJobRecordProvider.future),
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () => _deleteRecord(),
  ),
)
```

#### 5. Ocultação de Navegação
```dart
// Provider filtrado para home
@riverpod
Future<List<HomeNavigationItem>> filteredHomeNavigationItems(
  FilteredHomeNavigationItemsRef ref
) async {
  final allItems = ref.watch(homeNavigationItemsProvider);
  final allowedRoutes = await ref.watch(allowedRoutesProvider.future);
  
  return allItems.where((item) {
    final route = AppRoute.values.firstWhereOrNull(
      (r) => r.path == item.route
    );
    return route != null && allowedRoutes.contains(route);
  }).toList();
}
```

### Boas Práticas

1. **Sempre verifique permissões no backend**: Nunca confie apenas na UI
2. **Use providers reativos**: Permissões podem mudar durante a sessão
3. **Fallback gracioso**: Sempre forneça alternativas quando acesso é negado
4. **Mensagens claras**: Informe o usuário sobre limitações de acesso
5. **Auditoria**: Registre tentativas de acesso não autorizado

### Exemplo Completo: Tela com Permissões
```dart
class JobRecordsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Stream filtrado baseado em permissões
    final recordsAsync = ref.watch(jobRecordsStreamProvider);
    final canDelete = ref.watch(canDeleteJobRecordProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Job Records',
        // Botão de criar visível para todos
        actionIcon: Icons.add,
        onActionPressed: () => _createRecord(context),
      ),
      body: recordsAsync.when(
        data: (records) => ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return ListTile(
              title: Text(record.jobName),
              subtitle: Text(record.date.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Editar - verificação individual
                  PermissionGuardAsync(
                    permissionCheck: (ref) => ref.read(
                      canEditJobRecordProvider(record.userId).future
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editRecord(context, record),
                    ),
                  ),
                  // Deletar - apenas manager/admin
                  if (canDelete.value ?? false)
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteRecord(ref, record),
                    ),
                ],
              ),
            );
          },
        ),
        loading: () => CircularProgressIndicator(),
        error: (e, s) => Text('Error: $e'),
      ),
    );
  }
}
```

## Troubleshooting

### Erro: Importação direta de classes de tema
**Problema**: Código importando `app_colors.dart` diretamente
**Solução**: Use sempre as extensões de contexto (`context.colors`, etc.)

### Erro: Geração de código falha
**Problema**: Build runner não gera arquivos
**Solução**: 
```bash
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Erro: Estado não atualiza na UI
**Problema**: Mudanças no Firestore não refletem na UI
**Solução**: Verifique se está usando Stream providers e `.watch()` corretamente

### Erro: Tema não muda
**Problema**: Mudança de tema não funciona
**Solução**: Verifique se o usuário tem permissão (`canChangeTheme`) e se o provider está sendo observado corretamente

### Erro: Layout quebrado em mobile
**Problema**: UI não se adapta a telas pequenas
**Solução**: Use o sistema responsivo e teste em todos os breakpoints (320px até 1200px)

---

Este guia consolidado contém todas as informações necessárias para desenvolver no Timesheet App. Siga estas diretrizes para manter consistência e qualidade no código.