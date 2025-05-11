# Guia Rápido para Claude Code - App Timesheet

Este guia serve como referência para o Claude Code ao implementar ou modificar o aplicativo de timesheets.

## 1. Princípios Fundamentais

- **Idioma**:
  - Código e variáveis: em **inglês**
  - Interface do usuário: em **inglês**
  - Comunicação com usuário do Claude Code: em **português**

- **Arquitetura em camadas**:
  ```
  UI → Providers → Repositories → Services → Firebase/Hive
  ```
  - **NUNCA** acessar Firebase diretamente da UI
  - Sempre seguir o fluxo completo de camadas

- **Estilo e tema**:
  - Usar `AppTheme` para cores, espaçamentos e estilos
  - Nunca usar valores hardcoded (consultar `lib/core/theme/app_theme.dart`)

## 2. Widgets e Componentes

- **Páginas**: Usar `BaseLayout` + `ResponsiveContainer` + `SingleChildScrollView`
- **Formulários**: Usar `InputField`, `InputFieldMultiline`, `InputFieldDropdown`, `DatePickerField`
- **Botões**: Usar `AppButton` com os tipos predefinidos (nunca criar botões customizados)
- **Feedback**: Usar `ToastMessage` para mensagens e `LoadingButton` para operações assíncronas

## 3. Gerenciamento de Estado

- Usar Riverpod para todo o gerenciamento de estado
- Seguir padrão: Estado (Data Class) + Notifier + Provider
- Sempre implementar `copyWith()` nas classes de estado
- Tratar erros nas camadas apropriadas

## 4. Responsividade

- Usar `ResponsiveSizing(context)` para obter valores adaptáveis
- Aplicar `ResponsiveLayout` para layouts diferentes por breakpoint
- Testar em diferentes tamanhos de tela (320px até desktop)
- Garantir que elementos de UI tenham tamanho adequado para toque em mobile

## 5. Persistência e Sincronização

- Modelos com Hive para cache local (adapters em `lib/core/hive/adapters/`)
- Firebase Firestore para persistência remota
- Implementar sempre funcionalidade offline-first
- Gerenciar sincronização conforme conectividade

## 6. Padrões de Código

- Controllers SEMPRE dispostos no `dispose()`
- Widgets grandes divididos em métodos (`_buildX`)
- Tratamento de erros em operações assíncronas (try/catch)
- Verificação de `mounted` após operações assíncronas

## 7. Checklist de Qualidade

Antes de finalizar qualquer implementação, verificar:

- [ ] Interface em inglês (textos visíveis)
- [ ] Arquitetura seguida corretamente (UI → Repos → Services)
- [ ] Responsividade testada em diferentes tamanhos
- [ ] Estilo visual consistente com AppTheme
- [ ] Estado gerenciado com Riverpod
- [ ] Recursos liberados corretamente (dispose)
- [ ] Validação de entradas e feedback visual
- [ ] Tratamento de erros implementado

## Exemplos de Referência

- Estrutura de página: consultar `lib/pages/timesheet_list_page.dart`
- Modelos e adapters: consultar `lib/models/timesheet.dart` e `lib/core/hive/adapters/timesheet_adapter.dart`
- Widgets reutilizáveis: consultar `lib/widgets/`
- Providers e repositórios: consultar `lib/providers/` e `lib/repositories/`

## Recursos Adicionais

- Ver código-fonte existente para padrões
- Priorizar referências em files/new_files, depois files/old_app
- Manter experiência de usuário consistente com app original