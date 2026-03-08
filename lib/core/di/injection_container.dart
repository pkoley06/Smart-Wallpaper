import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_wallpaper/features/wallpapers/data/datasources/wallpaper_remote_datasource.dart';
import 'package:smart_wallpaper/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_categories.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_similar_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/search_external_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/services/wallpaper_action_service.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/services/download_tracking_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Supabase
  sl.registerLazySingleton(() => Supabase.instance.client);

  // Data Sources
  sl.registerLazySingleton<WallpaperRemoteDataSource>(
    () => SupabaseWallpaperDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<WallpaperRepository>(
    () => WallpaperRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetWallpapers(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => SearchExternalWallpapers(sl()));
  sl.registerLazySingleton(() => GetSimilarWallpapers(sl()));

  // Services
  sl.registerLazySingleton(() => WallpaperActionService());
  sl.registerLazySingleton(() => DownloadTrackingService(sl()));
}
