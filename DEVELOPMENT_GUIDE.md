# Guia de Desenvolvimento - Timesheet App

Este documento contém as regras e diretrizes para o desenvolvimento do aplicativo Timesheet App, um sistema de registro de horas e despesas com Firebase e Flutter.

## Documentação de Referência

Antes de realizar qualquer implementação no aplicativo, é essencial consultar a seguinte documentação:

- **DATABASE_TREE.md**: Define a estrutura completa das coleções do Firestore e seus campos
- **DEVELOPMENT_GUIDE.md** (este documento): Contém as diretrizes gerais e padrões de desenvolvimento
- **RESPONSIVE_GUIDE.md**: Documenta o sistema responsivo e como implementar interfaces adaptáveis
- **RIVERPOD_GUIDE.md**: Explica o padrão de uso do Riverpod para gerenciar estado e comunicação com o Firebase
- **THEME_GUIDE.md**: Documenta o sistema de temas e como implementar corretamente os estilos visuais

Todos estes documentos devem ser mantidos atualizados à medida que o projeto evolui. Consulte-os frequentemente e siga os padrões estabelecidos para garantir consistência em todo o código.

## Visão Geral do Projeto

O Timesheet App é uma aplicação web desenvolvida em Flutter para registro e gestão de:
- Horas trabalhadas por funcionários em diferentes projetos
- Despesas corporativas realizadas com cartões da empresa
- Aprovação de registros de trabalho e despesas

A aplicação utiliza Firebase como backend, com as seguintes tecnologias:
- Firebase Authentication para autenticação de usuários
- Cloud Firestore para armazenamento de dados
- Firebase Storage para armazenamento de arquivos (recibos)

O gerenciamento de estado é feito com Riverpod, e os modelos de dados utilizam Freezed para imutabilidade.

## Estrutura do Projeto

Seguimos uma arquitetura limpa com a seguinte organização:

```
lib/
  ├── main.dart              # Ponto de entrada do aplicativo
  │
  └── src/
      ├── core/              # Componentes e utilitários fundamentais
      │   ├── config/        # Configurações da aplicação e Firebase
      │   ├── constants/     # Constantes da aplicação
      │   ├── enums/         # Enumeradores 
      │   ├── errors/        # Classes de erro
      │   ├── interfaces/    # Interfaces base
      │   ├── providers/     # Providers globais
      │   ├── repositories/  # Classes base para repositórios
      │   ├── responsive/    # Sistema de responsividade
      │   └── services/      # Serviços compartilhados (pesquisa, etc.)
      │
      └── features/          # Funcionalidades do aplicativo
          ├── auth/          # Autenticação
          ├── user/          # Gerenciamento de usuários
          ├── employee/      # Gerenciamento de funcionários
          ├── company_card/  # Gerenciamento de cartões corporativos
          ├── expense/       # Gerenciamento de despesas
          └── job_record/    # Registros de trabalho
              ├── data/      # Camada de dados
              │   ├── models/       # Modelos de dados
              │   └── repositories/ # Implementações de repositórios
              │
              ├── domain/    # Regras de negócio
              │   └── repositories/ # Interfaces de repositórios
              │
              └── presentation/ # Interface do usuário
                  ├── providers/  # Providers Riverpod
                  ├── screens/    # Telas
                  └── widgets/    # Widgets específicos da feature
```

Cada feature segue a estrutura de Clean Architecture:

1. **Camada de dados (data)**: Implementações concretas
   - **models**: Classes de modelo de dados usando Freezed
   - **repositories**: Implementações dos repositórios para acesso ao Firebase

2. **Camada de domínio (domain)**: Regras de negócio independentes de framework
   - **repositories**: Interfaces abstratas para os repositórios
   - **entities**: Entidades de domínio puro (quando necessário)

3. **Camada de apresentação (presentation)**: Interface do usuário
   - **providers**: Gerenciamento de estado com Riverpod
   - **screens**: Telas completas
   - **widgets**: Componentes reutilizáveis específicos da feature

## Padrões de Código

1. **Gerenciamento de Estado**
   - Usar Riverpod para gerenciamento de estado
   - Providers devem ser organizados por feature
   - Usar anotações `@riverpod` para geração de código
   - Consultar RIVERPOD_GUIDE.md para detalhes de implementação

2. **Firebase**
   - Abstrair o acesso ao Firebase através de repositórios
   - As classes de modelo devem ter métodos `fromFirestore()` e `toFirestore()`
   - Implementar classes no padrão freezed para imutabilidade
   - Configurar persistência offline do Firestore para funcionamento sem internet
   
   **Coleções do Firestore:**
   - `users`: Perfis de usuários do sistema
   - `employees`: Funcionários/trabalhadores
   - `company_cards`: Cartões corporativos
   - `expenses`: Recibos de despesas
   - `job_records`: Registros de trabalho
   - `job_drafts`: Rascunhos de registros de trabalho
   
   A estrutura detalhada de dados de cada coleção está definida no arquivo `DATABASE_TREE.md` na raiz do projeto.

3. **Pesquisa Local**
   - Utilizar o serviço `SearchService` para pesquisas locais em dados carregados
   - Cada feature deve implementar seus próprios providers de pesquisa
   - Seguir o padrão de providers:
     - `cached{Collection}Provider`: Mantém os dados em cache com `keepAlive: true`
     - `{entity}SearchQueryProvider`: Gerencia a consulta de pesquisa
     - `{entity}SearchFiltersProvider`: Gerencia os filtros de pesquisa
     - `search{Entity}Provider`: Implementa a lógica de pesquisa
     - `{entity}SearchResultsProvider`: Combina a consulta e filtros para resultados
   - Os arquivos de providers de pesquisa devem ser organizados em:
     - `{feature}/presentation/providers/{entity}_search_providers.dart`
     - Todos exportados via um barrel file em `search_providers.dart`

4. **Responsividade**
   - Todas as interfaces devem ser responsivas, funcionando de 320px (mobile) até desktop
   - Utilizar as classes e helpers definidos em `lib/src/core/responsive/`
   - Seguir o guia RESPONSIVE_GUIDE.md para implementações consistentes
   - Usar os métodos de extensão `context.responsive()` para valores adaptáveis
   - Testar a interface em diferentes tamanhos de tela
   
5. **Sistema de Temas**
   - Utilizar o sistema de temas centralizado definido em `lib/src/core/theme/`
   - Acessar cores, estilos de texto e dimensões via extensões de contexto
   - Seguir o guia THEME_GUIDE.md para uso correto dos temas
   - Verificar suporte para temas claro, escuro e feminino
   - Respeitar as preferências de tema do usuário definidas no Firestore

6. **Modelos de Dados**
   - Usar Freezed para classes imutáveis
   - Incluir construtor privado com `const ModelName._();` para métodos de instância
   - Implementar serialização/deserialização com json_serializable
   - Exemplo de modelo:

   ```dart
   @freezed
   class UserModel with _$UserModel {
     const UserModel._(); // Construtor privado para métodos de instância
     
     const factory UserModel({
       required String id,
       required String authUid,
       required String email,
       required String firstName,
       required String lastName,
       required String role,
       required bool isActive,
       required DateTime createdAt,
       required DateTime updatedAt,
     }) = _UserModel;

     factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

     factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
       // Implementação para converter de Firestore
     }

     Map<String, dynamic> toFirestore() {
       // Implementação para converter para Firestore
     }
   }
   ```

7. **Repositórios**
   - Estender `FirestoreRepository<T>` para repositórios de Firestore
   - Implementar métodos específicos da entidade
   - Exemplo de repositório:

   ```dart
   abstract class UserRepository {
     Future<UserModel?> getById(String id);
     Future<List<UserModel>> getAll();
     Future<UserModel?> getUserByAuthUid(String authUid);
     Stream<UserModel?> watchUserByAuthUid(String authUid);
     // Outros métodos específicos
   }

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
       // Implementação
     }

     @override
     Stream<UserModel?> watchUserByAuthUid(String authUid) {
       // Implementação
     }
   }
   ```

8. **Providers**
   - Usar anotações `@riverpod` para geração de código
   - Manter providers específicos de feature em seu próprio diretório
   - Exemplo de providers:

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

9. **Nomenclatura**
   - Classes: PascalCase
   - Variáveis e métodos: camelCase
   - Constantes: SNAKE_CASE
   - Arquivos: snake_case.dart
   - Interfaces: prefixo 'I' não é necessário, usar sufixo 'Repository', 'Service', etc.

10. **Tratamento de Erros**
   - Criar classes de erro específicas em `core/errors`
   - Usar AsyncValue para estados assíncronos (carregando, erro, dados)
   - Capturar e tratar erros nos repositórios antes de propagá-los

11. **Widgets de Input Padronizados**
   - Utilizar os widgets padronizados de input em `lib/src/core/widgets/input/`
   - Importá-los através do arquivo barril: `import 'package:timesheet_app_web/src/core/widgets/input/input.dart';`
   - Widgets disponíveis:
     - `AppTextField`: Campo de texto simples com variantes (.name, .email, .phone, .number)
     - `AppPasswordField`: Campo para senhas com botão de mostrar/esconder
     - `AppMultilineTextField`: Campo para texto com múltiplas linhas
     - `AppDropdownField`: Campo de seleção dropdown
     - `AppDatePickerField`: Campo para seleção de datas

## Fluxo de Trabalho

1. **Desenvolvimento de Features**
   - Criar models e repositórios antes de implementar a UI
   - Testar a comunicação com Firebase antes de implementar a UI
   - Interfaces devem ser responsivas para web e mobile
   - Consultar toda a documentação de referência antes de iniciar

2. **Tratamento de Estado de Autenticação**
   - Verificar autenticação antes de acessar páginas protegidas
   - Redirecionar para login quando não autenticado
   - Verificar existência de perfil do usuário no Firestore
   
   **Fluxo de Autenticação:**
   1. O usuário faz login com email/senha via Firebase Auth
   2. Após autenticação bem-sucedida, buscamos o perfil do usuário no Firestore
   3. Se o perfil existir, o usuário é redirecionado para a tela principal
   4. A tela principal verifica o papel do usuário (admin, manager, user) para mostrar as opções apropriadas
   
   **Navegação Principal:**
   - A tela principal (`HomePage`) oferece acesso a:
     - Gestão de funcionários
     - Registros de horas trabalhadas
     - Gestão de despesas
     - Administração de cartões corporativos

## Funcionalidades Principais

1. **Autenticação**
   - Login com e-mail e senha
   - Perfis de usuário com diferentes níveis de acesso

2. **Gestão de Funcionários**
   - Cadastro, edição e visualização de funcionários
   - Associação de funcionários a projetos

3. **Registro de Trabalho**
   - Registro de horas trabalhadas por funcionário
   - Possibilidade de salvar rascunhos
   - Aprovação de registros por usuários autorizados

4. **Gestão de Despesas**
   - Registro de despesas com cartões corporativos
   - Upload de recibos/comprovantes
   - Aprovação de despesas por usuários autorizados

5. **Cartões Corporativos**
   - Cadastro e gestão de cartões corporativos
   - Associação de cartões a usuários

6. **Pesquisa e Filtros**
   - Sistema de pesquisa completo em todas as coleções
   - Filtros específicos por tipo de entidade
   - Funcionamento offline

## Configuração e Dependências

O projeto utiliza as seguintes dependências principais:
- **Firebase**: firebase_core, firebase_auth, cloud_firestore
- **Gerenciamento de Estado**: flutter_riverpod, riverpod_annotation
- **Modelos**: freezed, freezed_annotation, json_serializable, json_annotation
- **Geração de código**: build_runner, riverpod_generator

Para configurar um novo ambiente de desenvolvimento:
1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Certifique-se de ter as credenciais do Firebase em `lib/firebase_options.dart` ou `lib/src/core/config/firebase_options.dart`
4. Execute `dart run build_runner build --delete-conflicting-outputs` para gerar o código necessário
5. Execute `flutter run -d chrome` para iniciar a aplicação

## Comandos Importantes

- **Gerar código**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

- **Limpar projeto**
  ```bash
  flutter clean && dart run build_runner clean
  ```

- **Compilar para web**
  ```bash
  flutter build web --release
  ```

- **Executar aplicação**
  ```bash
  flutter run -d chrome
  ```

## Regras para Commits

1. Os commits devem ser pequenos e focados em uma única alteração
2. Mensagens de commit devem ser claras e descritivas
3. Prefixos recomendados:
   - `feat:` para novas funcionalidades
   - `fix:` para correções de bugs
   - `docs:` para atualizações de documentação
   - `style:` para mudanças que não afetam o código (formatação, etc.)
   - `refactor:` para refatorações de código
   - `test:` para adição ou modificação de testes

## Convenções de Design

1. **Sistema de Temas e Cores**
   - Usar o sistema de temas centralizado definido em `core/theme/`
   - Acessar cores via extensões: `context.colors.primary`, `context.colors.background`
   - Consultar THEME_GUIDE.md para referência completa de cores e temas
   - Suportar temas claro, escuro e feminino
   - Respeitar as preferências de tema do usuário

2. **Espaçamento**
   - Usar os valores de espaçamento do sistema responsivo e de temas
   - Acessar via `context.dimensions.spacingM`, `context.padding`, etc.
   - Consultar RESPONSIVE_GUIDE.md e THEME_GUIDE.md para referência completa

3. **Tipografia**
   - Usar estilos de texto definidos no sistema de temas:
     - `context.textStyles.caption` para textos pequenos
     - `context.textStyles.body` para texto principal
     - `context.textStyles.subtitle` para subtítulos
     - `context.textStyles.title` para títulos
     - `context.textStyles.headline` para títulos principais