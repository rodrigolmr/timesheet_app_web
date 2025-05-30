import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/theme/app_colors.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';

class JobRecordCard extends ConsumerWidget {
  final JobRecordModel record;
  final VoidCallback? onTap;
  final bool showWeekdayIndicator;

  const JobRecordCard({
    super.key,
    required this.record,
    this.onTap,
    this.showWeekdayIndicator = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = record.date;
    final day = DateFormat('d').format(date);
    final month = DateFormat('MMM').format(date);
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Get weekday color
    final weekdayColor = _getWeekdayColor(date.weekday, colors);
    
    // Watch selection state
    final selectionState = ref.watch(jobRecordSelectionProvider);
    final isSelected = selectionState.isSelected(record.id);
    
    // Make the card width responsive to the screen size
    final cardWidth = context.responsive<double>(
      xs: 300, // Otimizado para tela de 320px (deixando apenas 10px de cada lado)
      sm: 340,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    // Ajusta altura do card para telas menores
    final cardHeight = context.responsive<double>(
      xs: 40, // Mais compacto para mobile pequeno
      sm: 42,
      md: 45,
    );
    
    // Ajusta largura da seção de data
    final dateWidth = context.responsive<double>(
      xs: 34, // Mais estreito para telas pequenas
      sm: 38,
      md: 40,
    );
    
    // Ajusta largura da seção do nome do criador
    final creatorWidth = context.responsive<double>(
      xs: 62, // Ligeiramente mais larga para acomodar duas linhas
      sm: 68,
      md: 76,
    );
    
    // Tamanho do texto para o dia
    final dayFontSize = context.responsive<double>(
      xs: 18, // Menor para telas pequenas
      sm: 20,
      md: 22,
    );
    
    // Tamanho do texto para o mês
    final monthFontSize = context.responsive<double>(
      xs: 11, // Menor para telas pequenas
      sm: 12,
      md: 13,
    );
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Center(
        child: SizedBox(
          width: cardWidth,
          child: GestureDetector(
            onTap: () {
              if (selectionState.isSelectionMode) {
                ref.read(jobRecordSelectionProvider.notifier).toggleSelection(record.id);
              } else {
                if (onTap != null) {
                  onTap!();
                } else {
                  context.push('/job-records/${record.id}');
                }
              }
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary.withOpacity(0.1) : colors.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  // Weekday indicator line (only for managers/admins)
                  if (showWeekdayIndicator)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: weekdayColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  
                  // Conteúdo principal com clipping
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: EdgeInsets.only(left: showWeekdayIndicator ? 4 : 0),
                      child: Row(
                children: [
                  // Date section - mais compacto
                  Container(
                    width: dateWidth,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.2), // Cor primária com opacidade 0.2
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(showWeekdayIndicator ? 0 : 3),
                        bottomLeft: Radius.circular(showWeekdayIndicator ? 0 : 3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Day - ajustado para ser mais compacto
                        SizedBox(
                          height: cardHeight * 0.55,
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: dayFontSize,
                                fontWeight: FontWeight.bold,
                                color: colors.error,
                              ),
                            ),
                          ),
                        ),
                        // Month - ajustado para ser mais compacto
                        SizedBox(
                          height: cardHeight * 0.35,
                          child: Center(
                            child: Text(
                              month,
                              style: TextStyle(
                                fontSize: monthFontSize,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  
                  // Job name
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final canViewAllAsync = ref.watch(canViewAllJobRecordsProvider);
                        final canViewAll = canViewAllAsync.valueOrNull ?? false;
                        
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.surfaceAccent.withOpacity(0.85), // Preenchimento igual aos inputs
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive<double>(xs: 4, sm: 6, md: 8),
                          ),
                          child: Text(
                            record.jobName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: textStyles.body.copyWith(
                              fontSize: context.responsive<double>(xs: 13, sm: 14, md: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Creator and hours info - mais compacto
                  Consumer(
                    builder: (context, ref, _) {
                      final canViewAllAsync = ref.watch(canViewAllJobRecordsProvider);
                      final canViewAll = canViewAllAsync.valueOrNull ?? false;
                      
                      if (!canViewAll) {
                        // Para usuários regulares, não mostra informações do criador
                        return const SizedBox.shrink();
                      }
                      
                      return Row(
                        children: [
                          // Vertical divider - apenas quando há conteúdo do criador
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: colors.background,
                          ),
                          Container(
                            width: creatorWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.surfaceAccent.withOpacity(0.85), // Preenchimento igual aos inputs
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: FutureBuilder<({String firstName, String lastName})>(
                          future: _getCreatorNames(ref, record.userId),
                          builder: (context, snapshot) {
                            final names = snapshot.data ?? (firstName: 'Loading', lastName: '...');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Primeiro nome
                                Text(
                                  names.firstName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: textStyles.caption.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                                  ),
                                ),
                                // Pequeno espaçamento
                                SizedBox(height: 1),
                                // Sobrenome
                                Text(
                                  names.lastName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: textStyles.caption.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                                    height: 0.9, // Reduz o espaçamento de linha
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  // Checkbox para modo de seleção
                  if (selectionState.isSelectionMode)
                    Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: colors.surfaceAccent.withOpacity(0.85),
                      ),
                      child: Center(
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            ref.read(jobRecordSelectionProvider.notifier).toggleSelection(record.id);
                          },
                          activeColor: colors.primary,
                          side: BorderSide(
                            color: colors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
                      ),
                    ),
                  ),
                  // Borda aplicada por cima
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? colors.primary : colors.secondary,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Cache para armazenar nomes de usuários já consultados
  static final Map<String, ({String firstName, String lastName})> _nameCache = {};
    
  Future<({String firstName, String lastName})> _getCreatorNames(WidgetRef ref, String userId) async {
    if (userId.isEmpty) {
      return (firstName: 'Admin', lastName: '');
    }
    
    // Se já temos o nome em cache, retorna imediatamente
    if (_nameCache.containsKey(userId)) {
      return _nameCache[userId]!;
    }
    
    // Primeiro, tenta obter diretamente por ID (forma mais rápida)
    try {
      final user = await ref.read(userRepositoryProvider).getById(userId);
      if (user != null) {
        final names = (firstName: user.firstName, lastName: user.lastName);
        _nameCache[userId] = names; // Armazena em cache
        return names;
      }
    } catch (e) {
      // Ignora o erro e tenta o próximo método
    }
    
    // Tenta obter a lista completa de usuários
    try {
      final users = await ref.read(usersProvider.future);
      for (final user in users) {
        // Compara tanto o ID quanto o authUid
        if (user.id == userId || user.authUid == userId) {
          final names = (firstName: user.firstName, lastName: user.lastName);
          _nameCache[userId] = names; // Armazena em cache
          return names;
        }
      }
    } catch (e) {
      // Ignora o erro
    }
    
    // Define um valor padrão para o cache
    final defaultNames = (firstName: 'User', lastName: '');
    _nameCache[userId] = defaultNames;
    return defaultNames;
  }
  
  Color _getWeekdayColor(int weekday, AppColors colors) {
    // 1 = Monday, 7 = Sunday
    switch (weekday) {
      case 1: // Monday
        return colors.primary;
      case 2: // Tuesday
        return colors.success;
      case 3: // Wednesday
        return colors.warning;
      case 4: // Thursday
        return colors.info;
      case 5: // Friday
        return colors.secondary;
      case 6: // Saturday
        return colors.error;
      case 7: // Sunday
        return colors.error.withOpacity(0.7);
      default:
        return colors.primary;
    }
  }
}