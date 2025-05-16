# Guia do Sistema de Temas - Timesheet App

Este documento descreve o sistema centralizado de temas do Timesheet App, detalhando sua implementação, uso e personalização.

## Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura do Sistema de Temas](#arquitetura-do-sistema-de-temas)
3. [Estrutura de Arquivos](#estrutura-de-arquivos)
4. [Paletas de Cores](#paletas-de-cores)
5. [Tipografia](#tipografia)
6. [Elementos de UI](#elementos-de-ui)
7. [Extensões de Contexto](#extensões-de-contexto)
8. [Temas Disponíveis](#temas-disponíveis)
9. [Controle de Temas por Usuário](#controle-de-temas-por-usuário)
10. [Integração com o Sistema Responsivo](#integração-com-o-sistema-responsivo)
11. [Manutenção e Extensão](#manutenção-e-extensão)
12. [Exemplos de Uso](#exemplos-de-uso)
13. [⚠️ Práticas Obrigatórias ⚠️](#práticas-obrigatórias)

## Visão Geral

O sistema de temas do Timesheet App fornece uma abordagem centralizada para gerenciar cores, tipografia e estilos visuais em toda a aplicação. Isso garante consistência visual e facilidade de manutenção, permitindo alterações globais a partir de um único ponto.

O sistema suporta a personalização baseada em usuário, permitindo que administradores definam temas específicos para diferentes usuários, com opção de bloquear alterações.

### Benefícios Principais:
- **Consistência visual** em todo o aplicativo
- **Facilidade de manutenção** através de gerenciamento centralizado
- **Suporte para múltiplos temas** (Azul, Escuro, Rosa, Verde)
- **Controle por usuário** via Firestore
- **Persistência local** para uso offline
- **Integração com o sistema responsivo**
- **Extensões intuitivas** para acesso a cores e estilos

## Arquitetura do Sistema de Temas

O sistema de temas segue uma arquitetura baseada em Riverpod, com os seguintes componentes principais:

### 1. Variantes de Tema (ThemeVariant)
Enum que define as variantes de tema disponíveis:
- `light` - Tema padrão com cor primária Azul Corporativo
- `dark` - Tema escuro adaptado para ambientes com pouca luz
- `feminine` - Tema com tons de Rosa
- `green` - Tema com tons de Verde

### 2. Dados do Tema (AppThemeData)
Classe que encapsula todos os elementos do tema:
- `AppColors` - Cores do tema
- `AppTextStyles` - Estilos de texto
- `AppDimensions` - Dimensões e espaçamentos
- `Brightness` - Brilho do tema (claro ou escuro)
- `ThemeVariant` - Variante do tema atual

### 3. Controlador de Tema (ThemeController)
Gerencia o estado atual do tema e lida com:
- Mudanças de tema
- Persistência de preferências
- Sincronização com Firestore
- Detecção de tema do sistema

### 4. Extensões de Contexto (ThemeExtension)
Fornece acesso fácil a todos os aspectos do tema através do `BuildContext`.

## ⚠️ Práticas Obrigatórias ⚠️

### Acesso ao Tema via Extensões

**IMPORTANTE**: Para garantir consistência e seguir o padrão do projeto, SEMPRE acesse os elementos do tema através das extensões de contexto e NUNCA através de importações diretas das classes.

#### Regras Específicas para Cores de Categoria

1. **Em componentes de UI e widgets**: Use SEMPRE `context.categoryColorByName("categoria")` em vez de importar o enum `CategoryType`
2. **Dentro do pacote de tema**: Pode usar `context.categoryColor(CategoryType.categoria)` já que o enum já está disponível
3. **NUNCA importe `app_colors.dart` diretamente** em componentes de UI ou widgets

#### Benefícios da Abordagem com Strings

Esta abordagem oferece várias vantagens:

1. **Desacoplamento**: Componentes não precisam conhecer detalhes de implementação do sistema de tema
2. **Facilidade de manutenção**: Adição ou modificação de categorias requer apenas alterações no pacote de tema
3. **Redução de importações**: Menos importações cruzadas entre pacotes
4. **Mensagens de erro mais claras**: Erros de digitação em strings são mais fáceis de detectar do que problemas com enums

#### Compatibilidade com Material 3 e Material You

O sistema de temas inclui propriedades getters para compatibilidade com nomes comumente usados no Material 3:

**AppTextStyles**:
- `titleLarge` → referencia para `title`
- `titleMedium` → referencia para `subtitle`
- `bodyMedium` → referencia para `body`
- `labelMedium` → referencia para `inputLabel`
- `labelSmall` → referencia para `inputFloatingLabel`
- `labelLarge` → referencia para `button`

**AppColors**:
- `onSurface` → referencia para `textPrimary`
- `onSurfaceVariant` → referencia para `textSecondary`
- `surfaceVariant` → referencia para `surfaceAccent`
- `outline` → versão mais transparente de `textSecondary`

**AppDimensions**:
- `paddingSmall` → referencia para `spacingS`
- `paddingMedium` → referencia para `spacingM`
- `borderRadiusMedium` → referencia para `borderRadiusM`

Estas propriedades existem para facilitar a migração e integração com widgets de terceiros, mas você deve preferir usar os nomes principais do sistema para manter a consistência.

#### ✅ CORRETO: Usar extensões de contexto
```dart
// Acesso correto via extensões
Widget build(BuildContext context) {
  return Container(
    color: context.colors.primary,
    padding: EdgeInsets.all(context.dimensions.spacingMedium),
    child: Text(
      'Hello World',
      style: context.textStyles.bodyMedium,
    ),
  );
}
```

#### ❌ INCORRETO: Importar e usar diretamente as classes de tema
```dart
// NUNCA FAÇA ISSO
import 'package:timesheet_app_web/src/core/theme/app_colors.dart';
import 'package:timesheet_app_web/src/core/theme/app_dimensions.dart';
import 'package:timesheet_app_web/src/core/theme/app_text_styles.dart';

Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.extension<AppColors>()!;  // ERRADO
  final dimensions = theme.extension<AppDimensions>()!;  // ERRADO
  final textStyles = theme.extension<AppTextStyles>()!;  // ERRADO
  
  return Container(
    color: colors.primary,  // ERRADO
    // ...
  );
}
```

### Benefícios das Extensões de Contexto:

1. **Código mais limpo e conciso**
2. **Acesso automatizado ao tema atual**
3. **Eliminação de cast forçado (`!`) e potenciais erros**
4. **Facilidade para testes e mock de temas**
5. **Respeito à arquitetura do projeto**

### Onde Encontrar as Extensões:

As extensões de contexto estão definidas em `lib/src/core/theme/theme_extensions.dart` e incluem:

- `context.colors` - Acesso às cores do tema atual
- `context.textStyles` - Acesso aos estilos de texto
- `context.dimensions` - Acesso às dimensões e espaçamentos
- `context.themeVariant` - Retorna a variante de tema atual
- `context.isDarkTheme` - Verifica se o tema atual é escuro
- `context.padding` - Atalho para padding padrão
- `context.horizontalPadding` - Atalho para padding horizontal
- `context.verticalPadding` - Atalho para padding vertical
- `context.responsiveColor()` e `context.responsiveTextStyle()` - Para elementos responsivos

## Estrutura de Arquivos

```
lib/
  └── src/
      └── core/
          └── theme/
              ├── theme.dart           # Arquivo de barril para exportações
              ├── theme_variant.dart   # Enum de variantes de tema
              ├── app_colors.dart      # Definição de cores para cada tema
              ├── app_text_styles.dart # Estilos de texto
              ├── app_dimensions.dart  # Dimensões e espaçamentos
              ├── app_theme_data.dart  # Classe que combina todos os elementos
              ├── theme_controller.dart # Gerenciamento de estado do tema
              ├── theme_controller.g.dart # Código gerado para o controller
              └── theme_extensions.dart # Extensões para BuildContext
```

## Paletas de Cores

O sistema de temas usa quatro paletas de cores principais:

### 1. Azul Corporativo (Light Theme)
- **Código em:** `AppColors.light()`
- **Baseado em:** Palette4CorporateAmber
- **Cor primária:** `#1565C0` - Azul principal
- **Secundária:** `#1E88E5` - Azul mais claro
- **Fundo:** `#FAFAFA` - Cinza muito claro
- **Superfície Acentuada:** `#FFF8E1` - Âmbar pálido

### 2. Tema Escuro (Dark Theme)
- **Código em:** `AppColors.dark()`
- **Cor primária:** `#0D47A1` - Azul mais escuro para dark mode
- **Secundária:** `#1976D2` - Azul médio
- **Fundo:** `#121212` - Cinza escuro
- **Superfície:** `#212121` - Cinza mais claro que o background

### 3. Tema Rosa (Feminine Theme)
- **Código em:** `AppColors.feminine()`
- **Baseado em:** Palette5PinkSoft
- **Cor primária:** `#E91E63` - Rosa principal
- **Secundária:** `#F06292` - Rosa mais claro
- **Fundo:** `#FCFAFF` - Quase branco com tom rosado
- **Superfície Acentuada:** `#FCE4EC` - Rosa muito pálido

### 4. Tema Verde (Green Theme)
- **Código em:** `AppColors.green()`
- **Baseado em:** Palette6GreenFresh
- **Cor primária:** `#00897B` - Verde teal principal
- **Secundária:** `#4DB6AC` - Verde mais claro
- **Fundo:** `#F5F9F6` - Quase branco com tom verde
- **Superfície Acentuada:** `#E0F2F1` - Verde muito pálido

### Cores de Categoria

O sistema também define cores específicas para categorias funcionais através do enum `CategoryType`:

```dart
enum CategoryType {
  timesheet,   // Registros de trabalho
  receipt,     // Recibos/despesas
  settings,    // Configurações
  add,         // Adicionar
  cancel,      // Cancelar
  navigation,  // Navegação
  user,        // Usuário
  worker,      // Trabalhador
  card,        // Cartão
  pdf,         // PDF
}
```

Exemplo de implementação das cores de categoria para o tema Azul:

```dart
categoryColors: {
  CategoryType.timesheet: const Color(0xFF0D47A1),  // Azul mais escuro
  CategoryType.receipt: const Color(0xFFFFA000),    // Âmbar
  CategoryType.settings: const Color(0xFF546E7A),   // Azul acinzentado
  CategoryType.add: const Color(0xFF388E3C),        // Verde
  CategoryType.cancel: const Color(0xFFD32F2F),     // Vermelho
  CategoryType.navigation: const Color(0xFF1565C0), // Azul principal
  CategoryType.user: const Color(0xFF0288D1),       // Azul claro
  CategoryType.worker: const Color(0xFF5D4037),     // Marrom
  CategoryType.card: const Color(0xFF7B1FA2),       // Roxo
  CategoryType.pdf: const Color(0xFFC62828),        // Vermelho escuro
},
```

### Como Acessar as Cores

As cores do tema atual podem ser acessadas através da extensão `ThemeExtension`:

```dart
// Cores principais
Container(
  color: context.colors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: context.colors.onPrimary),
  ),
)

// Cores de categoria - usando o enum CategoryType (apenas dentro do pacote de temas)
IconButton(
  icon: Icon(Icons.add),
  color: context.categoryColor(CategoryType.add),
  onPressed: () {},
)

// Cores de categoria - usando String (maneira recomendada para componentes)
IconButton(
  icon: Icon(Icons.add),
  color: context.categoryColorByName("add"),
  onPressed: () {},
)
```

### Acesso a Cores de Categoria

Para manter a consistência e evitar importações diretas de `app_colors.dart`, existem duas formas de acessar cores de categoria:

1. **Usando o método `categoryColor(CategoryType type)`** - Use APENAS dentro do pacote de tema ou quando a importação de `CategoryType` já for necessária por outros motivos.

2. **Usando o método `categoryColorByName(String? categoryName)`** - Use em todos os componentes e widgets da UI para evitar importar diretamente o enum `CategoryType`.

#### ✅ CORRETO: Usar o método por nome em componentes
```dart
// Em um botão ou outro componente UI
final buttonColor = context.categoryColorByName(categoryName);
```

#### ❌ INCORRETO: Importar CategoryType em componentes
```dart
// NUNCA FAÇA ISSO
import 'package:timesheet_app_web/src/core/theme/app_colors.dart';

// Em um componente de UI
final color = context.categoryColor(CategoryType.add);
```

As categorias de cores disponíveis como strings são:
- `"timesheet"` - Para elementos relacionados a folhas de horas
- `"receipt"` - Para elementos relacionados a recibos/despesas
- `"settings"` - Para elementos de configuração
- `"add"` - Para ações de adicionar (verde)
- `"cancel"` - Para ações de cancelar (vermelho)
- `"navigation"` - Para elementos de navegação
- `"user"` - Para elementos relacionados a usuários
- `"worker"` - Para elementos relacionados a trabalhadores
- `"card"` - Para elementos relacionados a cartões
- `"pdf"` - Para elementos relacionados a documentos PDF

## Tipografia

Os estilos de texto são definidos em `AppTextStyles` e adaptados para cada tema:

```dart
// Estilos disponíveis
final headline;    // Título grande
final title;       // Título
final subtitle;    // Subtítulo
final body;        // Texto principal
final bodyBold;    // Texto principal em negrito
final caption;     // Texto pequeno/legenda
final button;      // Texto para botões
final inputLabel;  // Rótulo para campos de entrada
final inputHint;   // Texto de dica para campos
final inputFloatingLabel; // Rótulo flutuante
final input;       // Texto dentro de campos de entrada
```

**Exemplo de uso:**
```dart
Text(
  'Title Text',
  style: context.textStyles.title,
)

Text(
  'Body text',
  style: context.textStyles.body,
)
```

## Elementos de UI

Dimensões e propriedades de elementos de UI são definidos em `AppDimensions`:

```dart
// Espaçamentos
final spacingXS;  // Extra pequeno (4.0)
final spacingS;   // Pequeno (8.0)
final spacingM;   // Médio (16.0)
final spacingL;   // Grande (24.0)
final spacingXL;  // Extra grande (32.0)
final spacingXXL; // Duplo extra grande (48.0)

// Elevações
final elevationS; // Pequena (2.0)
final elevationM; // Média (4.0)
final elevationL; // Grande (8.0)

// Arredondamento de bordas
final borderRadiusXS; // Extra pequeno (4.0)
final borderRadiusS;  // Pequeno (8.0)
final borderRadiusM;  // Médio (12.0)
final borderRadiusL;  // Grande (16.0)
final borderRadiusXL; // Extra grande (24.0)

// Paddings pré-definidos
final padding;            // Padding em todos os lados (spacingM)
final horizontalPadding;  // Padding horizontal (spacingM)
final verticalPadding;    // Padding vertical (spacingM)
```

**Exemplo de uso:**
```dart
// Espaçamento
SizedBox(height: context.dimensions.spacingM)

// Padding
Padding(
  padding: context.padding,
  child: widget,
)

// Bordas arredondadas
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
  ),
  child: widget,
)
```

## Extensões de Contexto

As extensões simplificam o acesso a todos os aspectos do tema:

### ThemeExtension

```dart
extension ThemeExtension on BuildContext {
  // Acesso ao tema completo
  AppThemeData get theme => ...;
  
  // Atalhos para partes do tema
  AppColors get colors => theme.colors;
  AppTextStyles get textStyles => theme.textStyles;
  AppDimensions get dimensions => theme.dimensions;
  
  // Informações sobre o tema atual
  ThemeVariant get themeVariant => theme.variant;
  Brightness get themeBrightness => theme.brightness;
  bool get isDarkTheme => theme.brightness == Brightness.dark;
  
  // Atalho para cores de categoria
  Color categoryColor(CategoryType type) => colors.categoryColors[type]!;
  
  // Atalhos para espaçamentos
  double get spacing => dimensions.spacingM;
  EdgeInsets get padding => dimensions.padding;
  EdgeInsets get horizontalPadding => dimensions.horizontalPadding;
  EdgeInsets get verticalPadding => dimensions.verticalPadding;
}
```

### ThemeControllerExtension

```dart
extension ThemeControllerExtension on WidgetRef {
  // Altera o tema para a variante especificada
  void setTheme(ThemeVariant variant) {
    read(themeControllerProvider.notifier).setTheme(variant);
  }
  
  // Alterna entre os temas claro e escuro
  void toggleLightDark() {
    read(themeControllerProvider.notifier).toggleLightDark();
  }
}
```

### ResponsiveThemeExtension

```dart
extension ResponsiveThemeExtension on BuildContext {
  // Cores responsivas
  Color responsiveColor({
    required Color xs,
    Color? sm,
    Color? md,
    Color? lg,
    Color? xl,
  }) {
    return responsive<Color>(xs: xs, sm: sm, md: md, lg: lg, xl: xl);
  }
  
  // Estilos de texto responsivos
  TextStyle responsiveTextStyle({
    required TextStyle xs,
    TextStyle? sm,
    TextStyle? md,
    TextStyle? lg,
    TextStyle? xl,
  }) {
    return responsive<TextStyle>(xs: xs, sm: sm, md: md, lg: lg, xl: xl);
  }
}
```

## Temas Disponíveis

O sistema atualmente suporta quatro variantes de tema:

### 1. Azul (Light)
- **Variante**: `ThemeVariant.light`
- **Uso**: Tema padrão corporativo
- **Cor Primária**: Azul (`#1565C0`)
- **Características**: 
  - Fundo claro e limpo
  - Contraste adequado para uso diurno
  - Acentos em âmbar

### 2. Escuro (Dark)
- **Variante**: `ThemeVariant.dark`
- **Uso**: Modo noturno e ambientes com pouca luz
- **Cor Primária**: Azul escuro (`#0D47A1`)
- **Características**:
  - Fundo escuro (`#121212`)
  - Redução de fadiga visual
  - Cores mais saturadas para elementos UI

### 3. Rosa (Feminine)
- **Variante**: `ThemeVariant.feminine`
- **Uso**: Alternativa ao tema azul padrão
- **Cor Primária**: Rosa (`#E91E63`)
- **Características**:
  - Cores vibrantes
  - Fundo claro com tom rosado
  - Acentos em tons pastel

### 4. Verde (Green)
- **Variante**: `ThemeVariant.green`
- **Uso**: Alternativa com tom mais calmo e natural
- **Cor Primária**: Verde teal (`#00897B`)
- **Características**:
  - Cores frescas e naturais
  - Fundo com tons suaves de verde
  - Acentos em âmbar

## Controle de Temas por Usuário

O sistema permite que administradores controlem o tema de cada usuário através do Firestore:

### Modelo de Usuário

O `UserModel` inclui campos para controle de tema:

```dart
@freezed
class UserModel with _$UserModel {
  // ...outros campos

  // Campo que armazena a preferência de tema
  // ("light", "dark", "feminine", "green")
  String? themePreference;
  
  // Indica se o usuário pode mudar o tema (quando true, o tema é forçado)
  bool? forcedTheme;
  
  // Método para converter string para ThemeVariant
  ThemeVariant? get themeVariant {
    if (themePreference == null) return null;
    
    switch (themePreference) {
      case 'light': return ThemeVariant.light;
      case 'dark': return ThemeVariant.dark;
      case 'feminine': return ThemeVariant.feminine;
      case 'green': return ThemeVariant.green;
      default: return null;
    }
  }
  
  // Verifica se o usuário pode alterar o tema
  bool get canChangeTheme => forcedTheme != true;
}
```

### Lógica de Priorização de Tema

O sistema segue esta ordem de prioridade:

1. **Tema definido no Firestore**: Se o usuário tiver um tema definido em seu perfil, esse tema será usado
2. **Tema salvo localmente**: Se não houver tema no Firestore, o sistema busca preferências locais
3. **Tema do sistema**: Se nenhuma preferência for encontrada, usa o tema do sistema operacional (dark mode)
4. **Tema padrão (light)**: Como último recurso

### Providers para Controle de Tema

```dart
// Provider que fornece o tema preferido do usuário atual
@riverpod
Future<ThemeVariant?> userPreferredTheme(UserPreferredThemeRef ref)

// Provider que verifica se o usuário pode mudar o tema
@riverpod
Future<bool> canUserChangeTheme(CanUserChangeThemeRef ref)

// Provider para atualizar o tema do usuário atual
@riverpod
Future<void> updateCurrentUserTheme(
  UpdateCurrentUserThemeRef ref,
  String themePreference,
)
```

### Fluxo de Implementação do Controlador de Tema

O controlador principal é implementado como um provider keepAlive:

```dart
@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  AppThemeData build() {
    _setupThemeListener();
    return AppThemeData.light(); // Tema inicial padrão
  }
  
  // Configura listener para mudanças de tema do usuário
  void _setupThemeListener() { ... }
  
  // Carrega tema salvo localmente
  Future<void> _loadLocalTheme() async { ... }
  
  // Altera o tema (verificando permissões)
  void setTheme(ThemeVariant variant) async { ... }
  
  // Alterna entre temas claro e escuro
  void toggleLightDark() async { ... }
  
  // Salva tema localmente
  Future<void> _saveLocalThemePreference(ThemeVariant variant) async { ... }
  
  // Salva tema no Firestore
  Future<void> _saveUserThemePreference(ThemeVariant variant) async { ... }
}
```

## Integração com o Sistema Responsivo

O sistema de temas é totalmente integrado com o sistema responsivo do aplicativo, permitindo ajustes de cores e estilos baseados no tamanho da tela:

```dart
extension ResponsiveThemeExtension on BuildContext {
  // Cores responsivas
  Color responsiveColor({
    required Color xs,  // Mobile pequeno
    Color? sm,          // Mobile grande
    Color? md,          // Tablet
    Color? lg,          // Desktop pequeno
    Color? xl,          // Desktop grande
  }) {
    return responsive<Color>(xs: xs, sm: sm, md: md, lg: lg, xl: xl);
  }
}
```

Exemplo de uso:
```dart
// Cor de texto que se adapta ao tamanho da tela
Text(
  'Responsive Text',
  style: TextStyle(
    color: context.responsiveColor(
      xs: Colors.blue,    // Mobile: azul
      md: Colors.purple,  // Tablet: roxo
      lg: Colors.green,   // Desktop: verde
    ),
  ),
)
```

## Manutenção e Extensão

### Adicionando um Novo Tema

Para adicionar um novo tema ao sistema:

1. **Atualizar o enum ThemeVariant**:
```dart
enum ThemeVariant {
  light,
  dark,
  feminine,
  green,
  newTheme, // Nova variante
}
```

2. **Criar uma nova factory em AppColors**:
```dart
factory AppColors.newTheme() {
  return AppColors(
    // Definir todas as cores necessárias
    primary: const Color(0xFF...),
    // ...
  );
}
```

3. **Atualizar o método fromThemeVariant em AppColors**:
```dart
factory AppColors.fromThemeVariant(ThemeVariant variant) {
  switch (variant) {
    // ...
    case ThemeVariant.newTheme:
      return AppColors.newTheme();
  }
}
```

4. **Criar novos estilos de texto se necessário**:
```dart
factory AppTextStyles.newTheme() { ... }
```

5. **Atualizar AppThemeData**:
```dart
factory AppThemeData.newTheme() { ... }

factory AppThemeData.fromVariant(ThemeVariant variant) {
  switch (variant) {
    // ...
    case ThemeVariant.newTheme:
      return AppThemeData.newTheme();
  }
}
```

6. **Atualizar UserModel.themeVariant**:
```dart
ThemeVariant? get themeVariant {
  // ...
  case 'newTheme': return ThemeVariant.newTheme;
  // ...
}
```

7. **Atualizar a tela de seleção de temas**:
```dart
_buildThemeOption(
  // ...
  title: "Novo Tema",
  // ...
  variant: ThemeVariant.newTheme,
)
```

### Adicionando Novas Propriedades a um Tema

Para adicionar novas propriedades ao sistema de temas:

1. **Atualizar a classe AppColors, AppTextStyles ou AppDimensions**
2. **Atualizar cada factory de tema para incluir a nova propriedade**
3. **Se necessário, adicionar extensões para acessar a nova propriedade**

### Regras de Manutenção

1. **Consistência**: Mantenha consistência entre as variantes de tema
2. **Acessibilidade**: Garanta contraste adequado para todos os temas
3. **Documentação**: Documente novas cores e propriedades
4. **Testes**: Teste as alterações em diferentes tamanhos de tela

## Exemplos de Uso

### Botões

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: context.colors.primary,
    foregroundColor: context.colors.onPrimary,
    elevation: context.dimensions.elevationM,
    padding: EdgeInsets.all(context.dimensions.spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
    ),
  ),
  child: Text('Login', style: context.textStyles.button),
  onPressed: () {},
)
```

### Campos de Entrada

```dart
TextField(
  decoration: InputDecoration(
    labelText: "Email",
    hintText: "Enter your email",
    filled: true,
    fillColor: context.colors.surfaceAccent,
    labelStyle: context.textStyles.inputLabel,
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.dimensions.spacingM,
      vertical: context.dimensions.spacingS,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
      borderSide: BorderSide(color: context.colors.primary),
    ),
  ),
  style: context.textStyles.input,
)
```

### Containers e Cards

```dart
Container(
  margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
  padding: context.padding,
  decoration: BoxDecoration(
    color: context.colors.surface,
    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
    border: Border.all(color: context.colors.primary.withOpacity(0.3)),
    boxShadow: [
      BoxShadow(
        color: context.colors.textPrimary.withOpacity(0.1),
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  ),
  child: Column(
    children: [
      Text("Title", style: context.textStyles.title),
      SizedBox(height: context.dimensions.spacingS),
      Text("Content", style: context.textStyles.body),
    ],
  ),
)
```

### Acesso ao Tema no Código

```dart
// Em widgets do Riverpod (ConsumerWidget)
final currentTheme = ref.watch(themeControllerProvider);
final bool isDark = currentTheme.brightness == Brightness.dark;

// Alterando o tema
ref.read(themeControllerProvider.notifier).setTheme(ThemeVariant.dark);

// Alternando entre temas claro e escuro
ref.read(themeControllerProvider.notifier).toggleLightDark();

// Também é possível usar a extensão
ref.setTheme(ThemeVariant.feminine);

// Verificando se o usuário pode alterar o tema
final canChange = await ref.read(canUserChangeThemeProvider.future);

// Persistindo a preferência do usuário no Firestore
await ref.read(updateCurrentUserThemeProvider('dark').future);
```

### Uso com MediaQuery

```dart
// Criar estilo responsivo
final responsiveTextStyle = context.responsiveTextStyle(
  xs: context.textStyles.body.copyWith(fontSize: 14),
  md: context.textStyles.body.copyWith(fontSize: 16),
  lg: context.textStyles.body.copyWith(fontSize: 18),
);

// Aplicar estilo responsivo
Text(
  'Texto responsivo',
  style: responsiveTextStyle,
)
```

Lembre-se de consultar este guia ao implementar novos componentes para garantir consistência visual em toda a aplicação e utilizar corretamente o sistema de controle de temas por usuário.