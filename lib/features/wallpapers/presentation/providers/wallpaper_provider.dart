import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/search_external_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/category_provider.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

part 'wallpaper_provider.g.dart';

@riverpod
class WallpaperNotifier extends _$WallpaperNotifier {
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMorePexels = true;

  @override
  FutureOr<List<WallpaperEntity>> build({String? categoryId}) async {
    _page = 1;
    _hasMorePexels = true;
    _isLoadingMore = false;
    return _fetchWallpapers();
  }

  Future<List<WallpaperEntity>> _fetchWallpapers({
    bool isLoadMore = false,
  }) async {
    final getWallpapers = sl<GetWallpapers>();
    final searchPexels = sl<SearchExternalWallpapers>();

    String query = 'wallpapers';
    if (categoryId != null) {
      try {
        final categories = await ref.read(categoriesProvider.future);
        final category = categories.firstWhere((c) => c.id == categoryId);
        query = category.name;
      } catch (_) {}
    }

    final results = await Future.wait([
      if (!isLoadMore)
        getWallpapers.execute(categoryId: categoryId)
      else
        Future.value(Right<Failure, List<WallpaperEntity>>([])),
      searchPexels.execute(query, page: _page),
    ]);

    final List<WallpaperEntity> newWallpapers = [];

    if (!isLoadMore) {
      results[0].fold(
        (failure) => null,
        (wallpapers) => newWallpapers.addAll(wallpapers),
      );
    }

    results.last.fold((failure) => null, (wallpapers) {
      if (wallpapers.isEmpty) {
        _hasMorePexels = false;
      } else {
        newWallpapers.addAll(wallpapers);
      }
    });

    return newWallpapers;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMorePexels) return;

    _isLoadingMore = true;
    _page++;

    try {
      final newWallpapers = await _fetchWallpapers(isLoadMore: true);

      if (newWallpapers.isNotEmpty) {
        final currentWallpapers = state.value ?? [];
        state = AsyncData([...currentWallpapers, ...newWallpapers]);
      }
    } catch (e) {
      // Ignored
    } finally {
      _isLoadingMore = false;
    }
  }
}
