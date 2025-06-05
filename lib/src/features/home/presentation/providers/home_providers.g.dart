// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeNavigationItemsHash() =>
    r'14a35ca118032afade9a35dba1dcc428df932569';

/// Provider for home navigation items
///
/// Copied from [homeNavigationItems].
@ProviderFor(homeNavigationItems)
final homeNavigationItemsProvider =
    AutoDisposeProvider<List<HomeNavigationItem>>.internal(
      homeNavigationItems,
      name: r'homeNavigationItemsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$homeNavigationItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeNavigationItemsRef =
    AutoDisposeProviderRef<List<HomeNavigationItem>>;
String _$filteredHomeNavigationItemsHash() =>
    r'6c3a2c0176fd2e2157866ab6267323c7cb791589';

/// Provider for filtered home navigation items based on user permissions
///
/// Copied from [filteredHomeNavigationItems].
@ProviderFor(filteredHomeNavigationItems)
final filteredHomeNavigationItemsProvider =
    AutoDisposeFutureProvider<List<HomeNavigationItem>>.internal(
      filteredHomeNavigationItems,
      name: r'filteredHomeNavigationItemsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredHomeNavigationItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredHomeNavigationItemsRef =
    AutoDisposeFutureProviderRef<List<HomeNavigationItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
