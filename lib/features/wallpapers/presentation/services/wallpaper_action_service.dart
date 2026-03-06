import 'dart:io';
import 'dart:typed_data';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum WallpaperLocation { home, lock, both }

class WallpaperActionService {
  final Dio _dio = Dio();

  // Returns null if successful, or an error message string if failed.
  Future<String?> setWallpaper({
    required String url,
    required WallpaperLocation location,
  }) async {
    try {
      final file = await _downloadFile(url);
      if (file == null)
        return 'Failed to download the image for setting wallpaper.';

      int wallpaperLocation;
      switch (location) {
        case WallpaperLocation.home:
          wallpaperLocation = AsyncWallpaper.HOME_SCREEN;
          break;
        case WallpaperLocation.lock:
          wallpaperLocation = AsyncWallpaper.LOCK_SCREEN;
          break;
        case WallpaperLocation.both:
          wallpaperLocation = AsyncWallpaper.BOTH_SCREENS;
          break;
      }

      final result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        wallpaperLocation: wallpaperLocation,
        goToHome: false,
      );

      return result ? null : 'Unknown error occurred while setting wallpaper.';
    } catch (e) {
      print('Error setting wallpaper: $e');
      return 'Could not set wallpaper. Please ensure the app has permissions.';
    }
  }

  // Returns null if successful, or an error message string if failed.
  Future<String?> downloadToGallery(String url) async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        final isAndroid13OrHigher = deviceInfo.version.sdkInt >= 33;

        PermissionStatus status;
        if (isAndroid13OrHigher) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          return 'Storage permission is required to save wallpapers.';
        }
      }

      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
      );

      if (result['isSuccess'] == true) {
        return null; // Success
      } else {
        return result['errorMessage']?.toString() ??
            'Gallery save failed for an unknown reason.';
      }
    } catch (e) {
      print('Error downloading to gallery: $e');
      return 'Download failed. Check your internet connection or permissions.';
    }
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _dio.download(url, filePath);
      return File(filePath);
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
}
