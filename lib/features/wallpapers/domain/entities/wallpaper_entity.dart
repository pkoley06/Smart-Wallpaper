class WallpaperEntity {
  final String id;
  final String? title;
  final String urlLowRes;
  final String urlHighRes;
  final String? categoryId;
  final bool isPremium;
  final bool isAiGenerated;
  final List<String> tags;
  final int downloadCount;
  final Map<String, String>? resolutions;

  WallpaperEntity({
    required this.id,
    this.title,
    required this.urlLowRes,
    required this.urlHighRes,
    this.categoryId,
    this.isPremium = false,
    this.isAiGenerated = false,
    this.tags = const [],
    this.downloadCount = 0,
    this.resolutions,
  });
}
