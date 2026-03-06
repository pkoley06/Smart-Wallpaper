import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_similar_wallpapers.dart';

part 'similar_wallpaper_provider.g.dart';

@riverpod
class SimilarWallpapersNotifier extends _$SimilarWallpapersNotifier {
  int _page = 1;
  bool _hasMore = true;
  final List<WallpaperEntity> _allWallpapers = [];

  @override
  FutureOr<List<WallpaperEntity>> build(
    String wallpaperId, {
    String? tags,
  }) async {
    _page = 1;
    _hasMore = true;
    _allWallpapers.clear();

    if (tags == null || tags.isEmpty) return [];

    final useCase = sl<GetSimilarWallpapers>();
    final result = await useCase.execute(tags, page: 1);

    return result.fold((failure) => [], (wallpapers) {
      final filtered = wallpapers.where((w) => w.id != wallpaperId).toList();
      _allWallpapers.addAll(filtered);
      _hasMore = wallpapers.length >= 20;
      return List.from(_allWallpapers);
    });
  }

  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (state is AsyncLoading) return;

    _page++;
    final tags = this.tags;
    if (tags == null || tags.isEmpty) return;

    final useCase = sl<GetSimilarWallpapers>();
    final result = await useCase.execute(tags, page: _page);

    result.fold((failure) => _hasMore = false, (wallpapers) {
      final filtered = wallpapers.where((w) => w.id != wallpaperId).toList();
      _allWallpapers.addAll(filtered);
      _hasMore = wallpapers.length >= 20;
      state = AsyncData(List.from(_allWallpapers));
    });
  }
}
