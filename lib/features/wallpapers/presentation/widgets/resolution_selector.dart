import 'package:flutter/material.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:gap/gap.dart';

class ResolutionSelector extends StatelessWidget {
  final Map<String, String> resolutions;
  final bool isPremiumUser;
  final Function(String key, String url) onSelected;

  const ResolutionSelector({
    super.key,
    required this.resolutions,
    required this.isPremiumUser,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get actual dimensions
    final int photoWidth = int.tryParse(resolutions['_width'] ?? '0') ?? 0;
    final int photoHeight = int.tryParse(resolutions['_height'] ?? '0') ?? 0;

    // Build option list with actual resolutions
    final List<_ResOption> options = [];

    if (resolutions.containsKey('original') && photoWidth > 0) {
      options.add(
        _ResOption(
          key: 'original',
          label: 'Original',
          resolution: '${photoWidth}x$photoHeight',
          url: resolutions['original']!,
          isPremium: photoWidth >= 3840 || photoHeight >= 3840,
        ),
      );
    }

    if (resolutions.containsKey('large2x')) {
      final w = (photoWidth * 0.75).round();
      final h = (photoHeight * 0.75).round();
      options.add(
        _ResOption(
          key: 'large2x',
          label: 'High',
          resolution: '${w}x$h',
          url: resolutions['large2x']!,
          isPremium: false,
        ),
      );
    }

    if (resolutions.containsKey('large')) {
      options.add(
        _ResOption(
          key: 'large',
          label: 'Medium',
          resolution: '940x650',
          url: resolutions['large']!,
          isPremium: false,
        ),
      );
    }

    if (resolutions.containsKey('medium')) {
      options.add(
        _ResOption(
          key: 'medium',
          label: 'Standard',
          resolution: '350x350',
          url: resolutions['medium']!,
          isPremium: false,
        ),
      );
    }

    // If we have no computed options, fallback
    if (options.isEmpty && resolutions.isNotEmpty) {
      final firstKey = resolutions.keys.firstWhere(
        (k) => !k.startsWith('_'),
        orElse: () => resolutions.keys.first,
      );
      options.add(
        _ResOption(
          key: firstKey,
          label: 'Default',
          resolution: '',
          url: resolutions[firstKey]!,
          isPremium: false,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(16),
          const Text(
            'Download Quality',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...options.map((opt) {
            final isLocked = opt.isPremium && !isPremiumUser;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: isLocked ? null : () => onSelected(opt.key, opt.url),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isLocked
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLocked ? Icons.lock_outline : Icons.download_rounded,
                        color: isLocked ? Colors.white24 : Colors.white70,
                        size: 20,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt.label,
                              style: TextStyle(
                                color: isLocked ? Colors.white38 : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (opt.resolution.isNotEmpty)
                              Text(
                                opt.resolution,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '4K PRO',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.white24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ResOption {
  final String key;
  final String label;
  final String resolution;
  final String url;
  final bool isPremium;

  _ResOption({
    required this.key,
    required this.label,
    required this.resolution,
    required this.url,
    required this.isPremium,
  });
}
