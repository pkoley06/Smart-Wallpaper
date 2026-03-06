import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/wallpaper_model.dart';
import '../models/category_model.dart';

abstract class WallpaperRemoteDataSource {
  Future<List<WallpaperModel>> getWallpapers({
    String? categoryId,
    int limit = 20,
  });
  Future<List<CategoryModel>> getCategories();
  Future<WallpaperModel> getWallpaperById(String id);
  Future<List<WallpaperModel>> getExternalWallpapers(
    String query, {
    int limit = 20,
    int page = 1,
  });
  Future<List<WallpaperModel>> getSimilarWallpapers(
    String query, {
    int limit = 20,
    int page = 1,
  });
}

class SupabaseWallpaperDataSource implements WallpaperRemoteDataSource {
  final SupabaseClient _client;

  SupabaseWallpaperDataSource(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client
        .from(AppConstants.tableCategories)
        .select()
        .order('name');

    return (response as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<WallpaperModel>> getWallpapers({
    String? categoryId,
    int limit = 20,
  }) async {
    var query = _client.from(AppConstants.tableWallpapers).select();

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query
        .limit(limit)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => WallpaperModel.fromJson(json))
        .toList();
  }

  @override
  Future<WallpaperModel> getWallpaperById(String id) async {
    final response = await _client
        .from(AppConstants.tableWallpapers)
        .select()
        .eq('id', id)
        .single();

    return WallpaperModel.fromJson(response);
  }

  @override
  Future<List<WallpaperModel>> getExternalWallpapers(
    String query, {
    int limit = 20,
    int page = 1,
  }) async {
    try {
      // 1. Fetch Pexels API key from Supabase app_config
      final configResponse = await _client
          .from(AppConstants.tableAppConfig)
          .select()
          .eq('key_name', 'pexels_api_key')
          .single();

      final apiKey = configResponse['key_value'] as String?;
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Pexels API key is missing in app_config');
      }

      // 2. Call Pexels Search API
      final url = Uri.parse(
        '${AppConstants.pexelsSearchUrl}?query=$query&per_page=$limit&page=$page',
      );

      final response = await http.get(url, headers: {'Authorization': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? photos = data['photos'];

        if (photos == null) return [];

        return photos.map((photo) {
          final src = photo['src'] as Map<String, dynamic>;
          return WallpaperModel(
            id: 'pexels_${photo['id']}',
            title: photo['alt'] ?? 'Wallpaper',
            urlLowRes: src['large'] ?? src['medium'] ?? '',
            urlHighRes: src['original'] ?? src['large2x'] ?? '',
            sourceApi: 'pexels',
            createdAt: DateTime.now(),
            resolutions: src.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          );
        }).toList();
      } else {
        // Fallback or log error
        print('Pexels API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching external wallpapers: $e');
      return []; // Return empty list instead of throwing to avoid breaking the merge
    }
  }

  @override
  Future<List<WallpaperModel>> getSimilarWallpapers(
    String query, {
    int limit = 20,
    int page = 1,
  }) async {
    return getExternalWallpapers(query, limit: limit, page: page);
  }
}
