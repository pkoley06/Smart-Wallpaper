import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/subscription_provider.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Premium',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: subState.isLoading && subState.plans.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 2,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active subscription banner
                  if (subState.isPremium) ...[
                    _buildActiveSubscriptionBanner(
                      subState.activeSubscription!,
                    ),
                    const Gap(24),
                  ],

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const Gap(16),
                        const Text(
                          'Unlock Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Download & set premium wallpapers\nin stunning quality',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),

                  // Features list
                  _buildFeatureItem(
                    Icons.download_rounded,
                    'Download premium wallpapers',
                  ),
                  const Gap(10),
                  _buildFeatureItem(
                    Icons.wallpaper_rounded,
                    'Set premium wallpapers',
                  ),
                  const Gap(10),
                  _buildFeatureItem(
                    Icons.hd_rounded,
                    '4K & original resolution access',
                  ),
                  const Gap(10),
                  _buildFeatureItem(
                    Icons.star_rounded,
                    'Exclusive AI-generated collection',
                  ),
                  const Gap(32),

                  // Plan cards
                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(16),

                  if (subState.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 18,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              subState.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                  ],

                  ...subState.plans.map(
                    (plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPlanCard(
                        context,
                        ref,
                        plan,
                        isCurrentPlan:
                            subState.activeSubscription?.planId == plan.id,
                        isPremium: subState.isPremium,
                        isLoading: subState.isLoading,
                      ),
                    ),
                  ),

                  const Gap(20),
                  Center(
                    child: Text(
                      'Subscriptions are one-time purchases.\nPricing may change at the admin\'s discretion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.25),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
    );
  }

  Widget _buildActiveSubscriptionBanner(UserSubscription sub) {
    final endDate = sub.endsAt;
    final isLifetime = endDate == null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1B69), Color(0xFF1A1040)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Color(0xFFFFD700),
              size: 22,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Active',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Gap(2),
                Text(
                  isLifetime
                      ? 'Lifetime access — never expires'
                      : 'Expires on ${DateFormat('dd MMM yyyy').format(endDate)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 16),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref,
    SubscriptionPlan plan, {
    required bool isCurrentPlan,
    required bool isPremium,
    required bool isLoading,
  }) {
    final isLifetime = plan.durationDays == 0;
    final isBestValue =
        plan.durationDays == 365; // Highlight 1 year as best value

    return GestureDetector(
      onTap: (isPremium || isLoading)
          ? null
          : () => ref.read(subscriptionProvider.notifier).purchasePlan(plan),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrentPlan
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentPlan
                ? AppTheme.primaryColor.withOpacity(0.4)
                : isBestValue
                ? const Color(0xFFFFD700).withOpacity(0.3)
                : Colors.white.withOpacity(0.08),
            width: isBestValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Duration icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isLifetime
                    ? const Color(0xFFFFD700).withOpacity(0.12)
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isLifetime ? Icons.all_inclusive : Icons.calendar_today_rounded,
                color: isLifetime
                    ? const Color(0xFFFFD700)
                    : AppTheme.primaryColor,
                size: 22,
              ),
            ),
            const Gap(14),

            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.durationLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (isBestValue) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'BEST VALUE',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(2),
                  Text(
                    plan.description ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ref
                          .read(subscriptionProvider)
                          .storeProducts[plan.playStoreProductId]
                          ?.price ??
                      '₹${plan.priceInr.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isCurrentPlan ? AppTheme.primaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (isCurrentPlan)
                  const Text(
                    'Active',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (!isPremium)
                  Text(
                    'Buy',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
