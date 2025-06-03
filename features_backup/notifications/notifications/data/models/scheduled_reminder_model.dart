import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'scheduled_reminder_model.freezed.dart';
part 'scheduled_reminder_model.g.dart';

@freezed
class ScheduledReminderModel with _$ScheduledReminderModel {
  const ScheduledReminderModel._();
  
  const factory ScheduledReminderModel({
    required String id,
    required String title,
    required String message,
    required List<String> targetUserIds, // Lista de IDs de usuários que receberão o lembrete
    required DateTime scheduledTime, // Hora específica para enviar
    required String frequency, // 'once', 'daily', 'weekly', 'monthly'
    String? dayOfWeek, // Para lembretes semanais (1-7, onde 1 = segunda)
    int? dayOfMonth, // Para lembretes mensais (1-31)
    required bool isActive,
    required String createdBy, // ID do admin que criou
    required DateTime createdAt,
    DateTime? lastSentAt, // Última vez que foi enviado
    DateTime? nextSendAt, // Próxima vez que será enviado
    Map<String, dynamic>? metadata, // Dados adicionais
  }) = _ScheduledReminderModel;

  factory ScheduledReminderModel.fromJson(Map<String, dynamic> json) => 
      _$ScheduledReminderModelFromJson(json);

  factory ScheduledReminderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ScheduledReminderModel(
      id: doc.id,
      title: data['title'] as String,
      message: data['message'] as String,
      targetUserIds: List<String>.from(data['target_user_ids'] ?? []),
      scheduledTime: (data['scheduled_time'] as Timestamp).toDate(),
      frequency: data['frequency'] as String,
      dayOfWeek: data['day_of_week'] as String?,
      dayOfMonth: data['day_of_month'] as int?,
      isActive: data['is_active'] as bool? ?? true,
      createdBy: data['created_by'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      lastSentAt: data['last_sent_at'] != null 
          ? (data['last_sent_at'] as Timestamp).toDate() 
          : null,
      nextSendAt: data['next_send_at'] != null 
          ? (data['next_send_at'] as Timestamp).toDate() 
          : null,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'target_user_ids': targetUserIds,
      'scheduled_time': Timestamp.fromDate(scheduledTime),
      'frequency': frequency,
      'day_of_week': dayOfWeek,
      'day_of_month': dayOfMonth,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': Timestamp.fromDate(createdAt),
      'last_sent_at': lastSentAt != null ? Timestamp.fromDate(lastSentAt!) : null,
      'next_send_at': nextSendAt != null ? Timestamp.fromDate(nextSendAt!) : null,
      'metadata': metadata,
    };
  }

  // Helper method to calculate next send time
  DateTime? calculateNextSendTime() {
    final now = DateTime.now();
    
    switch (frequency) {
      case 'once':
        // Se já foi enviado ou a data passou, não há próximo envio
        return (lastSentAt != null || scheduledTime.isBefore(now)) ? null : scheduledTime;
        
      case 'daily':
        // Próximo envio é amanhã na mesma hora
        final nextDay = DateTime(
          now.year,
          now.month,
          now.day,
          scheduledTime.hour,
          scheduledTime.minute,
        );
        return nextDay.isBefore(now) 
            ? nextDay.add(const Duration(days: 1))
            : nextDay;
            
      case 'weekly':
        if (dayOfWeek == null) return null;
        
        final targetWeekday = int.parse(dayOfWeek!);
        final currentWeekday = now.weekday;
        var daysToAdd = targetWeekday - currentWeekday;
        
        if (daysToAdd < 0 || (daysToAdd == 0 && now.hour >= scheduledTime.hour)) {
          daysToAdd += 7;
        }
        
        return DateTime(
          now.year,
          now.month,
          now.day + daysToAdd,
          scheduledTime.hour,
          scheduledTime.minute,
        );
        
      case 'monthly':
        if (dayOfMonth == null) return null;
        
        var targetMonth = now.month;
        var targetYear = now.year;
        
        // Se já passou o dia deste mês, vai para o próximo
        if (now.day > dayOfMonth! || 
            (now.day == dayOfMonth && now.hour >= scheduledTime.hour)) {
          targetMonth++;
          if (targetMonth > 12) {
            targetMonth = 1;
            targetYear++;
          }
        }
        
        // Ajusta para o último dia do mês se necessário
        final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;
        final targetDay = dayOfMonth! > daysInMonth ? daysInMonth : dayOfMonth!;
        
        return DateTime(
          targetYear,
          targetMonth,
          targetDay,
          scheduledTime.hour,
          scheduledTime.minute,
        );
        
      default:
        return null;
    }
  }
}