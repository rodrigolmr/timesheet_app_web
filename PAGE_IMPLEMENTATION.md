# Guia de Implementação de Páginas

Este documento fornece um guia passo a passo completo para implementar novas páginas no Timesheet App. É destinado a desenvolvedores e IAs que precisam criar ou modificar páginas seguindo os padrões estabelecidos do projeto.

## Documentação de Referência

Antes de implementar qualquer página, consulte os seguintes documentos:

- **[DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md)**: Diretrizes gerais de desenvolvimento
- **[RESPONSIVE_GUIDE.md](./RESPONSIVE_GUIDE.md)**: Guia de responsividade
- **[THEME_GUIDE.md](./THEME_GUIDE.md)**: Sistema de temas e estilos
- **[RIVERPOD_GUIDE.md](./RIVERPOD_GUIDE.md)**: Gerenciamento de estado
- **[DATABASE_TREE.md](./DATABASE_TREE.md)**: Estrutura do banco de dados

## 1. Estrutura de Arquivos para Nova Feature

Ao criar uma nova feature, siga esta estrutura:

```
lib/src/features/[feature_name]/
├── data/
│   ├── models/
│   │   └── [model_name]_model.dart
│   │   └── [model_name]_model.freezed.dart (gerado)
│   │   └── [model_name]_model.g.dart (gerado)
│   └── repositories/
│       └── firestore_[feature]_repository.dart
├── domain/
│   └── repositories/
│       └── [feature]_repository.dart
└── presentation/
    ├── providers/
    │   └── [feature]_providers.dart
    │   └── [feature]_providers.g.dart (gerado)
    ├── screens/
    │   └── [feature]_screen.dart
    └── widgets/
        └── [feature]_specific_widgets.dart
```

## 2. Implementação do Modelo de Dados

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part '[model_name]_model.freezed.dart';
part '[model_name]_model.g.dart';

@freezed
class [ModelName]Model with _$[ModelName]Model {
  const [ModelName]Model._(); // Importante para métodos customizados
  
  const factory [ModelName]Model({
    required String id,
    required String name,
    // outros campos...
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _[ModelName]Model;

  factory [ModelName]Model.fromJson(Map<String, dynamic> json) => 
      _$[ModelName]ModelFromJson(json);

  factory [ModelName]Model.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return [ModelName]Model(
      id: doc.id,
      name: data['name'] as String,
      // mapear outros campos...
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      // outros campos...
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}
```

## 3. Configuração de Rotas

### 3.1. Adicionar a rota em `/lib/src/core/navigation/routes.dart`:

```dart
enum AppRoute {
  // rotas existentes...
  featureName('/feature-name'),
  featureDetails('/feature-name/:id');

  const AppRoute(this.path);
  final String path;
}
```

### 3.2. Adicionar no GoRouter:

```dart
GoRoute(
  path: AppRoute.featureName.path,
  name: AppRoute.featureName.name,
  builder: (context, state) => const FeatureScreen(),
),
GoRoute(
  path: AppRoute.featureDetails.path,
  name: AppRoute.featureDetails.name,
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return FeatureDetailsScreen(featureId: id);
  },
),
```

## 4. Implementação do Provider

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part '[feature]_providers.g.dart';

// Provider do repositório
@riverpod
[Feature]Repository [feature]Repository([Feature]RepositoryRef ref) {
  return Firestore[Feature]Repository(
    firestore: ref.watch(firestoreProvider),
  );
}

// Provider para listar todos os itens
@riverpod
Future<List<[Model]Model>> [feature]List([Feature]ListRef ref) {
  return ref.watch([feature]RepositoryProvider).getAll();
}

// Provider para stream de dados
@riverpod
Stream<List<[Model]Model>> [feature]Stream([Feature]StreamRef ref) {
  return ref.watch([feature]RepositoryProvider).watchAll();
}

// Provider para item individual
@riverpod
Future<[Model]Model?> [feature]ById([Feature]ByIdRef ref, String id) {
  return ref.watch([feature]RepositoryProvider).getById(id);
}

// Provider para gerenciar estado (criar, atualizar, deletar)
@riverpod
class [Feature]State extends _$[Feature]State {
  @override
  AsyncValue<[Model]Model?> build() {
    return const AsyncData(null);
  }

  Future<void> create([Model]Model item) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read([feature]RepositoryProvider).create(item);
      state = AsyncData(item.copyWith(id: id));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> update([Model]Model item) async {
    state = const AsyncLoading();
    try {
      await ref.read([feature]RepositoryProvider).update(item.id, item);
      state = AsyncData(item);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read([feature]RepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
```

## 5. Implementação da Tela

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';

class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureListAsync = ref.watch(featureStreamProvider);
    
    return Scaffold(
      // 1. AppHeader padrão
      appBar: AppHeader(
        title: 'Feature Title',
        subtitle: 'Feature description',
        showBackButton: true, // se não for a tela inicial
        showNavigationMenu: false, // true para tela inicial
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context, ref),
      ),
      body: featureListAsync.when(
        data: (items) => _buildContent(context, ref, items),
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

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Model> items) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    // 2. Layout responsivo
    return ResponsiveContainer(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. Título da seção
            Text(
              'Section Title',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            
            // 4. Lista de cards
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildItemCard(context, ref, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, WidgetRef ref, Model item) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.spacingM),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () => context.go(
            '${AppRoute.featureName.path}/${item.id}',
          ),
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Row(
              children: [
                // 5. Usando cores do tema
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      context.dimensions.borderRadiusS,
                    ),
                  ),
                  child: Icon(
                    Icons.folder,
                    color: context.colors.primary,
                    size: 30,
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                
                // 6. Conteúdo do card
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: context.textStyles.title,
                      ),
                      SizedBox(height: context.dimensions.spacingXS),
                      Text(
                        'Created: ${_formatDate(item.createdAt)}',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 7. Ações do card
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIconButton(
                      icon: Icons.edit,
                      onPressed: () => _showEditDialog(context, ref, item),
                      tooltip: 'Edit',
                    ),
                    AppIconButton(
                      icon: Icons.delete,
                      onPressed: () => _confirmDelete(context, ref, item),
                      tooltip: 'Delete',
                      color: context.colors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
            Icons.inbox,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: context.dimensions.spacingM),
          Text(
            'No items found',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          AppButton(
            onPressed: () => _showCreateDialog(context, ref),
            child: Text('Create First Item'),
          ),
        ],
      ),
    );
  }

  // 8. Diálogos e forms
  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: context.responsive<double>(
            xs: double.infinity,
            sm: 400,
            md: 500,
          ),
          padding: EdgeInsets.all(context.dimensions.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Item',
                style: context.textStyles.headline,
              ),
              SizedBox(height: context.dimensions.spacingM),
              
              // 9. Campos de input
              AppTextField(
                label: 'Name',
                hint: 'Enter item name',
                controller: TextEditingController(),
              ),
              SizedBox(height: context.dimensions.spacingM),
              
              // 10. Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.secondary(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  AppButton(
                    onPressed: () => _handleCreate(context, ref),
                    child: Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Model item) {
    // Similar ao create dialog, mas com dados preenchidos
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Model item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDelete(ref, item.id);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }

  // 11. Handlers de ações
  void _handleCreate(BuildContext context, WidgetRef ref) async {
    // Validar dados do form
    // Chamar o provider para criar
    try {
      await ref.read(featureStateProvider.notifier).create(newItem);
      Navigator.of(context).pop();
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item created successfully'),
          backgroundColor: context.colors.success,
        ),
      );
    } catch (e) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }

  void _handleDelete(WidgetRef ref, String id) async {
    try {
      await ref.read(featureStateProvider.notifier).delete(id);
      // Mostrar mensagem de sucesso
    } catch (e) {
      // Mostrar erro
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

## 6. Layout Responsivo

### 6.1. Breakpoints do Sistema
```dart
// Breakpoints definidos
xs: 320px   // Mobile pequeno
sm: 400px   // Mobile regular
md: 600px   // Tablet pequeno
lg: 840px   // Tablet grande/Desktop pequeno
xl: 1200px  // Desktop
```

### 6.2. Sistema Grid Responsivo

O projeto inclui componentes de grid prontos:

```dart
// Grid básico
ResponsiveGrid(
  spacing: 16.0,
  xsColumns: 2,   // 1 coluna em mobile
  smColumns: 2,   // 2 colunas em mobile maior
  mdColumns: 3,   // 3 colunas em tablet
  lgColumns: 4,   // 4 colunas em desktop pequeno
  xlColumns: 5,   // 5 colunas em desktop grande
  children: [
    CardWidget(),
    CardWidget(),
    // ...
  ],
)

// Grid com aspect ratio fixo
ResponsiveGridTile(
  aspectRatio: 1.5,  // Proporção largura/altura
  xsColumns: 1,
  mdColumns: 2,
  lgColumns: 3,
  children: [
    TileWidget(),
    TileWidget(),
    // ...
  ],
)
```

### 6.3. Layouts Responsivos Completos

```dart
ResponsiveLayout(
  mobile: _buildMobileLayout(),
  tablet: _buildTabletLayout(),
  desktop: _buildDesktopLayout(),
)

// Ou com container responsivo
ResponsiveContainer(
  xsMaxWidth: null,    // Sem limite em mobile
  mdMaxWidth: 600,     // Max 600px em tablet
  xlMaxWidth: 1200,    // Max 1200px em desktop
  child: content,
)
```

### 6.4. Valores Responsivos

```dart
// Padding/Spacing
final padding = context.responsive<double>(
  xs: 8.0,
  sm: 16.0,
  md: 24.0,
  lg: 32.0,
);

// Tamanhos de fonte (use os predefinidos)
final fontSize = context.fontSizeBody;     // 14-18px
final titleSize = context.fontSizeTitle;   // 18-32px
final headSize = context.fontSizeHeadline; // 22-42px

// Tamanhos de ícone (use os predefinidos)
final iconSize = context.iconSizeMedium;   // 20-28px
final iconLarge = context.iconSizeLarge;   // 24-40px

// Border radius (use os predefinidos)
final radius = context.borderRadiusMedium; // 8-20px
```

### 6.5. Exemplo de Layout Responsivo Completo

```dart
Widget _buildContent(BuildContext context, List<Item> items) {
  return ResponsiveContainer(
    xlMaxWidth: 1200,
    child: ResponsiveGrid(
      spacing: context.spacing,
      xsColumns: 1,
      smColumns: 2,
      mdColumns: 3,
      lgColumns: 4,
      children: items.map((item) => _buildCard(context, item)).toList(),
    ),
  );
}

Widget _buildCard(BuildContext context, Item item) {
  return Card(
    elevation: context.responsive<double>(
      xs: 2,
      md: 4,
      xl: 6,
    ),
    child: InkWell(
      onTap: () => _handleCardTap(item),
      borderRadius: BorderRadius.circular(
        context.borderRadiusMedium,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.responsive<double>(
            xs: 12,
            md: 16,
            xl: 20,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              size: context.iconSizeLarge,
              color: context.colors.primary,
            ),
            SizedBox(height: context.spacing),
            Text(
              item.title,
              style: TextStyle(
                fontSize: context.fontSizeTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.spacing / 2),
            Text(
              item.description,
              style: TextStyle(
                fontSize: context.fontSizeBody,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

## 7. Uso do Sistema de Temas

### 7.1. Cores
```dart
// Cores do tema
context.colors.primary
context.colors.secondary
context.colors.background
context.colors.surface
context.colors.error
context.colors.success
context.colors.warning
context.colors.textPrimary
context.colors.textSecondary

// Cores de categorias
context.categoryColorByName('timesheet')
context.categoryColorByName('receipt')
context.categoryColorByName('card')
context.categoryColorByName('worker')
```

### 7.2. Tipografia
```dart
context.textStyles.caption     // Texto pequeno
context.textStyles.body        // Texto principal
context.textStyles.subtitle    // Subtítulos
context.textStyles.title       // Títulos
context.textStyles.headline    // Títulos grandes
```

### 7.3. Espaçamentos
```dart
context.dimensions.spacingXS   // 4.0
context.dimensions.spacingS    // 8.0
context.dimensions.spacingM    // 16.0
context.dimensions.spacingL    // 24.0
context.dimensions.spacingXL   // 32.0
```

### 7.4. Bordas
```dart
context.dimensions.borderRadiusS  // 4.0
context.dimensions.borderRadiusM  // 8.0
context.dimensions.borderRadiusL  // 16.0
```

## 8. Pesquisa Local

Para implementar pesquisa em uma feature:

```dart
// 1. Provider de pesquisa
@riverpod
class FeatureSearchQuery extends _$FeatureSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

// 2. Provider de filtros
@riverpod
class FeatureSearchFilters extends _$FeatureSearchFilters {
  @override
  FeatureFilters build() => FeatureFilters.empty();

  void updateFilters(FeatureFilters filters) {
    state = filters;
  }
}

// 3. Provider de resultados
@riverpod
List<Model> featureSearchResults(FeatureSearchResultsRef ref) {
  final query = ref.watch(featureSearchQueryProvider);
  final filters = ref.watch(featureSearchFiltersProvider);
  final items = ref.watch(featureStreamProvider).valueOrNull ?? [];
  
  if (query.isEmpty && filters.isEmpty) {
    return items;
  }
  
  // Implementar lógica de pesquisa
  return items.where((item) {
    // Verificar query
    if (query.isNotEmpty) {
      final searchFields = [
        item.name,
        item.description,
      ].where((field) => field != null);
      
      final matches = searchFields.any((field) =>
        field!.toLowerCase().contains(query.toLowerCase())
      );
      
      if (!matches) return false;
    }
    
    // Aplicar filtros
    if (filters.status != null && item.status != filters.status) {
      return false;
    }
    
    return true;
  }).toList();
}
```

## 9. Widgets Padronizados

Use os widgets padronizados do projeto:

### 9.1. Botões
```dart
// Botão primário
AppButton(
  onPressed: () {},
  child: Text('Primary Button'),
)

// Botão secundário
AppButton.secondary(
  onPressed: () {},
  child: Text('Secondary Button'),
)

// Botão de ícone
AppIconButton(
  icon: Icons.edit,
  onPressed: () {},
  tooltip: 'Edit',
)

// Floating Action Button
AppFloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
)
```

### 9.2. Inputs
```dart
// Campo de texto
AppTextField(
  label: 'Name',
  hint: 'Enter your name',
  controller: nameController,
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
  label: 'Status',
  value: selectedStatus,
  items: statuses,
  itemBuilder: (status) => Text(status),
  onChanged: (status) {},
)

// Date picker
AppDatePickerField(
  label: 'Date',
  value: selectedDate,
  onChanged: (date) {},
)
```

## 10. Tratamento de Erros

```dart
// 1. Em providers
try {
  final result = await repository.fetchData();
  return result;
} catch (e, stackTrace) {
  // Log do erro
  print('Error fetching data: $e');
  print('Stack trace: $stackTrace');
  
  // Re-throw com mensagem amigável
  throw Exception('Failed to load data. Please try again.');
}

// 2. Na UI
featureAsync.when(
  data: (data) => _buildContent(data),
  loading: () => const Center(
    child: CircularProgressIndicator(),
  ),
  error: (error, stack) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: context.colors.error,
        ),
        SizedBox(height: context.dimensions.spacingM),
        Text(
          'Error loading data',
          style: context.textStyles.title,
        ),
        SizedBox(height: context.dimensions.spacingS),
        Text(
          error.toString(),
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.dimensions.spacingL),
        AppButton(
          onPressed: () => ref.refresh(featureProvider),
          child: Text('Try Again'),
        ),
      ],
    ),
  ),
)
```

## 11. Navegação

```dart
// Navegar para nova rota
context.go(AppRoute.featureName.path);

// Navegar com parâmetros
context.go('${AppRoute.featureName.path}/$id');

// Voltar
context.pop();

// Navegar com query parameters
context.go('${AppRoute.featureName.path}?filter=active');
```

## 12. Estados da Aplicação

### 12.1. Estados de Loading
```dart
// Loading simples
if (isLoading) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

// Loading com shimmer (placeholder)
import 'package:shimmer/shimmer.dart';

Widget _buildLoadingState() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Container(
          height: 80,
          color: Colors.white,
        ),
      ),
    ),
  );
}
```

### 12.2. Estados Vazios
```dart
Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 120,
          color: context.colors.textSecondary.withOpacity(0.3),
        ),
        SizedBox(height: context.dimensions.spacingL),
        Text(
          'No items found',
          style: context.textStyles.headline.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimensions.spacingS),
        Text(
          'Start by creating your first item',
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimensions.spacingXL),
        AppButton(
          onPressed: () => _showCreateDialog(),
          child: Text('Create Item'),
        ),
      ],
    ),
  );
}
```

### 12.3. Estados de Erro
```dart
Widget _buildErrorState(String error, WidgetRef ref) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(context.dimensions.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: context.colors.error,
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'Something went wrong',
            style: context.textStyles.headline.copyWith(
              color: context.colors.error,
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          Container(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                context.dimensions.borderRadiusM,
              ),
            ),
            child: Text(
              error,
              style: context.textStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.dimensions.spacingXL),
          AppButton(
            onPressed: () => ref.refresh(featureProvider),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: context.dimensions.spacingS),
                Text('Try Again'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

## 13. Forms e Validação

### 13.1. Estrutura de Form
```dart
class _FeatureFormState extends State<FeatureForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Name',
            hint: 'Enter your name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              if (value.length < 3) {
                return 'Name must be at least 3 characters';
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
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: context.dimensions.spacingL),
          
          AppButton(
            onPressed: _handleSubmit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process form data
      final name = _nameController.text;
      final email = _emailController.text;
      
      // Call provider or API
      widget.onSubmit(name, email);
    }
  }
}
```

### 13.2. Validadores Comuns
```dart
// Validador reutilizável
class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
  
  static String? minLength(String? value, int length, String fieldName) {
    if (value == null || value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }
  
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
```

## 14. Best Practices e Convenções

### 14.1. Organização de Código
- Mantenha métodos build pequenos (max 50 linhas)
- Extraia widgets complexos em métodos separados
- Use métodos privados para lógica de UI (`_buildContent`)
- Agrupe imports por categoria (flutter, packages, projeto)

### 14.2. Performance
```dart
// Use const sempre que possível
const Icon(Icons.home);
const SizedBox(height: 16);
const EdgeInsets.all(16);

// Use keys para widgets em listas
ListView.builder(
  itemBuilder: (context, index) => ItemWidget(
    key: ValueKey(items[index].id),
    item: items[index],
  ),
);

// Evite rebuilds desnecessários
final expensiveComputation = useMemoized(
  () => computeExpensiveValue(),
  [dependency],
);
```

### 14.3. Acessibilidade
```dart
// Sempre adicione semantics
Semantics(
  label: 'Delete item',
  button: true,
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: onDelete,
  ),
);

// Use tooltips
IconButton(
  icon: Icon(Icons.edit),
  tooltip: 'Edit item',
  onPressed: onEdit,
);

// Contraste de cores adequado
Text(
  'Important text',
  style: TextStyle(
    color: context.colors.textPrimary, // Garante contraste
  ),
);
```

### 14.4. Internacionalização (Preparação)
```dart
// Em vez de strings hardcoded
Text('Welcome')

// Prepare para i18n
Text(context.l10n.welcome) // Futuro

// Por enquanto, use constantes
class AppStrings {
  static const welcome = 'Welcome';
  static const error = 'An error occurred';
  static const retry = 'Try Again';
}

Text(AppStrings.welcome)
```

## 15. Checklist de Implementação

Antes de considerar uma página completa, verifique:

- [ ] Estrutura de arquivos segue o padrão
- [ ] Modelo de dados implementado com Freezed
- [ ] Repositório implementado e testado
- [ ] Providers configurados corretamente
- [ ] Rota adicionada em `routes.dart` e GoRouter
- [ ] AppHeader configurado corretamente
- [ ] Layout responsivo implementado com grid system
- [ ] Sistema de temas aplicado (cores, tipografia, espaçamentos)
- [ ] Widgets padronizados utilizados (buttons, inputs, etc)
- [ ] Estados implementados (loading, empty, error)
- [ ] Tratamento de erros robusto
- [ ] Forms com validação adequada
- [ ] Navegação funcionando com go_router
- [ ] Pesquisa implementada (se aplicável)
- [ ] Performance otimizada (const, keys, etc)
- [ ] Acessibilidade considerada
- [ ] Código gerado executado (`dart run build_runner build`)
- [ ] Testado em todos os breakpoints (320px a 1200px+)
- [ ] Código limpo e bem organizado

## 16. Comandos Úteis

```bash
# Gerar código (freezed, json_serializable, riverpod)
dart run build_runner build --delete-conflicting-outputs

# Watch mode para geração automática
dart run build_runner watch --delete-conflicting-outputs

# Executar o app
flutter run -d chrome

# Limpar e reconstruir
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## 17. Exemplo Completo

Para um exemplo completo de implementação, veja a feature `employee` em:
- `/lib/src/features/employee/`

Esta feature demonstra todos os padrões e práticas descritos neste guia.

## Resumo

Este guia fornece um conjunto completo de diretrizes para implementar páginas no Timesheet App. Os principais pontos a lembrar:

1. **Sempre siga a estrutura de arquivos padrão** para features
2. **Use o sistema responsivo** com grid, breakpoints e valores predefinidos
3. **Aplique o sistema de temas** para cores, tipografia e espaçamentos
4. **Implemente todos os estados** (loading, empty, error)
5. **Use os widgets padronizados** do projeto
6. **Configure rotas com go_router** e navegação declarativa
7. **Otimize para performance** com const, keys e memoização
8. **Considere acessibilidade** em todas as interações
9. **Teste em todos os breakpoints** de 320px a 1200px+
10. **Mantenha o código organizado** e bem documentado

Consulte sempre os documentos de referência e a feature `employee` como exemplo de implementação completa.