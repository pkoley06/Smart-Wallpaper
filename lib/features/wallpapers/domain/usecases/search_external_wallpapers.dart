import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class SearchExternalWallpapers {
  final WallpaperRepository repository;

  SearchExternalWallpapers(this.repository);

  Future<Either<Failure, List<WallpaperEntity>>> execute(
    String query, {
    int page = 1,
  }) async {
    return await repository.searchExternalWallpapers(query, page: page);
  }
}
