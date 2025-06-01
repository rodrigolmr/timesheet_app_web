import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';
import 'package:timesheet_app_web/src/features/pigtail/presentation/providers/pigtail_providers.dart';

part 'pigtail_search_providers.g.dart';

@riverpod
class PigtailSearchQuery extends _$PigtailSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

@riverpod
class PigtailSearchFilters extends _$PigtailSearchFilters {
  @override
  ({String? status, String? type}) build() {
    return (status: null, type: null);
  }

  void updateStatus(String? status) {
    state = (status: status, type: state.type);
  }

  void updateType(String? type) {
    state = (status: state.status, type: type);
  }

  void clearFilters() {
    state = (status: null, type: null);
  }
}

@riverpod
List<PigtailModel> searchPigtails(
  SearchPigtailsRef ref, {
  required String query,
  String? status,
  String? type,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final pigtailsAsync = ref.watch(cachedPigtailsProvider);
  
  return pigtailsAsync.when(
    data: (pigtails) {
      // Apply filters
      final filters = <bool Function(PigtailModel)>[];
      
      if (status != null) {
        if (status == 'installed') {
          filters.add((pigtail) => !pigtail.isRemoved);
        } else if (status == 'removed') {
          filters.add((pigtail) => pigtail.isRemoved);
        }
      }
      
      if (type != null && type.isNotEmpty) {
        filters.add((pigtail) => 
          pigtail.pigtailItems.any((item) => 
            item.type.toLowerCase().contains(type.toLowerCase())
          )
        );
      }

      // Search
      return searchService.search(
        items: pigtails,
        query: query,
        searchFields: (pigtail) => [
          pigtail.jobName,
          pigtail.address,
          ...pigtail.pigtailItems.map((item) => item.type),
          pigtail.notes ?? '',
        ],
        filters: filters,
        sortBy: (a, b) {
          // Sort by installed date descending (newest first)
          return b.installedDate.compareTo(a.installedDate);
        },
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
List<PigtailModel> pigtailSearchResults(PigtailSearchResultsRef ref) {
  final query = ref.watch(pigtailSearchQueryProvider);
  final filters = ref.watch(pigtailSearchFiltersProvider);
  
  return ref.watch(searchPigtailsProvider(
    query: query,
    status: filters.status,
    type: filters.type,
  ));
}

// Provider to get unique pigtail types for filter dropdown
@riverpod
List<String> availablePigtailTypes(AvailablePigtailTypesRef ref) {
  final pigtailsAsync = ref.watch(cachedPigtailsProvider);
  
  return pigtailsAsync.when(
    data: (pigtails) {
      final types = <String>{};
      for (final pigtail in pigtails) {
        for (final item in pigtail.pigtailItems) {
          types.add(item.type);
        }
      }
      return types.toList()..sort();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}