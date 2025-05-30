# Teste de Login com Enter

## Problema Identificado

Os componentes de input (`AppTextField` e `AppPasswordField`) não estavam repassando o callback `onSubmitted` para o componente base `AppInputFieldBase`, e este não estava configurando o `onFieldSubmitted` no `TextField` interno.

## Correções Implementadas

### 1. AppInputFieldBase
- Adicionada propriedade `onSubmitted` do tipo `ValueChanged<String>?`
- Configurado o `TextField` interno para usar `onSubmitted: onSubmitted`

### 2. AppTextField
- Corrigido para repassar `onSubmitted` ao `AppInputFieldBase`

### 3. AppPasswordField  
- Corrigido para repassar `widget.onSubmitted` ao `AppInputFieldBase`

## Como Testar

1. Acesse a tela de login
2. Digite um email válido no campo de email
3. Pressione Enter - deve focar no campo de senha ou submeter o formulário
4. Digite uma senha no campo de senha
5. Pressione Enter - deve submeter o formulário e tentar fazer login

## Arquivos Modificados

- `/lib/src/core/widgets/input/app_input_field_base.dart`
- `/lib/src/core/widgets/input/app_text_field.dart`
- `/lib/src/core/widgets/input/app_password_field.dart`