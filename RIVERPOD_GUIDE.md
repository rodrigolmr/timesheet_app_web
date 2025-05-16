# Guia de Implementação do Riverpod

Este documento fornece uma visão detalhada de como o Riverpod é implementado neste projeto para gerenciar o estado e a comunicação com o Firebase. O guia é destinado a desenvolvedores que precisam entender e estender o sistema atual.

## Índice

1. [Introdução ao Riverpod](#introdução-ao-riverpod)
2. [Configuração do Firebase](#configuração-do-firebase)
3. [Padrão de Repositório](#padrão-de-repositório)
   - [Repositório Base](#repositório-base)
   - [Repositório Firestore](#repositório-firestore)
   - [Repositórios Específicos](#repositórios-específicos)
4. [Gerenciamento de Estado com Riverpod](#gerenciamento-de-estado-com-riverpod)
   - [Providers Simples](#providers-simples)
   - [Providers Notifier](#providers-notifier)
   - [AsyncValue e Tratamento de Estados](#asyncvalue-e-tratamento-de-estados)
5. [Autenticação](#autenticação)
   - [AuthStateProvider](#authstateprovider)
   - [UserProfileProvider](#userprofileProvider)
6. [Sistema de Pesquisa Local](#sistema-de-pesquisa-local)
   - [SearchService](#searchservice)
   - [Providers de Pesquisa](#providers-de-pesquisa)
   - [Filtros e Ordenação](#filtros-e-ordenação)
7. [Persistência Offline](#persistência-offline)
8. [Melhores Práticas](#melhores-práticas)

## Introdução ao Riverpod

O Riverpod é uma biblioteca de gerenciamento de estado para Flutter que oferece recursos avançados como tipagem forte, imutabilidade, lazy-loading e testabilidade. Este projeto utiliza a abordagem moderna do `riverpod_annotation`, que permite gerar código boilerplate com anotações.

### Dependências Essenciais

- `flutter_riverpod`: A biblioteca principal
- `riverpod_annotation`: Para anotações que geram código automático
- `riverpod_generator`: Gera código com base nas anotações

## Configuração do Firebase

O projeto utiliza Firebase como backend com configuração para persistência offline.

### Providers do Firebase

```dart
/// Provider que fornece a instância do FirebaseFirestore
/// configurada para persistência offline
@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) {
  // Configurando persistência offline
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  return FirebaseFirestore.instance;
}

/// Provider que fornece a instância do FirebaseAuth
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}
```

Observe que o provider do `firestore` usa `keepAlive: true` para garantir que a instância permaneça ativa durante todo o ciclo de vida da aplicação, mantendo a persistência offline.

## Padrão de Repositório

O projeto implementa um padrão de repositório em três camadas:

### Repositório Base

Uma interface genérica que define as operações básicas para qualquer repositório:

```dart
abstract class BaseRepository<T> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<String> create(T entity);
  Future<void> update(String id, T entity);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
  Stream<T?> watchById(String id);
}
```

### Repositório Firestore

Uma implementação abstrata do `BaseRepository` específica para o Firestore:

```dart
abstract class FirestoreRepository<T> implements BaseRepository<T> {
  final FirebaseFirestore _firestore;
  final String _collectionPath;

  FirestoreRepository({
    required String collectionPath,
    FirebaseFirestore? firestore,
  })  : _collectionPath = collectionPath,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Métodos para converter entre Firestore e objetos de modelo
  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);
  Map<String, dynamic> toFirestore(T entity);

  // Implementações de métodos de BaseRepository
  // ...

  // Métodos auxiliares para consultas
  Future<List<T>> query(Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>> collection) queryBuilder) async {
    final query = queryBuilder(collection);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map(fromFirestore).toList();
  }

  Stream<List<T>> watchQuery(Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>> collection) queryBuilder) {
    final query = queryBuilder(collection);
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(fromFirestore).toList(),
        );
  }
}
```

### Repositórios Específicos

Para cada entidade, criamos uma interface e uma implementação específicas:

```dart
// Interface
abstract class UserRepository {
  Future<UserModel?> getById(String id);
  Future<List<UserModel>> getAll();
  // ...métodos específicos
  Future<UserModel?> getUserByAuthUid(String authUid);
  Stream<UserModel?> watchUserByAuthUid(String authUid);
}

// Implementação Firestore
class FirestoreUserRepository extends FirestoreRepository<UserModel> implements UserRepository {
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

  @override
  Future<UserModel?> getUserByAuthUid(String authUid) async {
    final users = await query((collection) => 
      collection.where('auth_uid', isEqualTo: authUid).limit(1)
    );
    return users.isNotEmpty ? users.first : null;
  }

  @override
  Stream<UserModel?> watchUserByAuthUid(String authUid) {
    return watchQuery((collection) => 
      collection.where('auth_uid', isEqualTo: authUid).limit(1)
    ).map((users) => users.isNotEmpty ? users.first : null);
  }
}
```

## Gerenciamento de Estado com Riverpod

O projeto utiliza diferentes tipos de providers do Riverpod para gerenciar o estado.

### Providers Simples

Providers simples são usados para fornecer instâncias únicas ou dados derivados:

```dart
/// Provider que fornece o repositório de usuários
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os usuários
@riverpod
Future<List<UserModel>> users(UsersRef ref) {
  return ref.watch(userRepositoryProvider).getAll();
}

/// Provider para observar todos os usuários em tempo real
@riverpod
Stream<List<UserModel>> usersStream(UsersStreamRef ref) {
  return ref.watch(userRepositoryProvider).watchAll();
}
```

### Providers Notifier

Para estados que podem mudar ao longo do tempo:

```dart
/// Provider para o estado da consulta de pesquisa
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de usuários
@riverpod
class UserSearchFilters extends _$UserSearchFilters {
  @override
  ({String? role, bool? isActive, UserSortOption sortOption}) build() {
    return (
      role: null,
      isActive: null,
      sortOption: UserSortOption.nameAsc,
    );
  }

  void updateRole(String? role) {
    state = (
      role: role,
      isActive: state.isActive,
      sortOption: state.sortOption,
    );
  }

  // ...outros métodos
}
```

### AsyncValue e Tratamento de Estados

A classe `AsyncValue` do Riverpod é usada para representar estados assíncronos:

```dart
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<User?> build() {
    // Observa o stream de mudanças no estado de autenticação
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) => state = AsyncData(user),
        error: (error, stackTrace) => state = AsyncError(error, stackTrace),
        loading: () => state = const AsyncLoading(),
      );
    });
    
    // Retorna o estado inicial com o usuário atual
    final currentUser = ref.watch(currentUserProvider);
    return currentUser != null ? AsyncData(currentUser) : const AsyncData(null);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // ...outros métodos
}
```

Na UI, o AsyncValue é consumido usando o método `when`:

```dart
ref.watch(authStateProvider).when(
  data: (user) => user != null ? HomePage() : LoginScreen(),
  loading: () => LoadingScreen(),
  error: (e, st) => ErrorScreen(error: e),
);
```

## Autenticação

O sistema de autenticação combina Firebase Auth com Firestore para perfis de usuário.

### AuthStateProvider

Gerencia o estado de autenticação e operações relacionadas:

```dart
/// Provider para gerenciar o estado de carregamento da autenticação
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<User?> build() {
    // Lógica de inicialização
    // ...
  }

  Future<void> signIn(String email, String password) async {
    // Implementação de login
    // ...
  }

  Future<void> signOut() async {
    // Implementação de logout
    // ...
  }
}
```

### UserProfileProvider

Conecta o usuário autenticado ao seu perfil no Firestore:

```dart
/// Provider para obter o usuário atual autenticado
@riverpod
Future<UserModel?> currentUserProfile(CurrentUserProfileRef ref) async {
  // Observe as mudanças de autenticação diretamente
  final authStateChanges = ref.watch(authStateChangesProvider);
  
  return authStateChanges.when(
    data: (authUser) async {
      if (authUser == null) return null;
      
      // Busca o perfil do usuário no Firestore
      return await ref.read(userRepositoryProvider).getUserByAuthUid(authUser.uid);
    },
    loading: () => null,
    error: (error, stackTrace) => null,
  );
}

/// Provider para observar o perfil do usuário atual em tempo real
@riverpod
Stream<UserModel?> currentUserProfileStream(CurrentUserProfileStreamRef ref) {
  // Similar ao acima, mas retorna um stream
  // ...
}
```

## Sistema de Pesquisa Local

O projeto implementa um sistema de pesquisa local para funcionar offline.

### SearchService

Um serviço genérico para pesquisas em coleções em memória:

```dart
class SearchService {
  /// Pesquisa itens em uma coleção com base em uma consulta
  List<T> search<T>({
    required List<T> items,
    required String query,
    required List<String?> Function(T item) searchFields,
    List<bool Function(T item)>? filters,
    int Function(T a, T b)? sortBy,
  }) {
    // Implementação da pesquisa
    // ...
  }
  
  /// Funções auxiliares para ordenação
  int sortByDate<T>(T a, T b, DateTime? Function(T item) dateExtractor, {bool descending = true}) {
    // Implementação
    // ...
  }
  
  int sortByString<T>(T a, T b, String? Function(T item) stringExtractor, {bool descending = false}) {
    // Implementação
    // ...
  }
}

/// Provider global para o serviço de pesquisa
@riverpod
SearchService searchService(SearchServiceRef ref) {
  return SearchService();
}
```

### Providers de Pesquisa

Para cada entidade, implementamos um conjunto de providers de pesquisa seguindo este padrão:

```dart
/// Provider para armazenar todos os usuários em cache
@Riverpod(keepAlive: true)
Stream<List<UserModel>> cachedUsers(CachedUsersRef ref) {
  // Usamos o stream existente com a persistência do Firestore
  return ref.watch(usersStreamProvider);
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  // Implementação
  // ...
}

/// Provider para o estado dos filtros de pesquisa
@riverpod
class UserSearchFilters extends _$UserSearchFilters {
  // Implementação
  // ...
}

/// Provider para pesquisar usuários
@riverpod
List<UserModel> searchUsers(
  SearchUsersRef ref, {
  required String query,
  String? role,
  bool? isActive,
  UserSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final usersAsyncValue = ref.watch(cachedUsersProvider);
  
  return usersAsyncValue.when(
    data: (users) {
      // Configuração de filtros, ordenação e execução da pesquisa
      // ...
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider que combina a consulta e os filtros para resultados de pesquisa
@riverpod
List<UserModel> userSearchResults(UserSearchResultsRef ref) {
  final query = ref.watch(userSearchQueryProvider);
  final filters = ref.watch(userSearchFiltersProvider);
  
  return ref.watch(searchUsersProvider(
    query: query,
    role: filters.role,
    isActive: filters.isActive,
    sortOption: filters.sortOption,
  ));
}
```

### Filtros e Ordenação

O sistema suporta filtragem e ordenação flexíveis:

```dart
// Construção dinâmica de filtros
final List<bool Function(UserModel)> filters = [];
      
if (role != null) {
  filters.add((user) => user.role == role);
}

if (isActive != null) {
  filters.add((user) => user.isActive == isActive);
}

// Opções de ordenação
int Function(UserModel, UserModel)? sortBy;

switch (sortOption ?? UserSortOption.nameAsc) {
  case UserSortOption.nameAsc:
    sortBy = (a, b) => searchService.sortByString(a, b, (user) => '${user.firstName} ${user.lastName}');
  case UserSortOption.nameDesc:
    sortBy = (a, b) => searchService.sortByString(a, b, (user) => '${user.firstName} ${user.lastName}', descending: true);
  case UserSortOption.dateCreatedDesc:
    sortBy = (a, b) => searchService.sortByDate(a, b, (user) => user.createdAt);
  case UserSortOption.dateCreatedAsc:
    sortBy = (a, b) => searchService.sortByDate(a, b, (user) => user.createdAt, descending: false);
}
```

## Persistência Offline

O projeto implementa persistência offline para funcionar sem conexão à internet.

### Configuração do Firestore

```dart
FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### Providers com Cache

Para manter dados em memória mesmo quando não estão em uso, usamos `keepAlive: true`:

```dart
@Riverpod(keepAlive: true)
Stream<List<UserModel>> cachedUsers(CachedUsersRef ref) {
  return ref.watch(usersStreamProvider);
}
```

## Melhores Práticas

1. **Separação de Camadas**
   - Mantenha os dados e a lógica de negócios separados da UI
   - Use providers para injetar dependências em vez de instâncias diretas

2. **Tratamento de Estado Assíncrono**
   - Sempre use `AsyncValue` para dados que vêm do Firestore
   - Trate adequadamente estados de carregamento e erro na UI

3. **Imutabilidade e Classes Freezed**
   - Use `freezed` para modelos de dados imutáveis
   - Adicione métodos de conversão para Firestore

4. **Persistência Offline**
   - Configure o Firestore para persistência offline
   - Use providers `keepAlive` para dados que precisam persistir em memória

5. **Pesquisa Local**
   - Implemente o sistema de pesquisa genérico
   - Mantenha dados em cache para pesquisa quando offline

6. **Autenticação Robusta**
   - Separe autenticação (Firebase Auth) da gestão de perfil (Firestore)
   - Use streams para reagir a mudanças no estado de autenticação

7. **Eficiência de Consultas**
   - Evite consultas desnecessárias ao Firestore
   - Use `watchQuery` para reatividade em consultas filtradas

8. **Legibilidade**
   - Documente adequadamente os providers e suas funções
   - Use nomes descritivos para providers e métodos

Implementando estas práticas e padrões, seu aplicativo terá um gerenciamento de estado eficiente e trabalhará bem mesmo sem conexão à internet.