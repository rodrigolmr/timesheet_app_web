import 'package:freezed_annotation/freezed_annotation.dart';

part 'database_stats_model.freezed.dart';
part 'database_stats_model.g.dart';

@freezed
class DatabaseStatsModel with _$DatabaseStatsModel {
  const DatabaseStatsModel._();
  
  const factory DatabaseStatsModel({
    required String collectionName,
    required int documentCount,
    required DateTime? lastUpdated,
    required int approximateSizeInBytes,
  }) = _DatabaseStatsModel;

  factory DatabaseStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DatabaseStatsModelFromJson(json);
}

@freezed
class DatabaseCollectionModel with _$DatabaseCollectionModel {
  const DatabaseCollectionModel._();
  
  const factory DatabaseCollectionModel({
    required String name,
    required int documentCount,
    required List<String> fields,
    required DateTime? lastUpdated,
  }) = _DatabaseCollectionModel;

  factory DatabaseCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$DatabaseCollectionModelFromJson(json);
}