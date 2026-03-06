import 'package:flutter/material.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/services/wallpaper_action_service.dart';
import 'package:gap/gap.dart';

class SetWallpaperDialog extends StatelessWidget {
  final Function(WallpaperLocation location) onSelected;

  const SetWallpaperDialog({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wallpaper, size: 50, color: AppTheme.primaryColor),
            const Gap(20),
            const Text(
              'Set as Wallpaper',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(30),
            _buildOption(
              context,
              icon: Icons.home_outlined,
              label: 'Home Screen',
              onTap: () => onSelected(WallpaperLocation.home),
            ),
            const Gap(12),
            _buildOption(
              context,
              icon: Icons.lock_outline,
              label: 'Lock Screen',
              onTap: () => onSelected(WallpaperLocation.lock),
            ),
            const Gap(12),
            _buildOption(
              context,
              icon: Icons.phonelink_setup,
              label: 'Both Screens',
              onTap: () => onSelected(WallpaperLocation.both),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.white12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const Gap(15),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
