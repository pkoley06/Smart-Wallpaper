import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/entities/category_entity.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_categories.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<CategoryEntity>> categories(CategoriesRef ref) async {
  final useCase = sl<GetCategories>();
  final result = await useCase.execute();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
}
