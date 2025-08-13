// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_pdf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expensePdfServiceHash() => r'8ad3a9ba5fb476aa3e107141bf45ed6fd32468a0';

/// See also [expensePdfService].
@ProviderFor(expensePdfService)
final expensePdfServiceProvider =
    AutoDisposeProvider<ExpensePdfService>.internal(
      expensePdfService,
      name: r'expensePdfServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$expensePdfServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpensePdfServiceRef = AutoDisposeProviderRef<ExpensePdfService>;
String _$expenseBulkPdfGeneratorHash() =>
    r'c350be6e595f5c30fa7aeb11f09acaf0fcfacbe0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [expenseBulkPdfGenerator].
@ProviderFor(expenseBulkPdfGenerator)
const expenseBulkPdfGeneratorProvider = ExpenseBulkPdfGeneratorFamily();

/// See also [expenseBulkPdfGenerator].
class ExpenseBulkPdfGeneratorFamily extends Family<AsyncValue<Uint8List>> {
  /// See also [expenseBulkPdfGenerator].
  const ExpenseBulkPdfGeneratorFamily();

  /// See also [expenseBulkPdfGenerator].
  ExpenseBulkPdfGeneratorProvider call(List<String> expenseIds) {
    return ExpenseBulkPdfGeneratorProvider(expenseIds);
  }

  @override
  ExpenseBulkPdfGeneratorProvider getProviderOverride(
    covariant ExpenseBulkPdfGeneratorProvider provider,
  ) {
    return call(provider.expenseIds);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseBulkPdfGeneratorProvider';
}

/// See also [expenseBulkPdfGenerator].
class ExpenseBulkPdfGeneratorProvider
    extends AutoDisposeFutureProvider<Uint8List> {
  /// See also [expenseBulkPdfGenerator].
  ExpenseBulkPdfGeneratorProvider(List<String> expenseIds)
    : this._internal(
        (ref) => expenseBulkPdfGenerator(
          ref as ExpenseBulkPdfGeneratorRef,
          expenseIds,
        ),
        from: expenseBulkPdfGeneratorProvider,
        name: r'expenseBulkPdfGeneratorProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expenseBulkPdfGeneratorHash,
        dependencies: ExpenseBulkPdfGeneratorFamily._dependencies,
        allTransitiveDependencies:
            ExpenseBulkPdfGeneratorFamily._allTransitiveDependencies,
        expenseIds: expenseIds,
      );

  ExpenseBulkPdfGeneratorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.expenseIds,
  }) : super.internal();

  final List<String> expenseIds;

  @override
  Override overrideWith(
    FutureOr<Uint8List> Function(ExpenseBulkPdfGeneratorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseBulkPdfGeneratorProvider._internal(
        (ref) => create(ref as ExpenseBulkPdfGeneratorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        expenseIds: expenseIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Uint8List> createElement() {
    return _ExpenseBulkPdfGeneratorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseBulkPdfGeneratorProvider &&
        other.expenseIds == expenseIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, expenseIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseBulkPdfGeneratorRef on AutoDisposeFutureProviderRef<Uint8List> {
  /// The parameter `expenseIds` of this provider.
  List<String> get expenseIds;
}

class _ExpenseBulkPdfGeneratorProviderElement
    extends AutoDisposeFutureProviderElement<Uint8List>
    with ExpenseBulkPdfGeneratorRef {
  _ExpenseBulkPdfGeneratorProviderElement(super.provider);

  @override
  List<String> get expenseIds =>
      (origin as ExpenseBulkPdfGeneratorProvider).expenseIds;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
