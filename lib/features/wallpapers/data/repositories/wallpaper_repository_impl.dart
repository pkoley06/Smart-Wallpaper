import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../datasources/wallpaper_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/wallpaper_model.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperRemoteDataSource remoteDataSource;

  WallpaperRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Right(models.map((m) => _categoryToEntity(m)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getWallpapers({
    String? categoryId,
  }) async {
    try {
      final models = await remoteDataSource.getWallpapers(
        categoryId: categoryId,
      );
      return Right(models.map((m) => _wallpaperToEntity(m)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WallpaperEntity>> getWallpaperById(String id) async {
    try {
      final model = await remoteDataSource.getWallpaperById(id);
      return Right(_wallpaperToEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> searchExternalWallpapers(
    String query, {
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getExternalWallpapers(
        query,
        page: page,
      );
      return Right(models.map((m) => _wallpaperToEntity(m)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getSimilarWallpapers(
    String query, {
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getSimilarWallpapers(
        query,
        page: page,
      );
      return Right(models.map((m) => _wallpaperToEntity(m)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  CategoryEntity _categoryToEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      slug: model.slug,
      imageUrl: model.imageUrl,
    );
  }

  WallpaperEntity _wallpaperToEntity(WallpaperModel model) {
    return WallpaperEntity(
      id: model.id,
      title: model.title,
      urlLowRes: model.urlLowRes,
      urlHighRes: model.urlHighRes,
      categoryId: model.categoryId,
      isPremium: model.isPremium,
      isAiGenerated: model.isAiGenerated,
      tags: model.tags ?? [],
      downloadCount: model.downloadCount,
      resolutions: model.resolutions,
    );
  }
}
