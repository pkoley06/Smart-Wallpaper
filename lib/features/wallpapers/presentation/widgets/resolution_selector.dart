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
    // Pexels resolution order preference
    final order = [
      'original',
      'large2x',
      'large',
      'medium',
      'small',
      'portrait',
      'landscape',
      'tiny',
    ];
    final sortedKeys = resolutions.keys.toList()
      ..sort((a, b) {
        final indexA = order.indexOf(a);
        final indexB = order.indexOf(b);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Resolution',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sortedKeys.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (context, index) {
                final key = sortedKeys[index];
                final url = resolutions[key]!;
                final isHighQuality = key == 'original' || key == 'large2x';
                final isLocked = isHighQuality && !isPremiumUser;

                String titleText;
                switch (key) {
                  case 'original':
                    titleText = 'Original (Highest Quality)';
                    break;
                  case 'large2x':
                    titleText = 'Large 2x (4K/QHD)';
                    break;
                  case 'large':
                    titleText = 'Large (FHD+)';
                    break;
                  case 'medium':
                    titleText = 'Medium (HD)';
                    break;
                  case 'portrait':
                    titleText = 'Portrait HD';
                    break;
                  case 'landscape':
                    titleText = 'Landscape HD';
                    break;
                  default:
                    titleText = key.toUpperCase();
                }

                return ListTile(
                  onTap: isLocked ? null : () => onSelected(key, url),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: isLocked ? Colors.white10 : Colors.white24,
                    ),
                  ),
                  leading: Icon(
                    isLocked ? Icons.lock_outline : Icons.image_outlined,
                    color: isLocked ? Colors.redAccent : Colors.white70,
                  ),
                  title: Text(
                    titleText,
                    style: TextStyle(
                      color: isLocked ? Colors.white38 : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: isLocked
                      ? const Text(
                          'PREMIUM',
                          style: TextStyle(color: Colors.amber, fontSize: 10),
                        )
                      : const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.white30,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
