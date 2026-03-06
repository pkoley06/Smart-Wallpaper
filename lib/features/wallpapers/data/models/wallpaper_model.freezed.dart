// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallpaper_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WallpaperModel _$WallpaperModelFromJson(Map<String, dynamic> json) {
  return _WallpaperModel.fromJson(json);
}

/// @nodoc
mixin _$WallpaperModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_low_res')
  String get urlLowRes => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_high_res')
  String get urlHighRes => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_premium')
  bool get isPremium => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_ai_generated')
  bool get isAiGenerated => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_api')
  String get sourceApi => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'download_count')
  int get downloadCount => throw _privateConstructorUsedError;
  Map<String, String>? get resolutions => throw _privateConstructorUsedError;

  /// Serializes this WallpaperModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WallpaperModelCopyWith<WallpaperModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WallpaperModelCopyWith<$Res> {
  factory $WallpaperModelCopyWith(
    WallpaperModel value,
    $Res Function(WallpaperModel) then,
  ) = _$WallpaperModelCopyWithImpl<$Res, WallpaperModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? title,
    @JsonKey(name: 'url_low_res') String urlLowRes,
    @JsonKey(name: 'url_high_res') String urlHighRes,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'is_premium') bool isPremium,
    @JsonKey(name: 'is_ai_generated') bool isAiGenerated,
    @JsonKey(name: 'source_api') String sourceApi,
    List<String>? tags,
    @JsonKey(name: 'download_count') int downloadCount,
    Map<String, String>? resolutions,
  });
}

/// @nodoc
class _$WallpaperModelCopyWithImpl<$Res, $Val extends WallpaperModel>
    implements $WallpaperModelCopyWith<$Res> {
  _$WallpaperModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? title = freezed,
    Object? urlLowRes = null,
    Object? urlHighRes = null,
    Object? categoryId = freezed,
    Object? isPremium = null,
    Object? isAiGenerated = null,
    Object? sourceApi = null,
    Object? tags = freezed,
    Object? downloadCount = null,
    Object? resolutions = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            urlLowRes: null == urlLowRes
                ? _value.urlLowRes
                : urlLowRes // ignore: cast_nullable_to_non_nullable
                      as String,
            urlHighRes: null == urlHighRes
                ? _value.urlHighRes
                : urlHighRes // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAiGenerated: null == isAiGenerated
                ? _value.isAiGenerated
                : isAiGenerated // ignore: cast_nullable_to_non_nullable
                      as bool,
            sourceApi: null == sourceApi
                ? _value.sourceApi
                : sourceApi // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            downloadCount: null == downloadCount
                ? _value.downloadCount
                : downloadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            resolutions: freezed == resolutions
                ? _value.resolutions
                : resolutions // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WallpaperModelImplCopyWith<$Res>
    implements $WallpaperModelCopyWith<$Res> {
  factory _$$WallpaperModelImplCopyWith(
    _$WallpaperModelImpl value,
    $Res Function(_$WallpaperModelImpl) then,
  ) = __$$WallpaperModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? title,
    @JsonKey(name: 'url_low_res') String urlLowRes,
    @JsonKey(name: 'url_high_res') String urlHighRes,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'is_premium') bool isPremium,
    @JsonKey(name: 'is_ai_generated') bool isAiGenerated,
    @JsonKey(name: 'source_api') String sourceApi,
    List<String>? tags,
    @JsonKey(name: 'download_count') int downloadCount,
    Map<String, String>? resolutions,
  });
}

/// @nodoc
class __$$WallpaperModelImplCopyWithImpl<$Res>
    extends _$WallpaperModelCopyWithImpl<$Res, _$WallpaperModelImpl>
    implements _$$WallpaperModelImplCopyWith<$Res> {
  __$$WallpaperModelImplCopyWithImpl(
    _$WallpaperModelImpl _value,
    $Res Function(_$WallpaperModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? title = freezed,
    Object? urlLowRes = null,
    Object? urlHighRes = null,
    Object? categoryId = freezed,
    Object? isPremium = null,
    Object? isAiGenerated = null,
    Object? sourceApi = null,
    Object? tags = freezed,
    Object? downloadCount = null,
    Object? resolutions = freezed,
  }) {
    return _then(
      _$WallpaperModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        urlLowRes: null == urlLowRes
            ? _value.urlLowRes
            : urlLowRes // ignore: cast_nullable_to_non_nullable
                  as String,
        urlHighRes: null == urlHighRes
            ? _value.urlHighRes
            : urlHighRes // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAiGenerated: null == isAiGenerated
            ? _value.isAiGenerated
            : isAiGenerated // ignore: cast_nullable_to_non_nullable
                  as bool,
        sourceApi: null == sourceApi
            ? _value.sourceApi
            : sourceApi // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        downloadCount: null == downloadCount
            ? _value.downloadCount
            : downloadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        resolutions: freezed == resolutions
            ? _value._resolutions
            : resolutions // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WallpaperModelImpl implements _WallpaperModel {
  const _$WallpaperModelImpl({
    required this.id,
    @JsonKey(name: 'created_at') this.createdAt,
    this.title,
    @JsonKey(name: 'url_low_res') required this.urlLowRes,
    @JsonKey(name: 'url_high_res') required this.urlHighRes,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'is_premium') this.isPremium = false,
    @JsonKey(name: 'is_ai_generated') this.isAiGenerated = false,
    @JsonKey(name: 'source_api') this.sourceApi = 'pexels',
    final List<String>? tags,
    @JsonKey(name: 'download_count') this.downloadCount = 0,
    final Map<String, String>? resolutions,
  }) : _tags = tags,
       _resolutions = resolutions;

  factory _$WallpaperModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WallpaperModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  final String? title;
  @override
  @JsonKey(name: 'url_low_res')
  final String urlLowRes;
  @override
  @JsonKey(name: 'url_high_res')
  final String urlHighRes;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  @override
  @JsonKey(name: 'is_ai_generated')
  final bool isAiGenerated;
  @override
  @JsonKey(name: 'source_api')
  final String sourceApi;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'download_count')
  final int downloadCount;
  final Map<String, String>? _resolutions;
  @override
  Map<String, String>? get resolutions {
    final value = _resolutions;
    if (value == null) return null;
    if (_resolutions is EqualUnmodifiableMapView) return _resolutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WallpaperModel(id: $id, createdAt: $createdAt, title: $title, urlLowRes: $urlLowRes, urlHighRes: $urlHighRes, categoryId: $categoryId, isPremium: $isPremium, isAiGenerated: $isAiGenerated, sourceApi: $sourceApi, tags: $tags, downloadCount: $downloadCount, resolutions: $resolutions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WallpaperModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.urlLowRes, urlLowRes) ||
                other.urlLowRes == urlLowRes) &&
            (identical(other.urlHighRes, urlHighRes) ||
                other.urlHighRes == urlHighRes) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.sourceApi, sourceApi) ||
                other.sourceApi == sourceApi) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.downloadCount, downloadCount) ||
                other.downloadCount == downloadCount) &&
            const DeepCollectionEquality().equals(
              other._resolutions,
              _resolutions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    createdAt,
    title,
    urlLowRes,
    urlHighRes,
    categoryId,
    isPremium,
    isAiGenerated,
    sourceApi,
    const DeepCollectionEquality().hash(_tags),
    downloadCount,
    const DeepCollectionEquality().hash(_resolutions),
  );

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WallpaperModelImplCopyWith<_$WallpaperModelImpl> get copyWith =>
      __$$WallpaperModelImplCopyWithImpl<_$WallpaperModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WallpaperModelImplToJson(this);
  }
}

abstract class _WallpaperModel implements WallpaperModel {
  const factory _WallpaperModel({
    required final String id,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    final String? title,
    @JsonKey(name: 'url_low_res') required final String urlLowRes,
    @JsonKey(name: 'url_high_res') required final String urlHighRes,
    @JsonKey(name: 'category_id') final String? categoryId,
    @JsonKey(name: 'is_premium') final bool isPremium,
    @JsonKey(name: 'is_ai_generated') final bool isAiGenerated,
    @JsonKey(name: 'source_api') final String sourceApi,
    final List<String>? tags,
    @JsonKey(name: 'download_count') final int downloadCount,
    final Map<String, String>? resolutions,
  }) = _$WallpaperModelImpl;

  factory _WallpaperModel.fromJson(Map<String, dynamic> json) =
      _$WallpaperModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  String? get title;
  @override
  @JsonKey(name: 'url_low_res')
  String get urlLowRes;
  @override
  @JsonKey(name: 'url_high_res')
  String get urlHighRes;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'is_premium')
  bool get isPremium;
  @override
  @JsonKey(name: 'is_ai_generated')
  bool get isAiGenerated;
  @override
  @JsonKey(name: 'source_api')
  String get sourceApi;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'download_count')
  int get downloadCount;
  @override
  Map<String, String>? get resolutions;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WallpaperModelImplCopyWith<_$WallpaperModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
