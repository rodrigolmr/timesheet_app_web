import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/repositories/firestore_pigtail_repository.dart';
import 'package:timesheet_app_web/src/features/pigtail/domain/repositories/pigtail_repository.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

part 'pigtail_providers.g.dart';

@riverpod
PigtailRepository pigtailRepository(PigtailRepositoryRef ref) {
  return FirestorePigtailRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
Future<List<PigtailModel>> pigtails(PigtailsRef ref) {
  return ref.watch(pigtailRepositoryProvider).getAll();
}

@riverpod
Stream<List<PigtailModel>> pigtailsStream(PigtailsStreamRef ref) async* {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) {
    yield [];
    return;
  }

  final repository = ref.watch(pigtailRepositoryProvider);
  
  // User role can only see their own pigtails
  if (userProfile.userRole == UserRole.user) {
    yield* repository.watchByUserId(userProfile.id);
  } else {
    // Manager and admin can see all pigtails
    yield* repository.watchAll();
  }
}

@riverpod
Stream<PigtailModel?> pigtailById(PigtailByIdRef ref, String id) {
  return ref.watch(pigtailRepositoryProvider).watchById(id);
}

@Riverpod(keepAlive: true)
Stream<List<PigtailModel>> cachedPigtails(CachedPigtailsRef ref) {
  return ref.watch(pigtailsStreamProvider.stream);
}

@riverpod
class PigtailState extends _$PigtailState {
  @override
  AsyncValue<PigtailModel?> build() {
    return const AsyncData(null);
  }

  Future<void> create(PigtailModel pigtail) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(pigtailRepositoryProvider).create(pigtail);
      state = AsyncData(pigtail.copyWith(id: id));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> update(String id, PigtailModel pigtail) async {
    state = const AsyncLoading();
    try {
      await ref.read(pigtailRepositoryProvider).update(id, pigtail);
      state = AsyncData(pigtail);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(pigtailRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> markAsRemoved(String id, PigtailModel pigtail) async {
    state = const AsyncLoading();
    try {
      final currentUser = await ref.read(currentUserProfileProvider.future);
      if (currentUser == null) throw Exception('User not found');

      final updatedPigtail = pigtail.copyWith(
        isRemoved: true,
        removedDate: DateTime.now(),
        removedBy: currentUser.id,
        updatedAt: DateTime.now(),
      );

      await ref.read(pigtailRepositoryProvider).update(id, updatedPigtail);
      state = AsyncData(updatedPigtail);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> markAsInstalled(String id, PigtailModel pigtail) async {
    state = const AsyncLoading();
    try {
      final updatedPigtail = pigtail.copyWith(
        isRemoved: false,
        removedDate: null,
        removedBy: null,
        updatedAt: DateTime.now(),
      );

      await ref.read(pigtailRepositoryProvider).update(id, updatedPigtail);
      state = AsyncData(updatedPigtail);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

// Permission providers
@riverpod
Future<bool> canEditPigtail(CanEditPigtailRef ref, String pigtailCreatorId) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;

  // User can only edit their own pigtails
  if (userProfile.userRole == UserRole.user) {
    return userProfile.id == pigtailCreatorId;
  }

  // Manager and admin can edit all pigtails
  return true;
}

@riverpod
Future<bool> canDeletePigtail(CanDeletePigtailRef ref) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;

  // Only manager and admin can delete pigtails
  return userProfile.userRole == UserRole.manager || 
         userProfile.userRole == UserRole.admin;
}

@riverpod
Future<List<String>> uniquePigtailAddresses(UniquePigtailAddressesRef ref) async {
  final pigtailsStream = ref.watch(pigtailsStreamProvider);
  
  return pigtailsStream.when(
    data: (pigtails) {
      // Extract unique addresses and count their usage
      final addressCount = <String, int>{};
      for (final pigtail in pigtails) {
        addressCount[pigtail.address] = (addressCount[pigtail.address] ?? 0) + 1;
      }
      
      // Sort by usage count (most used first) then alphabetically
      final sortedAddresses = addressCount.entries.toList()
        ..sort((a, b) {
          final countCompare = b.value.compareTo(a.value);
          if (countCompare != 0) return countCompare;
          return a.key.toLowerCase().compareTo(b.key.toLowerCase());
        });
      
      return sortedAddresses.map((e) => e.key).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}