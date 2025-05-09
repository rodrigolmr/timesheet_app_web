# Instruções para Claude

Este arquivo contém instruções e regras para o Claude seguir ao trabalhar com este projeto.

## Sobre o Projeto

Este é um aplicativo Flutter web para gerenciamento de timesheets, que permite aos usuários:
- Registrar horas trabalhadas
- Gerenciar recibos
- Sincronizar dados com o Firebase

## Regras Gerais

1. **Dimensões para desenvolvimento**: Quando executado com `flutter run`, o app deve manter dimensões de 320x640 pixels para simular um dispositivo móvel.

2. **Estilo de código**:
   - Seguir as convenções de nomenclatura do Dart (camelCase para variáveis e métodos, PascalCase para classes)
   - Manter o código limpo e autoexplicativo
   - Não adicionar comentários no código
   - Usar nomes descritivos para funções e variáveis em vez de comentários
   - Usar `const` sempre que possível para widgets
   - Utilizar arquitetura baseada em Riverpod para gerenciamento de estado

3. **Performance**:
   - Evitar reconstruções desnecessárias de widgets
   - Otimizar consultas ao Firestore
   - Usar Cache local (Hive) para melhorar a experiência offline

4. **Banco de dados**:
   - Firebase para backend
   - Hive para armazenamento local e cache

5. **UI/UX**:
   - Seguir o tema definido em `core/theme/app_theme.dart`
   - Manter interfaces minimalistas e responsivas
   - Priorizar a usabilidade em telas pequenas

6. **Arquitetura**:
   - Nenhuma página se comunica diretamente com o Firebase
   - Todas as comunicações com o Firebase devem passar pela camada de serviços e repositórios
   - Manter a separação entre UI, lógica de negócios e acesso a dados

7. **Idioma**:
   - Todo o código do aplicativo (variáveis, funções, comentários, etc.) deve ser escrito em inglês
   - Toda a interface do usuário (textos, botões, mensagens) deve ser em inglês
   - Somente a comunicação com o desenvolvedor (você) deve ser em português (pt-BR)

8. **PWA e Otimização Mobile**:
   - O aplicativo será distribuído como PWA (Progressive Web App)
   - Deve ser otimizado para uso em smartphones
   - Garantir que todos os recursos funcionem corretamente em navegadores móveis
   - Implementar service workers para funcionalidade offline
   - Otimizar carregamento e uso de recursos para conexões móveis
   - Garantir interfaces com elementos de tamanho adequado para toque

9. **Referência de Design e Funcionalidade**:
   - Verificar prioritariamente a pasta `files/new_files` para arquivos atualizados do app
   - Se o arquivo existe em `files/new_files`, usar essa versão em vez da versão em `files/old_app`
   - Se o arquivo não existe em `files/new_files`, recorrer à pasta `files/old_app`
   - O novo app deve ser baseado no app antigo com as atualizações da pasta new_files
   - Toda a interface do novo app deve seguir o estilo visual do app antigo/atualizado
   - Manter a mesma experiência de usuário e fluxos de trabalho do app antigo
   - Melhorar aspectos técnicos e performance, mas preservar a aparência e comportamentos familiares
   - Para cada nova página ou widget a ser implementado:
     * Procurar primeiro o arquivo correspondente na pasta `files/new_files`
     * Se não existir, procurar na pasta `files/old_app`
     * Os nomes dos arquivos podem estar diferentes entre as pastas - verificar a função/propósito real do arquivo, não apenas o nome
     * Por exemplo, `custom_button.dart` e `custom_button_mini.dart` na pasta old_app podem ter sido consolidados em um único arquivo `button.dart` na pasta new_files
     * Basear o novo componente no original ou atualizado, mantendo layout, estilo e funcionamento
     * Adaptar apenas conforme necessário para a nova arquitetura e boas práticas
     * Sair deste fluxo apenas se explicitamente solicitado

## Comandos Úteis

Para executar o projeto em modo de desenvolvimento:
```
flutter run -d chrome
```

Para construir a versão de produção:
```
flutter build web
```

Para executar os testes:
```
flutter test
```

Para verificar problemas de tipo:
```
flutter analyze
```

## Estrutura do Projeto

- `/lib/core`: Classes e configurações principais
- `/lib/models`: Modelos de dados
- `/lib/repositories`: Camada de acesso a dados
- `/lib/services`: Serviços (Firebase, sincronização)
- `/lib/pages`: Páginas da aplicação

## Trabalho com Git

Ao criar commits, seguir o padrão:
- feat: Para novas funcionalidades
- fix: Para correções de bugs
- refactor: Para refatorações
- style: Para mudanças que não afetam o comportamento
- docs: Para documentação
- test: Para adição de testes

## Prioridades para Desenvolvimento

1. Otimização de performance
2. Melhorias na sincronização offline
3. UI/UX adaptativa para diferentes tamanhos de tela