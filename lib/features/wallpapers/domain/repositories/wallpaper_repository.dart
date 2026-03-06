import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallpaper_entity.dart';
import '../entities/category_entity.dart';

abstract class WallpaperRepository {
  Future<Either<Failure, List<WallpaperEntity>>> getWallpapers({
    String? categoryId,
  });
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, WallpaperEntity>> getWallpaperById(String id);
  Future<Either<Failure, List<WallpaperEntity>>> searchExternalWallpapers(
    String query, {
    int page = 1,
  });
  Future<Either<Failure, List<WallpaperEntity>>> getSimilarWallpapers(
    String query, {
    int page = 1,
  });
}
