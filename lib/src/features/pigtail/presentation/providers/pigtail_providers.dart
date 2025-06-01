import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/repositories/firestore_pigtail_repository.dart';
import 'package:timesheet_app_web/src/features/pigtail/domain/repositories/pigtail_repository.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/core/services/nominatim_service.dart';

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

// Provider for address suggestions including new addresses
@riverpod
Future<List<String>> addressSuggestions(AddressSuggestionsRef ref, String query) async {
  if (query.isEmpty || query.length < 3) return [];
  
  // Get existing addresses from database
  final existingAddresses = await ref.watch(uniquePigtailAddressesProvider.future);
  
  // First, check existing addresses that match the query
  final matchingExisting = existingAddresses
      .where((addr) => addr.toLowerCase().contains(query.toLowerCase()))
      .toList();
  
  // Fetch from Nominatim API
  final nominatimService = ref.read(nominatimServiceProvider);
  final onlineSuggestions = await nominatimService.getAddressSuggestions(query);
  
  // Combine existing and online suggestions
  final allSuggestions = <String>{
    ...matchingExisting,
    ...onlineSuggestions,
  }.toList();
  
  // If we don't have many results, add some intelligent fallbacks
  if (allSuggestions.length < 5) {
    // Common Long Island towns
    final longIslandTowns = [
      'Amityville', 'Babylon', 'Lindenhurst', 'Massapequa', 'Farmingdale',
      'Huntington', 'Smithtown', 'Patchogue', 'Levittown', 'Hicksville'
    ];
    
    // Check if query looks like a street address
    final streetMatch = RegExp(r'^(\d+)\s+(.+)').firstMatch(query);
    if (streetMatch != null) {
      final number = streetMatch.group(1)!;
      final street = streetMatch.group(2)!;
      
      // Add suggestions with common towns
      for (final town in longIslandTowns.take(3)) {
        allSuggestions.add('$number $street, $town, NY');
      }
    } else {
      // Query might be a street name or town name
      for (final town in longIslandTowns) {
        if (town.toLowerCase().contains(query.toLowerCase())) {
          allSuggestions.add('Main St, $town, NY');
          allSuggestions.add('Broadway, $town, NY');
        }
      }
    }
  }
  
  // Remove duplicates and sort by relevance
  final uniqueSuggestions = allSuggestions.toSet().toList();
  
  uniqueSuggestions.sort((a, b) {
    // Existing addresses first
    final aExists = existingAddresses.contains(a);
    final bExists = existingAddresses.contains(b);
    
    if (aExists && !bExists) return -1;
    if (!aExists && bExists) return 1;
    
    // Then by query match position
    final aIndex = a.toLowerCase().indexOf(query.toLowerCase());
    final bIndex = b.toLowerCase().indexOf(query.toLowerCase());
    
    if (aIndex >= 0 && bIndex >= 0 && aIndex != bIndex) {
      return aIndex.compareTo(bIndex);
    }
    
    return 0;
  });
  
  return uniqueSuggestions.take(15).toList();
}