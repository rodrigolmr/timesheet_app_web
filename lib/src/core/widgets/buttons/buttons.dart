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
/// IconButton(
///   icon: Icon(Icons.edit),
///   onPressed: () {},
///   color: context.colors.primary,
/// )
/// ```