import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/wallpaper_repository.dart';

class GetCategories {
  final WallpaperRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> execute() {
    return repository.getCategories();
  }
}
