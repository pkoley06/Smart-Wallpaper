import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class GetWallpapers {
  final WallpaperRepository repository;

  GetWallpapers(this.repository);

  Future<Either<Failure, List<WallpaperEntity>>> execute({String? categoryId}) {
    return repository.getWallpapers(categoryId: categoryId);
  }
}
