import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:smart_wallpaper/features/wallpapers/domain/usecases/search_external_wallpapers.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/wallpaper_detail_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:gap/gap.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<WallpaperEntity> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _performSearch(query.trim());
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _currentPage = 1;
      _hasMore = true;
      _lastQuery = query;
      _results = [];
    });

    final useCase = sl<SearchExternalWallpapers>();
    final result = await useCase.execute(query, page: 1);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _results = [];
        });
      },
      (wallpapers) {
        setState(() {
          _isLoading = false;
          _results = wallpapers;
          _hasMore = wallpapers.length >= 20;
        });
      },
    );
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoading || _lastQuery.isEmpty) return;

    _currentPage++;
    final useCase = sl<SearchExternalWallpapers>();
    final result = await useCase.execute(_lastQuery, page: _currentPage);

    if (!mounted) return;

    result.fold((failure) => _hasMore = false, (wallpapers) {
      setState(() {
        _results.addAll(wallpapers);
        _hasMore = wallpapers.length >= 20;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search wallpapers...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withOpacity(0.3),
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _results = [];
                                      _hasSearched = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white.withOpacity(0.3),
                                    size: 18,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _results.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
          strokeWidth: 2,
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 56,
              color: Colors.white.withOpacity(0.15),
            ),
            const Gap(12),
            Text(
              'Search for wallpapers',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 56,
              color: Colors.white.withOpacity(0.15),
            ),
            const Gap(12),
            Text(
              'No wallpapers found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        // Prefetch: trigger 3 items before end
        if (index >= _results.length - 3) {
          _loadMore();
        }

        final wallpaper = _results[index];
        return WallpaperCard(
          wallpaper: wallpaper,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WallpaperDetailScreen(
                  wallpapers: _results,
                  initialIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
