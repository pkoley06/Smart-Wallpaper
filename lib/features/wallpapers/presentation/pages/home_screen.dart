import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/wallpaper_detail_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/search_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/auth_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/subscription_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/category_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/wallpaper_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedCategoryId;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String? id) {
    setState(() => selectedCategoryId = id);
    // Scroll grid to top when switching category
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final wallpapersAsync = ref.watch(
      wallpaperNotifierProvider(categoryId: selectedCategoryId),
    );

    return Scaffold(
      body: Column(
        children: [
          // Compact frosted AppBar
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: AppTheme.surfaceColor.withOpacity(0.6),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Vista',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.search_rounded, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Gap(4),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.workspace_premium,
                            size: 22,
                            color: Color(0xFFFFD700),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFD700,
                            ).withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Gap(4),
                        _buildProfileAvatar(context, ref),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Sticky category tabs
          Container(
            color: AppTheme.backgroundColor,
            child: categoriesAsync.when(
              data: (categories) => SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => const Gap(6),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildChip(
                        'All',
                        selectedCategoryId == null,
                        () => _onCategoryTap(null),
                      );
                    }
                    final category = categories[index - 1];
                    return _buildChip(
                      category.name,
                      selectedCategoryId == category.id,
                      () => _onCategoryTap(category.id),
                    );
                  },
                ),
              ),
              loading: () => const SizedBox(height: 44),
              error: (_, __) => const SizedBox(height: 44),
            ),
          ),

          // Wallpaper grid
          Expanded(
            child: wallpapersAsync.when(
              data: (wallpapers) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 600) {
                      ref
                          .read(
                            wallpaperNotifierProvider(
                              categoryId: selectedCategoryId,
                            ).notifier,
                          )
                          .loadMore();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(6),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.65,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                    itemCount: wallpapers.length,
                    itemBuilder: (context, index) {
                      // Prefetch: trigger loadMore when 3 items from end
                      if (index >= wallpapers.length - 3) {
                        ref
                            .read(
                              wallpaperNotifierProvider(
                                categoryId: selectedCategoryId,
                              ).notifier,
                            )
                            .loadMore();
                      }

                      final wallpaper = wallpapers[index];
                      return WallpaperCard(
                        wallpaper: wallpaper,
                        onTap: () {
                          Navigator.push(
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
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  strokeWidth: 2,
                ),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white38,
                      size: 48,
                    ),
                    const Gap(12),
                    Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.white54),
                    ),
                    const Gap(8),
                    TextButton(
                      onPressed: () => ref.invalidate(
                        wallpaperNotifierProvider(
                          categoryId: selectedCategoryId,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppTheme.surfaceColor,
      onSelected: (value) async {
        if (value == 'signout') {
          await ref.read(authNotifierProvider.notifier).signOut();
        } else if (value == 'delete') {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirmed == true && context.mounted) {
            final error = await ref
                .read(authNotifierProvider.notifier)
                .deleteAccount();
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          }
        } else if (value == 'premium') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.userMetadata?['full_name'] ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'premium',
          child: Row(
            children: [
              Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 18),
              Gap(8),
              Text('Premium', style: TextStyle(color: Color(0xFFFFD700))),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red, size: 18),
              Gap(8),
              Text('Delete Account', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent, size: 18),
              Gap(8),
              Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white.withOpacity(0.08),
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null
            ? const Icon(Icons.person, color: Colors.white54, size: 18)
            : null,
      ),
    );
  }
}
