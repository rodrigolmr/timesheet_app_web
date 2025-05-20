import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

class JobRecordCard extends ConsumerWidget {
  final JobRecordModel record;
  final VoidCallback? onTap;

  const JobRecordCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = record.date;
    final day = DateFormat('d').format(date);
    final month = DateFormat('MMM').format(date);
    
    // Make the row width responsive to the screen size
    final rowWidth = context.responsive<double>(
      xs: 280,
      sm: 320,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: SizedBox(
          width: rowWidth,
          child: GestureDetector(
            onTap: onTap ?? () => context.push('/job-records/${record.id}'),
            child: Container(
              width: rowWidth,
              height: 45,
              decoration: BoxDecoration(
                color: context.colors.surface.withOpacity(0.8),
                border: Border.all(color: context.colors.primary, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  // Date section
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Day
                        SizedBox(
                          height: 25,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.colors.error,
                              ),
                            ),
                          ),
                        ),
                        // Month
                        SizedBox(
                          height: 16,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              month,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Job name
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        record.jobName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: context.textStyles.body,
                      ),
                    ),
                  ),
                  
                  // Vertical divider
                  Container(
                    width: 2, 
                    height: double.infinity, 
                    color: context.colors.background,
                  ),
                  
                  // Creator and hours info
                  Container(
                    width: 72,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FutureBuilder<String>(
                      future: _getCreatorName(ref, record.userId),
                      builder: (context, snapshot) {
                        final creatorName = snapshot.data ?? 'Loading...';
                        return Center(
                          child: Text(
                            creatorName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: context.textStyles.caption.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      },
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
  static final Map<String, String> _nameCache = {};
    
  Future<String> _getCreatorName(WidgetRef ref, String userId) async {
    if (userId.isEmpty) {
      return 'Admin';
    }
    
    // Se já temos o nome em cache, retorna imediatamente
    if (_nameCache.containsKey(userId)) {
      return _nameCache[userId]!;
    }
    
    // Primeiro, tenta obter diretamente por ID (forma mais rápida)
    try {
      final user = await ref.read(userRepositoryProvider).getById(userId);
      if (user != null) {
        final name = '${user.firstName} ${user.lastName}';
        _nameCache[userId] = name; // Armazena em cache
        return name;
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
          final name = '${user.firstName} ${user.lastName}';
          _nameCache[userId] = name; // Armazena em cache
          return name;
        }
      }
    } catch (e) {
      // Ignora o erro
    }
    
    // Define um valor padrão para o cache
    _nameCache[userId] = 'User';
    return 'User';
  }
}