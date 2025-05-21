/// Arquivo barril (barrel file) para botões
/// 
/// Este projeto utiliza os botões padrão do Flutter:
/// - ElevatedButton: Para ações primárias
/// - FilledButton: Para ações com destaque  
/// - OutlinedButton: Para ações secundárias
/// - TextButton: Para ações terciárias
/// - IconButton: Para ações com ícones apenas
/// - FloatingActionButton: Para ações flutuantes principais
/// 
/// Componentes customizados para casos específicos:
/// - AppActionButton: Para botões de ação em toolbars
/// - AppCompactActionButton: Para botões compactos com estilo contextual
/// 
/// Exemplos de uso com o sistema de tema:
/// 
/// ```dart
/// ElevatedButton(
///   onPressed: () {},
///   style: ElevatedButton.styleFrom(
///     backgroundColor: context.colors.primary,
///     foregroundColor: context.colors.onPrimary,
///   ),
///   child: Text('Save'),
/// )
/// 
/// AppCompactActionButton(
///   icon: Icons.clear,
///   tooltip: 'Clear filters',
///   onPressed: () {},
/// )
/// ```

export 'app_action_button.dart';
export 'compact_action_button.dart';