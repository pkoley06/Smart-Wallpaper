import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_wallpaper/core/constants/app_constants.dart';

class DownloadTrackingService {
  final SupabaseClient _client;

  DownloadTrackingService(this._client);

  /// Track a wallpaper download in Supabase
  Future<void> trackDownload({
    required String wallpaperId,
    required String resolution,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      await _client.from(AppConstants.tableDownloads).insert({
        'user_id': user.id,
        'wallpaper_id': wallpaperId,
        'resolution': resolution,
        'downloaded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error tracking download: $e');
      // Don't throw — download tracking should never block the actual download
    }
  }
}
