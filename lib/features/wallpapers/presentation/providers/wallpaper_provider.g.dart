// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wallpaperNotifierHash() => r'10bc2c14bae25bf423f2ff18a578e33c4c2f4249';

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

abstract class _$WallpaperNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  late final String? categoryId;

  FutureOr<List<WallpaperEntity>> build({String? categoryId});
}

/// See also [WallpaperNotifier].
@ProviderFor(WallpaperNotifier)
const wallpaperNotifierProvider = WallpaperNotifierFamily();

/// See also [WallpaperNotifier].
class WallpaperNotifierFamily
    extends Family<AsyncValue<List<WallpaperEntity>>> {
  /// See also [WallpaperNotifier].
  const WallpaperNotifierFamily();

  /// See also [WallpaperNotifier].
  WallpaperNotifierProvider call({String? categoryId}) {
    return WallpaperNotifierProvider(categoryId: categoryId);
  }

  @override
  WallpaperNotifierProvider getProviderOverride(
    covariant WallpaperNotifierProvider provider,
  ) {
    return call(categoryId: provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wallpaperNotifierProvider';
}

/// See also [WallpaperNotifier].
class WallpaperNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          WallpaperNotifier,
          List<WallpaperEntity>
        > {
  /// See also [WallpaperNotifier].
  WallpaperNotifierProvider({String? categoryId})
    : this._internal(
        () => WallpaperNotifier()..categoryId = categoryId,
        from: wallpaperNotifierProvider,
        name: r'wallpaperNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wallpaperNotifierHash,
        dependencies: WallpaperNotifierFamily._dependencies,
        allTransitiveDependencies:
            WallpaperNotifierFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  WallpaperNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String? categoryId;

  @override
  FutureOr<List<WallpaperEntity>> runNotifierBuild(
    covariant WallpaperNotifier notifier,
  ) {
    return notifier.build(categoryId: categoryId);
  }

  @override
  Override overrideWith(WallpaperNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WallpaperNotifierProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    WallpaperNotifier,
    List<WallpaperEntity>
  >
  createElement() {
    return _WallpaperNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WallpaperNotifierProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WallpaperNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<WallpaperEntity>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _WallpaperNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          WallpaperNotifier,
          List<WallpaperEntity>
        >
    with WallpaperNotifierRef {
  _WallpaperNotifierProviderElement(super.provider);

  @override
  String? get categoryId => (origin as WallpaperNotifierProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
