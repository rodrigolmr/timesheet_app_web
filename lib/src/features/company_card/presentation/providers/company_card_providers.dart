import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/company_card/data/repositories/firestore_company_card_repository.dart';
import 'package:timesheet_app_web/src/features/company_card/domain/repositories/company_card_repository.dart';

part 'company_card_providers.g.dart';

/// Provider que fornece o repositório de cartões corporativos
@riverpod
CompanyCardRepository companyCardRepository(CompanyCardRepositoryRef ref) {
  return FirestoreCompanyCardRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os cartões
@riverpod
Future<List<CompanyCardModel>> companyCards(CompanyCardsRef ref) {
  return ref.watch(companyCardRepositoryProvider).getAll();
}

/// Provider para observar todos os cartões em tempo real
@riverpod
Stream<List<CompanyCardModel>> companyCardsStream(CompanyCardsStreamRef ref) {
  return ref.watch(companyCardRepositoryProvider).watchAll();
}

/// Provider para obter um cartão específico por ID
@riverpod
Future<CompanyCardModel?> companyCard(CompanyCardRef ref, String id) {
  return ref.watch(companyCardRepositoryProvider).getById(id);
}

/// Provider para observar um cartão específico em tempo real
@riverpod
Stream<CompanyCardModel?> companyCardStream(CompanyCardStreamRef ref, String id) {
  return ref.watch(companyCardRepositoryProvider).watchById(id);
}

/// Provider para observar um cartão específico em tempo real (alternativo para telas)
@riverpod
Stream<CompanyCardModel?> companyCardByIdStream(CompanyCardByIdStreamRef ref, String id) {
  return ref.watch(companyCardRepositoryProvider).watchById(id);
}

/// Provider para obter cartões ativos
@riverpod
Future<List<CompanyCardModel>> activeCompanyCards(ActiveCompanyCardsRef ref) {
  return ref.watch(companyCardRepositoryProvider).getActiveCards();
}

/// Provider para observar cartões ativos em tempo real
@riverpod
Stream<List<CompanyCardModel>> activeCompanyCardsStream(ActiveCompanyCardsStreamRef ref) {
  return ref.watch(companyCardRepositoryProvider).watchActiveCards();
}

/// Provider para gerenciar o estado de um cartão
@riverpod
class CompanyCardState extends _$CompanyCardState {
  @override
  FutureOr<CompanyCardModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(companyCardProvider(id).future);
  }

  /// Ativa ou desativa um cartão
  Future<void> toggleActive(bool isActive) async {
    if (state.value == null) return;
    
    state = const AsyncLoading();
    try {
      await ref.read(companyCardRepositoryProvider).toggleCardActive(
        state.value!.id,
        isActive,
      );
      state = AsyncData(
        state.value!.copyWith(isActive: isActive),
      );
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Atualiza um cartão
  Future<void> updateCard(CompanyCardModel card) async {
    state = const AsyncLoading();
    try {
      await ref.read(companyCardRepositoryProvider).update(
        card.id,
        card,
      );
      state = AsyncData(card);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Cria um novo cartão
  Future<String> create(CompanyCardModel card) async {
    try {
      return await ref.read(companyCardRepositoryProvider).create(card);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui um cartão
  Future<void> delete(String id) async {
    try {
      await ref.read(companyCardRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}