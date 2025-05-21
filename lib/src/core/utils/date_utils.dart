import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

/// Classe para representar uma semana com registros (sexta a quinta)
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
    final thisWeekId = getWeekId(now);
    final lastWeekId = getWeekId(now.subtract(const Duration(days: 7)));
    
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

/// Identificador único para semana de sexta a quinta
String getWeekId(DateTime date) {
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
  final dayOfYear = getDayOfYear(fridayOfWeek);
  final weekNumber = ((dayOfYear - 1) / 7).floor() + 1;
  
  // Formatar como AAAASS (ano+semana)
  return '${fridayOfWeek.year}${weekNumber.toString().padLeft(2, '0')}';
}

/// Calcula o dia do ano (1-366)
int getDayOfYear(DateTime date) {
  final startOfYear = DateTime(date.year, 1, 1);
  return date.difference(startOfYear).inDays + 1;
}

/// Obter data inicial (sexta-feira) da semana com base no ID da semana
DateTime getWeekStartDateFromId(String weekId) {
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

/// Agrupa registros por semana (sexta a quinta)
List<WeekGroup> groupRecordsByWeek(List<JobRecordModel> records) {
  // Mapa para agrupar registros por ID de semana
  final Map<String, List<JobRecordModel>> groupedByWeekId = {};
  
  // Agrupar registros por ID de semana
  for (final record in records) {
    final weekId = getWeekId(record.date);
    
    if (!groupedByWeekId.containsKey(weekId)) {
      groupedByWeekId[weekId] = [];
    }
    
    groupedByWeekId[weekId]!.add(record);
  }
  
  // Converter para lista de WeekGroup
  final List<WeekGroup> result = [];
  for (final weekId in groupedByWeekId.keys) {
    // Obter data inicial da semana a partir do ID
    final startDate = getWeekStartDateFromId(weekId);
    
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