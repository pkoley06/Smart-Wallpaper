// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_wallpaper_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$similarWallpapersNotifierHash() =>
    r'1af783b92865f28f0a3b6c3529a9346e1683bb0b';

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

abstract class _$SimilarWallpapersNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  late final String wallpaperId;
  late final String? tags;

  FutureOr<List<WallpaperEntity>> build(String wallpaperId, {String? tags});
}

/// See also [SimilarWallpapersNotifier].
@ProviderFor(SimilarWallpapersNotifier)
const similarWallpapersNotifierProvider = SimilarWallpapersNotifierFamily();

/// See also [SimilarWallpapersNotifier].
class SimilarWallpapersNotifierFamily
    extends Family<AsyncValue<List<WallpaperEntity>>> {
  /// See also [SimilarWallpapersNotifier].
  const SimilarWallpapersNotifierFamily();

  /// See also [SimilarWallpapersNotifier].
  SimilarWallpapersNotifierProvider call(String wallpaperId, {String? tags}) {
    return SimilarWallpapersNotifierProvider(wallpaperId, tags: tags);
  }

  @override
  SimilarWallpapersNotifierProvider getProviderOverride(
    covariant SimilarWallpapersNotifierProvider provider,
  ) {
    return call(provider.wallpaperId, tags: provider.tags);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarWallpapersNotifierProvider';
}

/// See also [SimilarWallpapersNotifier].
class SimilarWallpapersNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SimilarWallpapersNotifier,
          List<WallpaperEntity>
        > {
  /// See also [SimilarWallpapersNotifier].
  SimilarWallpapersNotifierProvider(String wallpaperId, {String? tags})
    : this._internal(
        () => SimilarWallpapersNotifier()
          ..wallpaperId = wallpaperId
          ..tags = tags,
        from: similarWallpapersNotifierProvider,
        name: r'similarWallpapersNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$similarWallpapersNotifierHash,
        dependencies: SimilarWallpapersNotifierFamily._dependencies,
        allTransitiveDependencies:
            SimilarWallpapersNotifierFamily._allTransitiveDependencies,
        wallpaperId: wallpaperId,
        tags: tags,
      );

  SimilarWallpapersNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wallpaperId,
    required this.tags,
  }) : super.internal();

  final String wallpaperId;
  final String? tags;

  @override
  FutureOr<List<WallpaperEntity>> runNotifierBuild(
    covariant SimilarWallpapersNotifier notifier,
  ) {
    return notifier.build(wallpaperId, tags: tags);
  }

  @override
  Override overrideWith(SimilarWallpapersNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SimilarWallpapersNotifierProvider._internal(
        () => create()
          ..wallpaperId = wallpaperId
          ..tags = tags,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wallpaperId: wallpaperId,
        tags: tags,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    SimilarWallpapersNotifier,
    List<WallpaperEntity>
  >
  createElement() {
    return _SimilarWallpapersNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarWallpapersNotifierProvider &&
        other.wallpaperId == wallpaperId &&
        other.tags == tags;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wallpaperId.hashCode);
    hash = _SystemHash.combine(hash, tags.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimilarWallpapersNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<WallpaperEntity>> {
  /// The parameter `wallpaperId` of this provider.
  String get wallpaperId;

  /// The parameter `tags` of this provider.
  String? get tags;
}

class _SimilarWallpapersNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SimilarWallpapersNotifier,
          List<WallpaperEntity>
        >
    with SimilarWallpapersNotifierRef {
  _SimilarWallpapersNotifierProviderElement(super.provider);

  @override
  String get wallpaperId =>
      (origin as SimilarWallpapersNotifierProvider).wallpaperId;
  @override
  String? get tags => (origin as SimilarWallpapersNotifierProvider).tags;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
