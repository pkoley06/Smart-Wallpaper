import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/wallpaper_detail_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/similar_wallpaper_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:gap/gap.dart';

class SimilarWallpapersList extends ConsumerStatefulWidget {
  final String wallpaperId;
  final String? tags;

  const SimilarWallpapersList({
    super.key,
    required this.wallpaperId,
    this.tags,
  });

  @override
  ConsumerState<SimilarWallpapersList> createState() =>
      _SimilarWallpapersListState();
}

class _SimilarWallpapersListState extends ConsumerState<SimilarWallpapersList> {
  @override
  Widget build(BuildContext context) {
    final similarAsync = ref.watch(
      similarWallpapersNotifierProvider(widget.wallpaperId, tags: widget.tags),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Wallpapers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        similarAsync.when(
          data: (wallpapers) {
            if (wallpapers.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'No similar wallpapers found.',
                  style: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
              );
            }

            final notifier = ref.read(
              similarWallpapersNotifierProvider(
                widget.wallpaperId,
                tags: widget.tags,
              ).notifier,
            );

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                // Prefetch: trigger 3 items before end
                if (index >= wallpapers.length - 3 && notifier.hasMore) {
                  notifier.loadMore();
                }

                final wallpaper = wallpapers[index];
                return WallpaperCard(
                  wallpaper: wallpaper,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WallpaperDetailScreen(
                          wallpapers: wallpapers,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          error: (err, stack) => Text(
            'Could not load similar wallpapers.',
            style: TextStyle(color: Colors.white.withOpacity(0.3)),
          ),
        ),
      ],
    );
  }
}
