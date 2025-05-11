# Diretrizes para o Projeto

## App de Timesheets Flutter/Firebase

Aplicativo web para gerenciar horas trabalhadas, recibos e sincronização de dados.

## IMPORTANTE: SEMPRE se basear no CLAUDE_CODE_GUIA.md

O Claude Code DEVE SEMPRE consultar e seguir as diretrizes do arquivo CLAUDE_CODE_GUIA.md antes de implementar qualquer feature ou modificação no projeto. Este guia contém as instruções específicas e padrões para implementação no app de timesheets.

## Regras Principais

1. **Código**:
   - Dart: camelCase (variáveis/métodos), PascalCase (classes)
   - Sem comentários, nomes autodescritivos
   - Widgets const quando possível
   - Riverpod para estado

2. **Arquitetura**:
   - Firebase (backend) + Hive (cache local)
   - UI → Repositórios → Serviços → Firebase
   - Código em inglês, comunicação em português

3. **UI/UX**:
   - Tema em core/theme/app_theme.dart
   - Responsivo e otimizado para mobile/PWA
   - Elementos adequados para toque


4. **Referências**:
   - Priorizar files/new_files, depois files/old_app
   - Manter estilo visual e fluxos do app antigo
   - Melhorar código mas preservar experiência familiar

## Comandos

```
flutter run -d chrome       # desenvolvimento
flutter build web           # produção
flutter test               # testes
flutter analyze            # verificar tipos
```

## Git

- feat: novas funcionalidades
- fix: correções
- refactor: refatorações
- style: mudanças visuais
- docs: documentação
- test: testes

## Prioridades

1. Performance
2. Sincronização offline
3. UI/UX responsiva

