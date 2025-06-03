// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_approval_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingApprovalJobRecordsHash() =>
    r'13c86715e346b64292019057ed47982212769d3b';

/// Provider que monitora job records pendentes de aprovação
///
/// Copied from [pendingApprovalJobRecords].
@ProviderFor(pendingApprovalJobRecords)
final pendingApprovalJobRecordsProvider =
    AutoDisposeStreamProvider<List<JobRecordModel>>.internal(
      pendingApprovalJobRecords,
      name: r'pendingApprovalJobRecordsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingApprovalJobRecordsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingApprovalJobRecordsRef =
    AutoDisposeStreamProviderRef<List<JobRecordModel>>;
String _$pendingApprovalCountHash() =>
    r'aa4192896426d4a43858449d6098c01b22ff1343';

/// Provider que retorna o número de job records aguardando aprovação
///
/// Copied from [pendingApprovalCount].
@ProviderFor(pendingApprovalCount)
final pendingApprovalCountProvider = AutoDisposeProvider<int>.internal(
  pendingApprovalCount,
  name: r'pendingApprovalCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingApprovalCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingApprovalCountRef = AutoDisposeProviderRef<int>;
String _$pendingApprovalNotifierHash() =>
    r'8cf73309189d88c83be85850ae1f0662f24c4634';

/// Provider que cria/atualiza notificação de resumo de pendências
///
/// Copied from [PendingApprovalNotifier].
@ProviderFor(PendingApprovalNotifier)
final pendingApprovalNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PendingApprovalNotifier, void>.internal(
      PendingApprovalNotifier.new,
      name: r'pendingApprovalNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingApprovalNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PendingApprovalNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
