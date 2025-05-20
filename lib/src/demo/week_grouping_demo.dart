import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

// Classe para representar a semana com a data de início e fim
class WeekRange {
  final DateTime start;
  final DateTime end;
  final List<JobRecordModel> records;
  
  WeekRange({
    required this.start,
    required this.end,
    required this.records,
  });
  
  // Formata o intervalo de datas
  String get formatRange {
    final formatter = DateFormat('MMM d');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
  
  // Retorna uma descrição amigável da semana
  String get title {
    final now = DateTime.now();
    final thisWeekStart = _getWeekStart(now);
    final lastWeekStart = _getWeekStart(now.subtract(const Duration(days: 7)));
    
    if (start.isAtSameMomentAs(thisWeekStart)) {
      return 'This Week';
    } else if (start.isAtSameMomentAs(lastWeekStart)) {
      return 'Last Week';
    } else {
      return 'Week of ${DateFormat('MMM d').format(start)}';
    }
  }
  
  // Retorna o início da semana (sexta-feira) para uma data
  static DateTime _getWeekStart(DateTime date) {
    final dayOfWeek = date.weekday;
    int daysToSubtract;
    
    if (dayOfWeek == 5) { // Sexta-feira
      daysToSubtract = 0;
    } else if (dayOfWeek < 5) { // Segunda a quinta - volta para a sexta anterior
      daysToSubtract = dayOfWeek + 2;
    } else { // Sábado e domingo - volta para a sexta mais recente
      daysToSubtract = dayOfWeek - 5;
    }
    
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }
}

/// Página de demonstração com várias opções de visualização de agrupamento por semana
class WeekGroupingDemo extends ConsumerStatefulWidget {
  const WeekGroupingDemo({super.key});

  @override
  ConsumerState<WeekGroupingDemo> createState() => _WeekGroupingDemoState();
}

class _WeekGroupingDemoState extends ConsumerState<WeekGroupingDemo> {
  int _selectedViewOption = 0;
  
  // Lista de opções de visualização
  final List<String> _viewOptions = [
    'Vertical Bar',
    'Compact Header',
    'Minimal',
    'Floating Indicator',
    'Timeline View',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week Grouping Demo'),
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
      ),
      body: Column(
        children: [
          // Seletor de visualização
          Container(
            color: context.colors.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _viewOptions.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_viewOptions[index]),
                      selected: _selectedViewOption == index,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedViewOption = index;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Container para exibir a largura da tela (útil para teste de tamanhos)
          Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              return Container(
                color: context.colors.background,
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                child: Text(
                  'Screen width: ${screenWidth.toInt()}px',
                  style: context.textStyles.caption,
                ),
              );
            },
          ),
          
          // Conteúdo principal
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
    );
  }
  
  // Constrói a visualização selecionada
  Widget _buildSelectedView() {
    switch (_selectedViewOption) {
      case 0:
        return _buildVerticalBarView();
      case 1:
        return _buildCompactHeaderView();
      case 2:
        return _buildMinimalView();
      case 3:
        return _buildFloatingIndicatorView();
      case 4:
        return _buildTimelineView();
      default:
        return _buildVerticalBarView();
    }
  }
  
  // Dados mockados - gera registros fictícios para demonstração
  List<WeekRange> _getMockWeekRanges() {
    // Data atual
    final now = DateTime.now();
    
    // Criar 3 semanas
    final List<WeekRange> weeks = [];
    
    // Esta semana
    final thisWeekStart = _getStartOfWeek(now);
    final thisWeekEnd = thisWeekStart.add(const Duration(days: 6));
    
    // Semana passada
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
    
    // Semana anterior
    final twoWeeksAgoStart = lastWeekStart.subtract(const Duration(days: 7));
    final twoWeeksAgoEnd = twoWeeksAgoStart.add(const Duration(days: 6));
    
    // Gerar registros para esta semana
    weeks.add(WeekRange(
      start: thisWeekStart,
      end: thisWeekEnd,
      records: _generateMockRecords(thisWeekStart, 4),
    ));
    
    // Gerar registros para a semana passada
    weeks.add(WeekRange(
      start: lastWeekStart,
      end: lastWeekEnd,
      records: _generateMockRecords(lastWeekStart, 6),
    ));
    
    // Gerar registros para duas semanas atrás
    weeks.add(WeekRange(
      start: twoWeeksAgoStart,
      end: twoWeeksAgoEnd,
      records: _generateMockRecords(twoWeeksAgoStart, 3),
    ));
    
    return weeks;
  }
  
  // Gera registros fictícios para uma semana
  List<JobRecordModel> _generateMockRecords(DateTime weekStart, int count) {
    final records = <JobRecordModel>[];
    
    // Gerar registros para dias aleatórios da semana
    for (int i = 0; i < count; i++) {
      final day = weekStart.add(Duration(days: i % 7));
      
      records.add(JobRecordModel(
        id: 'job-${weekStart.millisecondsSinceEpoch}-$i',
        userId: 'user-$i',
        jobName: 'Job #${i + 1} - ${_getRandomJobName()}',
        date: day,
        territorialManager: 'Manager ${i % 3 + 1}',
        jobSize: '${(i % 3 + 1) * 100} sqft',
        material: _getRandomMaterial(),
        jobDescription: 'Description for job ${i + 1}',
        foreman: 'Foreman ${i % 4 + 1}',
        vehicle: 'Vehicle ${i % 5 + 1}',
        employees: [],
        createdAt: DateTime.now().subtract(Duration(days: 10 - i)),
        updatedAt: DateTime.now().subtract(Duration(days: 10 - i)),
      ));
    }
    
    return records;
  }
  
  // Nomes de trabalhos aleatórios para demonstração
  String _getRandomJobName() {
    final names = [
      'Highway Repair',
      'Bridge Construction',
      'Residential Building',
      'Commercial Office',
      'Road Maintenance',
      'Pipeline Installation',
      'Park Renovation',
    ];
    
    return names[DateTime.now().microsecond % names.length];
  }
  
  // Materiais aleatórios para demonstração
  String _getRandomMaterial() {
    final materials = [
      'Concrete',
      'Asphalt',
      'Steel',
      'Wood',
      'Brick',
      'Stone',
    ];
    
    return materials[DateTime.now().microsecond % materials.length];
  }
  
  // Calcula o início da semana (sexta-feira) para uma data
  DateTime _getStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    int daysToSubtract;
    
    if (dayOfWeek == 5) { // Sexta-feira
      daysToSubtract = 0;
    } else if (dayOfWeek < 5) { // Segunda a quinta - volta para a sexta anterior
      daysToSubtract = dayOfWeek + 2;
    } else { // Sábado e domingo - volta para a sexta mais recente
      daysToSubtract = dayOfWeek - 5;
    }
    
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }
  
  //
  // OPÇÕES DE VISUALIZAÇÃO
  //

  // OPÇÃO 1: Visualização com barra vertical
  Widget _buildVerticalBarView() {
    final weeks = _getMockWeekRanges();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.responsive<double>(xs: 8, sm: 12, md: 16),
        horizontal: context.responsive<double>(xs: 2, sm: 4, md: 6),
      ),
      itemCount: weeks.length,
      itemBuilder: (context, weekIndex) {
        final week = weeks[weekIndex];
        
        // Determinar a margem superior - menor para a primeira semana
        final topMargin = (weekIndex == 0) ? 0.0 : context.responsive<double>(xs: 12, sm: 16, md: 20);
        
        return Padding(
          padding: EdgeInsets.only(top: topMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho com barra vertical
              _buildVerticalBarHeader(week),
              // Pequeno espaço entre o cabeçalho e os cards
              SizedBox(height: context.responsive<double>(xs: 4, sm: 6, md: 8)),
              // Registros desta semana
              ...week.records.map((record) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: _buildCompactRecordCard(record),
              )),
            ],
          ),
        );
      },
    );
  }
  
  // Cabeçalho com barra vertical à esquerda
  Widget _buildVerticalBarHeader(WeekRange week) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Tamanho de fontes responsivo
    final titleFontSize = context.responsive<double>(
      xs: 13, // Reduzido para mobile pequeno
      sm: 14,
      md: 15,
    );
    
    final subtitleFontSize = context.responsive<double>(
      xs: 11, // Reduzido para mobile pequeno
      sm: 12,
      md: 13,
    );
    
    // Cores para a barra vertical
    Color barColor = colors.primary;
    if (week.title.contains('This Week')) {
      barColor = colors.success; // Esta semana em verde
    } else if (week.title.contains('Last Week')) {
      barColor = colors.primary; // Semana passada com a cor primária
    }
    
    return Stack(
      children: [
        // Barra vertical indicador de semana 
        Positioned(
          left: 0, 
          top: 0, 
          bottom: 0,
          child: Container(
            width: context.responsive<double>(xs: 3, sm: 4, md: 5),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(3)),
            ),
          ),
        ),
        
        // Conteúdo principal com padding mínimo
        Container(
          margin: EdgeInsets.only(
            left: context.responsive<double>(xs: 3, sm: 4, md: 5),
          ),
          padding: EdgeInsets.only(
            left: context.responsive<double>(xs: 6, sm: 8, md: 10),
            right: context.responsive<double>(xs: 6, sm: 8, md: 10),
            top: context.responsive<double>(xs: 4, sm: 6, md: 8),
            bottom: context.responsive<double>(xs: 4, sm: 6, md: 8),
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Informações da semana
              Expanded(
                child: Row(
                  children: [
                    // Data destacada da semana (dia/mês)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dia - Destacado
                        Text(
                          week.start.day.toString(),
                          style: TextStyle(
                            fontSize: context.responsive<double>(xs: 16, sm: 18, md: 20),
                            fontWeight: FontWeight.bold,
                            color: barColor,
                          ),
                        ),
                        // Mês - Abreviado
                        Text(
                          DateFormat('MMM').format(week.start).toUpperCase(),
                          style: TextStyle(
                            fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(width: context.responsive<double>(xs: 8, sm: 10, md: 12)),
                    
                    // Textos da semana (título e range)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Nome da semana com espaçamento otimizado
                          Text(
                            week.title,
                            style: textStyles.subtitle.copyWith(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                              height: 1.1, // Reduz espaçamento vertical
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2), // Espaçamento mínimo
                          // Range de datas mais compacto
                          Text(
                            week.formatRange,
                            style: textStyles.caption.copyWith(
                              fontSize: subtitleFontSize,
                              color: colors.textSecondary,
                              height: 1.1, // Reduz espaçamento vertical
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contador de registros mais compacto
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsive<double>(xs: 5, sm: 7, md: 8),
                  vertical: context.responsive<double>(xs: 2, sm: 3, md: 4),
                ),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: barColor.withOpacity(0.2)),
                ),
                child: Text(
                  '${week.records.length}',
                  style: textStyles.caption.copyWith(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: barColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // OPÇÃO 2: Visualização com cabeçalho compacto
  Widget _buildCompactHeaderView() {
    final weeks = _getMockWeekRanges();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.responsive<double>(xs: 6, sm: 8, md: 10),
        horizontal: context.responsive<double>(xs: 2, sm: 4, md: 6),
      ),
      itemCount: weeks.length,
      itemBuilder: (context, weekIndex) {
        final week = weeks[weekIndex];
        
        // Determinar a margem superior - menor para a primeira semana
        final topMargin = (weekIndex == 0) ? 0.0 : context.responsive<double>(xs: 8, sm: 10, md: 12);
        
        return Padding(
          padding: EdgeInsets.only(top: topMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho compacto (pill shape)
              _buildCompactHeader(week),
              
              // Registros desta semana - com espaçamento reduzido
              ...week.records.map((record) => Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: _buildCompactRecordCard(record),
              )),
            ],
          ),
        );
      },
    );
  }
  
  // Cabeçalho compacto em formato de pílula 
  Widget _buildCompactHeader(WeekRange week) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Cor do cabeçalho baseada na semana
    Color headerColor = colors.primary;
    if (week.title.contains('This Week')) {
      headerColor = colors.success;
    } else if (week.title.contains('Last Week')) {
      headerColor = colors.primary;
    }
    
    return Container(
      height: context.responsive<double>(xs: 24, sm: 28, md: 32),
      margin: EdgeInsets.only(
        bottom: context.responsive<double>(xs: 3, sm: 4, md: 6),
        left: context.responsive<double>(xs: 0, sm: 0, md: 4),
        right: context.responsive<double>(xs: 0, sm: 0, md: 4),
      ),
      decoration: BoxDecoration(
        color: headerColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: headerColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Círculo com número de registros
          Container(
            width: context.responsive<double>(xs: 24, sm: 28, md: 32),
            height: context.responsive<double>(xs: 24, sm: 28, md: 32),
            decoration: BoxDecoration(
              color: headerColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${week.records.length}',
                style: textStyles.subtitle.copyWith(
                  color: Colors.white,
                  fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Espaço
          const SizedBox(width: 8),
          
          // Título da semana
          Text(
            week.title,
            style: textStyles.subtitle.copyWith(
              color: headerColor,
              fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // Espaço flexível
          const Spacer(),
          
          // Range de datas
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              week.formatRange,
              style: textStyles.caption.copyWith(
                color: colors.textSecondary,
                fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // OPÇÃO 3: Visualização minimalista
  Widget _buildMinimalView() {
    final weeks = _getMockWeekRanges();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.responsive<double>(xs: 4, sm: 6, md: 8),
        horizontal: context.responsive<double>(xs: 2, sm: 4, md: 6),
      ),
      itemCount: weeks.length,
      itemBuilder: (context, weekIndex) {
        final week = weeks[weekIndex];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cabeçalho minimalista (apenas uma linha com separador)
            _buildMinimalHeader(week),
            
            // Registros desta semana - com espaçamento mínimo
            ...week.records.map((record) => Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: _buildCompactRecordCard(record),
            )),
            
            // Espaçador entre semanas
            SizedBox(height: context.responsive<double>(xs: 8, sm: 10, md: 12)),
          ],
        );
      },
    );
  }
  
  // Cabeçalho minimalista (só linha de texto + separador)
  Widget _buildMinimalHeader(WeekRange week) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: 6,
        top: context.responsive<double>(xs: 6, sm: 8, md: 10),
        left: context.responsive<double>(xs: 2, sm: 4, md: 6),
        right: context.responsive<double>(xs: 2, sm: 4, md: 6),
      ),
      child: Row(
        children: [
          // Título
          Text(
            week.title,
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
            week.formatRange,
            style: textStyles.caption.copyWith(
              color: colors.textSecondary,
              fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  // OPÇÃO 4: Visualização com indicador flutuante no canto
  Widget _buildFloatingIndicatorView() {
    final weeks = _getMockWeekRanges();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.responsive<double>(xs: 6, sm: 8, md: 10),
        horizontal: context.responsive<double>(xs: 2, sm: 4, md: 6),
      ),
      itemCount: weeks.length,
      itemBuilder: (context, weekIndex) {
        final week = weeks[weekIndex];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              // Fundo de contêiner para os cards
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: context.colors.surface.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: context.colors.background,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Espaço para acomodar o indicador flutuante
                      const SizedBox(height: 14),
                      
                      // Cards
                      ...week.records.map((record) => Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, left: 4, right: 4),
                        child: _buildCompactRecordCard(record),
                      )),
                      
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              
              // Indicador flutuante da semana
              Positioned(
                left: 20,
                top: 0,
                child: _buildFloatingWeekIndicator(week),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Indicador flutuante da semana
  Widget _buildFloatingWeekIndicator(WeekRange week) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Determinar cor do indicador
    Color badgeColor = colors.primary;
    if (week.title.contains('This Week')) {
      badgeColor = colors.success;
    } else if (week.title.contains('Last Week')) {
      badgeColor = colors.secondary;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(xs: 8, sm: 10, md: 12),
        vertical: context.responsive<double>(xs: 4, sm: 5, md: 6),
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        week.title,
        style: textStyles.body.copyWith(
          color: Colors.white,
          fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // OPÇÃO 5: Visualização em timeline
  Widget _buildTimelineView() {
    final weeks = _getMockWeekRanges();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.responsive<double>(xs: 6, sm: 8, md: 10),
        horizontal: context.responsive<double>(xs: 0, sm: 1, md: 2),
      ),
      itemCount: weeks.length,
      itemBuilder: (context, weekIndex) {
        final week = weeks[weekIndex];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da semana na timeline
            _buildTimelineHeader(week),
            
            // Linha da timeline com registros
            Stack(
              children: [
                // Linha vertical da timeline
                Positioned(
                  left: context.responsive<double>(xs: 15, sm: 17, md: 19),
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: context.colors.primary.withOpacity(0.2),
                  ),
                ),
                
                // Os registros com marcadores na timeline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: week.records.map((record) {
                    return _buildTimelineItem(record);
                  }).toList(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  // Cabeçalho da semana no estilo timeline
  Widget _buildTimelineHeader(WeekRange week) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return Padding(
      padding: EdgeInsets.only(
        left: context.responsive<double>(xs: 10, sm: 12, md: 14),
        top: context.responsive<double>(xs: 12, sm: 16, md: 20),
        bottom: context.responsive<double>(xs: 4, sm: 6, md: 8),
        right: context.responsive<double>(xs: 10, sm: 12, md: 14),
      ),
      child: Row(
        children: [
          // Círculo do marcador da timeline
          Container(
            width: context.responsive<double>(xs: 10, sm: 12, md: 14),
            height: context.responsive<double>(xs: 10, sm: 12, md: 14),
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Informações da semana
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da semana
                Text(
                  week.title,
                  style: textStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsive<double>(xs: 13, sm: 14, md: 15),
                  ),
                ),
                
                // Range de datas
                Text(
                  week.formatRange,
                  style: textStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
                  ),
                ),
              ],
            ),
          ),
          
          // Badge com contagem de registros
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive<double>(xs: 6, sm: 8, md: 10),
              vertical: context.responsive<double>(xs: 2, sm: 3, md: 4),
            ),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${week.records.length} items',
              style: textStyles.caption.copyWith(
                fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Item de registro na timeline
  Widget _buildTimelineItem(JobRecordModel record) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Formatar a data
    final day = DateFormat('d').format(record.date);
    final month = DateFormat('MMM').format(record.date);
    final weekday = DateFormat('E').format(record.date);
    
    return Padding(
      padding: EdgeInsets.only(
        left: context.responsive<double>(xs: 6, sm: 8, md: 10),
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Marcador da timeline
          SizedBox(
            width: context.responsive<double>(xs: 18, sm: 20, md: 22),
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Data + Job info
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: colors.background,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Data e dia da semana
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: textStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsive<double>(xs: 13, sm: 14, md: 15),
                          ),
                        ),
                        Text(
                          month,
                          style: textStyles.caption.copyWith(
                            fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Job info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nome do job
                        Text(
                          record.jobName,
                          style: textStyles.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        // Dia da semana
                        Text(
                          weekday,
                          style: textStyles.caption.copyWith(
                            color: colors.textSecondary,
                            fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Card de registro compacto
  Widget _buildCompactRecordCard(JobRecordModel record) {
    final date = record.date;
    final day = DateFormat('d').format(date);
    final month = DateFormat('MMM').format(date);
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Make the card width responsive to the screen size
    final cardWidth = context.responsive<double>(
      xs: 280, // Otimizado para 320px
      sm: 320,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    // Ajusta altura do card para telas menores
    final cardHeight = context.responsive<double>(
      xs: 38, // Mais compacto para mobile pequeno
      sm: 40,
      md: 42,
    );
    
    // Ajusta largura da seção de data
    final dateWidth = context.responsive<double>(
      xs: 34, // Mais estreito para telas pequenas
      sm: 38,
      md: 40,
    );
    
    return Center(
      child: SizedBox(
        width: cardWidth,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.8),
            border: Border.all(color: colors.primary, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Date section - mais compacto
              Container(
                width: dateWidth,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomLeft: Radius.circular(3),
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
                            fontSize: context.responsive<double>(xs: 16, sm: 18, md: 20),
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
                            fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
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
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: context.responsive<double>(xs: 8, sm: 10, md: 12),
                  ),
                  child: Text(
                    record.jobName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.body.copyWith(
                      fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}