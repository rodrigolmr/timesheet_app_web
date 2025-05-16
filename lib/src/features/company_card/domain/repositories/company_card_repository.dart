import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';

abstract class CompanyCardRepository implements BaseRepository<CompanyCardModel> {
  /// Retorna todos os cartões ativos
  Future<List<CompanyCardModel>> getActiveCards();
  
  /// Stream de todos os cartões ativos
  Stream<List<CompanyCardModel>> watchActiveCards();
  
  /// Ativa ou desativa um cartão
  Future<void> toggleCardActive(String id, bool isActive);
}