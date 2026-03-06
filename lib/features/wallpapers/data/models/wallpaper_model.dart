import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_model.freezed.dart';
part 'wallpaper_model.g.dart';

@freezed
class WallpaperModel with _$WallpaperModel {
  const factory WallpaperModel({
    required String id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? title,
    @JsonKey(name: 'url_low_res') required String urlLowRes,
    @JsonKey(name: 'url_high_res') required String urlHighRes,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @JsonKey(name: 'is_ai_generated') @Default(false) bool isAiGenerated,
    @JsonKey(name: 'source_api') @Default('pexels') String sourceApi,
    List<String>? tags,
    @JsonKey(name: 'download_count') @Default(0) int downloadCount,
    Map<String, String>? resolutions,
  }) = _WallpaperModel;

  factory WallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$WallpaperModelFromJson(json);
}
