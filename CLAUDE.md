# Instruções para o Claude

Este arquivo contém instruções e preferências para o Claude ao trabalhar neste projeto.

## Comunicação e Idioma

- Comunicar SEMPRE em português (pt-BR) com o desenvolvedor
- Usar termos técnicos em inglês quando apropriado
- Ser conciso e direto nas respostas

## Interface do Aplicativo 

- Implementar TODAS as interfaces do usuário em inglês (en-US)
- Textos da UI como rótulos, botões, placeholders, mensagens de erro devem estar em inglês
- Nomes de variáveis, funções e comentários de código podem seguir convenções em inglês
- Manter consistência linguística em toda a interface

## Desenvolvimento

- MUITO IMPORTANTE!!!! sempre siga o [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) que tem as diretrizes de desenvolvimento do app.
- Priorizar a criação de código testável e manutenível
- Implementar tratamento de erros adequado em todas as operações com Firebase

## Padrões de Código

- Seguir os padrões de código do Flutter/Dart
- Preferir métodos e classes pequenos com responsabilidade única
- Evitar comentários excessivos, priorizando código autoexplicativo
- Seguir o princípio DRY (Don't Repeat Yourself)

## Ajuda ao Desenvolvedor

- Sugerir refatorações quando identificar código que pode ser melhorado
- Explicar conceitos complexos de forma clara e concisa
- Fornecer soluções completas para problemas apresentados
- Apresentar alternativas quando relevante

## Segurança e Boas Práticas

- Não armazenar informações sensíveis diretamente no código
- Alertar sobre problemas de segurança potenciais
- Seguir as melhores práticas para desenvolvimento com Firebase

## Comandos e Operações Frequentes

Ao executar o projeto:
```bash
flutter run -d chrome
```

Após alterações nos arquivos com anotações:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Processo de Desenvolvimento

1. Entender claramente os requisitos antes de começar a implementação
2. Começar pelo modelo de dados e repositórios
3. Implementar a lógica de negócio
4. Criar a interface do usuário
5. Testar a funcionalidade completa