import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/auth_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/services/wallpaper_action_service.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/resolution_selector.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/set_wallpaper_dialog.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/similar_wallpapers_list.dart';
import 'package:gap/gap.dart';

class WallpaperDetailScreen extends ConsumerStatefulWidget {
  final List<WallpaperEntity> wallpapers;
  final int initialIndex;

  const WallpaperDetailScreen({
    super.key,
    required this.wallpapers,
    required this.initialIndex,
  });

  @override
  ConsumerState<WallpaperDetailScreen> createState() =>
      _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends ConsumerState<WallpaperDetailScreen> {
  late PageController _pageController;
  bool _showOverlay = true;
  bool _isLoading = false;
  String _loadingMessage = '';
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  void _setLoading(bool loading, [String message = '']) {
    setState(() {
      _isLoading = loading;
      _loadingMessage = message;
    });
  }

  WallpaperEntity get _currentWallpaper => widget.wallpapers[_currentIndex];

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(authNotifierProvider);
    final actionService = sl<WallpaperActionService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // [LAYER 1] Full-screen PageView — handles horizontal swiping
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.wallpapers.length,
            itemBuilder: (context, index) {
              final wallpaper = widget.wallpapers[index];
              return CachedNetworkImage(
                imageUrl: wallpaper.urlHighRes,
                fit: BoxFit.cover,
                placeholder: (context, url) => CachedNetworkImage(
                  imageUrl: wallpaper.urlLowRes,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          // [LAYER 2] Tap detector — transparent, doesn't block PageView swipes
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // [LAYER 3] Bottom gradient overlay
          AnimatedOpacity(
            opacity: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.15, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // [LAYER 4] Bottom sheet with actions + similar wallpapers
          AnimatedSlide(
            offset: _showOverlay ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: DraggableScrollableSheet(
              initialChildSize: 0.42,
              minChildSize: 0.42,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const Gap(16),

                      // Premium badge
                      if (_currentWallpaper.isPremium) ...[
                        _buildPremiumBadge(),
                        const Gap(12),
                      ],

                      // Pexels branding
                      if (_currentWallpaper.id.startsWith('pexels_')) ...[
                        Image.network(
                          'https://images.pexels.com/lib/api/pexels-white.png',
                          width: 70,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                        const Gap(16),
                      ],

                      // Action buttons
                      _buildActionButtons(
                        context,
                        ref,
                        actionService,
                        isPremium,
                        _currentWallpaper,
                      ),
                      const Gap(30),

                      // Similar wallpapers
                      SimilarWallpapersList(
                        wallpaperId: _currentWallpaper.id,
                        tags: _currentWallpaper.title,
                      ),
                      const Gap(30),
                    ],
                  ),
                );
              },
            ),
          ),

          // [LAYER 5] Back button
          AnimatedOpacity(
            opacity: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_showOverlay,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // [LAYER 6] Page indicator dots
          AnimatedOpacity(
            opacity: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.wallpapers.length}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // [LAYER 7] Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      _loadingMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.white, size: 14),
            Gap(6),
            Text(
              'PREMIUM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    WallpaperActionService actionService,
    bool isPremium,
    WallpaperEntity currentWallpaper,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () => _showResolutionSelector(
              context,
              isPremium,
              actionService,
              currentWallpaper,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded, size: 20),
                Gap(8),
                Text(
                  'Download',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showSetWallpaperDialog(
              context,
              actionService,
              currentWallpaper,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.white.withOpacity(0.15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Icon(Icons.wallpaper_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  void _showResolutionSelector(
    BuildContext context,
    bool isPremium,
    WallpaperActionService service,
    WallpaperEntity currentWallpaper,
  ) {
    if (currentWallpaper.resolutions == null) {
      _performDownload(service, currentWallpaper.urlHighRes);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => ResolutionSelector(
        resolutions: currentWallpaper.resolutions!,
        isPremiumUser: isPremium,
        onSelected: (key, url) {
          Navigator.pop(bottomSheetContext);
          _performDownload(service, url);
        },
      ),
    );
  }

  Future<void> _performDownload(
    WallpaperActionService service,
    String url,
  ) async {
    _setLoading(true, 'Downloading wallpaper...');
    final errorMsg = await service.downloadToGallery(url);
    _setLoading(false);
    if (!mounted) return;
    if (errorMsg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallpaper saved to gallery!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  void _showSetWallpaperDialog(
    BuildContext context,
    WallpaperActionService service,
    WallpaperEntity currentWallpaper,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => SetWallpaperDialog(
        onSelected: (location) async {
          Navigator.pop(dialogContext);
          String locationName;
          switch (location) {
            case WallpaperLocation.home:
              locationName = 'home screen';
              break;
            case WallpaperLocation.lock:
              locationName = 'lock screen';
              break;
            case WallpaperLocation.both:
              locationName = 'both screens';
              break;
          }
          _setLoading(true, 'Setting as $locationName...');
          final errorMsg = await service.setWallpaper(
            url: currentWallpaper.urlHighRes,
            location: location,
          );
          _setLoading(false);
          if (!mounted) return;
          if (errorMsg == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wallpaper applied successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
            );
          }
        },
      ),
    );
  }
}
