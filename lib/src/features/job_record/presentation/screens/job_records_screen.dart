import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_card.dart';

// Classe para representar uma semana com registros
class WeekGroup {
  final String weekId;
  final DateTime startDate; // Sexta-feira
  final DateTime endDate;   // Quinta-feira
  final List<JobRecordModel> records;
  
  WeekGroup(this.weekId, this.startDate, this.records)
      : endDate = startDate.add(const Duration(days: 6));
      
  String get weekRange {
    final dateFormat = DateFormat('MMM d');
    return '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
  }
  
  String get weekTitle {
    final now = DateTime.now();
    final thisWeekId = _getWeekId(now);
    final lastWeekId = _getWeekId(now.subtract(const Duration(days: 7)));
    
    if (weekId == thisWeekId) {
      return 'This Week';
    } else if (weekId == lastWeekId) {
      return 'Last Week';
    } else {
      // Formato mais compacto para economia de espaço
      return 'Week ${startDate.day}-${endDate.day} ${DateFormat('MMM').format(startDate)}';
    }
  }
}

// Identificador único para semana de sexta a quinta
String _getWeekId(DateTime date) {
  // Primeiro, determinamos a sexta-feira da semana atual
  DateTime fridayOfWeek;
  
  // Dia da semana: 1=seg, 2=ter, 3=qua, 4=qui, 5=sex, 6=sab, 7=dom
  final dayOfWeek = date.weekday;
  
  if (dayOfWeek == 5) { // É sexta-feira
    fridayOfWeek = date; // A própria data já é sexta
  } else if (dayOfWeek < 5) { // É segunda a quinta
    // Voltar para a sexta anterior
    fridayOfWeek = date.subtract(Duration(days: dayOfWeek + 2));
  } else { // É sábado ou domingo
    // Voltar para a sexta mais recente
    fridayOfWeek = date.subtract(Duration(days: dayOfWeek - 5));
  }
  
  // Criamos um ID único baseado no ano e dia do ano da sexta-feira
  final dayOfYear = _getDayOfYear(fridayOfWeek);
  final weekNumber = ((dayOfYear - 1) / 7).floor() + 1;
  
  // Formatar como AAAASS (ano+semana)
  return '${fridayOfWeek.year}${weekNumber.toString().padLeft(2, '0')}';
}

// Auxiliar: calcula o dia do ano (1-366)
int _getDayOfYear(DateTime date) {
  final startOfYear = DateTime(date.year, 1, 1);
  return date.difference(startOfYear).inDays + 1;
}

// Obter data inicial (sexta-feira) da semana com base no ID da semana
DateTime _getWeekStartDateFromId(String weekId) {
  // Extrair ano e número da semana do ID
  final year = int.parse(weekId.substring(0, 4));
  final weekNumber = int.parse(weekId.substring(4));
  
  // Primeiro dia do ano
  final firstDayOfYear = DateTime(year, 1, 1);
  
  // Encontrar a primeira sexta-feira do ano
  final firstDayWeekday = firstDayOfYear.weekday;
  final daysUntilFirstFriday = (5 - firstDayWeekday + 7) % 7; // 5 = sexta-feira
  final firstFriday = firstDayOfYear.add(Duration(days: daysUntilFirstFriday));
  
  // Adicionar as semanas restantes (n-1 semanas)
  return firstFriday.add(Duration(days: (weekNumber - 1) * 7));
}

class JobRecordsScreen extends ConsumerStatefulWidget {
  static const routePath = '/job-records';
  static const routeName = 'job-records';

  const JobRecordsScreen({super.key});

  @override
  ConsumerState<JobRecordsScreen> createState() => _JobRecordsScreenState();
}

class _JobRecordsScreenState extends ConsumerState<JobRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppHeader(
        title: 'Job Records',
        actionIcon: Icons.add,
        onActionPressed: () => context.push('/job-record-create'),
      ),
      body: Column(
        children: [
          // Records list
          Expanded(
            child: _buildRecordsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/job-record-create'),
        backgroundColor: colors.primary,
        // Tamanho responsivo para telas pequenas
        mini: context.responsive<bool>(
          xs: true, // Mini para telas pequenas
          sm: true,
          md: false, // Tamanho normal para telas maiores
        ),
        child: const Icon(Icons.add),
      ),
      // Adiciona padding no FAB para evitar sobreposição
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Agrupa registros por semana (sexta a quinta)
  List<WeekGroup> _groupRecordsByWeek(List<JobRecordModel> records) {
    // Mapa para agrupar registros por ID de semana
    final Map<String, List<JobRecordModel>> groupedByWeekId = {};
    
    // Agrupar registros por ID de semana
    for (final record in records) {
      final weekId = _getWeekId(record.date);
      
      if (!groupedByWeekId.containsKey(weekId)) {
        groupedByWeekId[weekId] = [];
      }
      
      groupedByWeekId[weekId]!.add(record);
    }
    
    // Converter para lista de WeekGroup
    final List<WeekGroup> result = [];
    for (final weekId in groupedByWeekId.keys) {
      // Obter data inicial da semana a partir do ID
      final startDate = _getWeekStartDateFromId(weekId);
      
      // Ordenar registros dentro da semana por data (mais recente primeiro)
      final weekRecords = groupedByWeekId[weekId]!;
      weekRecords.sort((a, b) => b.date.compareTo(a.date));
      
      // Adicionar à lista de resultado
      result.add(WeekGroup(weekId, startDate, weekRecords));
    }
    
    // Ordenar semanas (mais recente primeiro)
    result.sort((a, b) => b.startDate.compareTo(a.startDate));
    
    return result;
  }

  Widget _buildRecordsList() {
    final AsyncValue<List<JobRecordModel>> recordsAsync;
    
    // Use jobRecordsStreamProvider para obter os registros em tempo real
    recordsAsync = ref.watch(jobRecordsStreamProvider);

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return _buildEmptyState('No records found');
        }
        
        // Agrupar registros por semana usando a nova abordagem
        final weekGroups = _groupRecordsByWeek(records);

        return ResponsiveContainer(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: context.responsive<double>(xs: 4, sm: 6, md: 8),
              horizontal: context.responsive<double>(xs: 0, sm: 2, md: 6),
            ),
            itemCount: weekGroups.length,
            itemBuilder: (context, weekIndex) {
              final weekGroup = weekGroups[weekIndex];
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cabeçalho minimalista (apenas uma linha com separador)
                  _buildMinimalHeader(weekGroup),
                  
                  // Registros desta semana - com espaçamento mínimo
                  ...weekGroup.records.map((record) => Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: JobRecordCard(record: record),
                  )),
                  
                  // Espaçador entre semanas
                  SizedBox(height: context.responsive<double>(xs: 8, sm: 10, md: 12)),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error loading records: $error',
          style: context.textStyles.body.copyWith(
            color: context.colors.error,
          ),
        ),
      ),
    );
  }
  
  // Cabeçalho minimalista (só linha de texto + separador)
  Widget _buildMinimalHeader(WeekGroup weekGroup) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: 6,
        top: context.responsive<double>(xs: 6, sm: 8, md: 10),
        left: context.responsive<double>(xs: 1, sm: 2, md: 6),
        right: context.responsive<double>(xs: 1, sm: 2, md: 6),
      ),
      child: Row(
        children: [
          // Título
          Text(
            weekGroup.weekTitle,
            style: textStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
            ),
          ),
          
          // Separador
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: colors.primary.withOpacity(0.2),
            ),
          ),
          
          // Range de datas
          Text(
            weekGroup.weekRange,
            style: textStyles.caption.copyWith(
              color: colors.textSecondary,
              fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String message) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Tornando o estado vazio responsivo
    final iconSize = context.responsive<double>(
      xs: 60, // Menor para mobile
      sm: 70,
      md: 80,
    );
    
    // Tamanho de texto responsivo
    final titleFontSize = context.responsive<double>(
      xs: 16, // Menor para mobile
      sm: 18,
      md: 20,
    );
    
    // Padding do botão responsivo
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: context.responsive<double>(xs: 16, sm: 20, md: 24),
      vertical: context.responsive<double>(xs: 8, sm: 10, md: 12),
    );
    
    // Espaçamento vertical responsivo
    final spacing1 = context.responsive<double>(xs: 12, sm: 14, md: 16);
    final spacing2 = context.responsive<double>(xs: 16, sm: 20, md: 24);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: iconSize,
            color: colors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: spacing1),
          Text(
            message,
            style: textStyles.title.copyWith(
              color: colors.textSecondary,
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing2),
          ElevatedButton.icon(
            onPressed: () => context.push('/job-record-create'),
            icon: const Icon(Icons.add),
            label: const Text('Create New Job Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: buttonPadding,
            ),
          ),
        ],
      ),
    );
  }
}