// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WallpaperModelImpl _$$WallpaperModelImplFromJson(Map<String, dynamic> json) =>
    _$WallpaperModelImpl(
      id: json['id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      title: json['title'] as String?,
      urlLowRes: json['url_low_res'] as String,
      urlHighRes: json['url_high_res'] as String,
      categoryId: json['category_id'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,
      sourceApi: json['source_api'] as String? ?? 'pexels',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
      resolutions: (json['resolutions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$WallpaperModelImplToJson(
  _$WallpaperModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt?.toIso8601String(),
  'title': instance.title,
  'url_low_res': instance.urlLowRes,
  'url_high_res': instance.urlHighRes,
  'category_id': instance.categoryId,
  'is_premium': instance.isPremium,
  'is_ai_generated': instance.isAiGenerated,
  'source_api': instance.sourceApi,
  'tags': instance.tags,
  'download_count': instance.downloadCount,
  'resolutions': instance.resolutions,
};
