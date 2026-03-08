import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Model for a subscription plan from Supabase
class SubscriptionPlan {
  final String id;
  final String name;
  final String? description;
  final double priceInr;
  final int durationDays; // 0 = lifetime
  final String playStoreProductId;

  SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.priceInr,
    required this.durationDays,
    required this.playStoreProductId,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlan(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      priceInr: (map['price_inr'] as num).toDouble(),
      durationDays: map['duration_days'] as int,
      playStoreProductId: map['play_store_product_id'] as String,
    );
  }

  String get durationLabel {
    if (durationDays == 0) return 'Lifetime';
    if (durationDays <= 90) return '3 Months';
    if (durationDays <= 180) return '6 Months';
    if (durationDays <= 365) return '1 Year';
    return '$durationDays Days';
  }
}

/// Model for user's active subscription
class UserSubscription {
  final String id;
  final String planId;
  final DateTime startsAt;
  final DateTime? endsAt; // null = lifetime
  final bool isActive;

  UserSubscription({
    required this.id,
    required this.planId,
    required this.startsAt,
    this.endsAt,
    required this.isActive,
  });

  factory UserSubscription.fromMap(Map<String, dynamic> map) {
    return UserSubscription(
      id: map['id'] as String,
      planId: map['plan_id'] as String,
      startsAt: DateTime.parse(map['starts_at'] as String),
      endsAt: map['ends_at'] != null
          ? DateTime.parse(map['ends_at'] as String)
          : null,
      isActive: map['is_active'] as bool,
    );
  }

  bool get isExpired {
    if (endsAt == null) return false; // lifetime never expires
    return DateTime.now().isAfter(endsAt!);
  }

  bool get isCurrentlyActive => isActive && !isExpired;
}

/// Subscription state
class SubscriptionState {
  final List<SubscriptionPlan> plans;
  final UserSubscription? activeSubscription;
  final Map<String, ProductDetails> storeProducts;
  final bool isLoading;
  final String? error;

  const SubscriptionState({
    this.plans = const [],
    this.activeSubscription,
    this.storeProducts = const {},
    this.isLoading = false,
    this.error,
  });

  bool get isPremium => activeSubscription?.isCurrentlyActive ?? false;

  SubscriptionState copyWith({
    List<SubscriptionPlan>? plans,
    UserSubscription? activeSubscription,
    Map<String, ProductDetails>? storeProducts,
    bool? isLoading,
    String? error,
    bool clearSubscription = false,
  }) {
    return SubscriptionState(
      plans: plans ?? this.plans,
      activeSubscription: clearSubscription
          ? null
          : (activeSubscription ?? this.activeSubscription),
      storeProducts: storeProducts ?? this.storeProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Riverpod provider for subscription management
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) => SubscriptionNotifier(),
    );

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  final _iap = InAppPurchase.instance;

  SubscriptionNotifier() : super(const SubscriptionState()) {
    _init();
  }

  Future<void> _init() async {
    await loadPlans();
    await checkSubscription();
    _listenToPurchases();
  }

  void _listenToPurchases() {
    _purchaseSubscription = _iap.purchaseStream.listen(
      (purchaseDetailsList) {
        for (final purchase in purchaseDetailsList) {
          _handlePurchase(purchase);
        }
      },
      onError: (error) {
        print('Purchase stream error: $error');
      },
    );
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      // Find the plan by product ID
      final plan = state.plans.firstWhere(
        (p) => p.playStoreProductId == purchase.productID,
        orElse: () => state.plans.first,
      );

      // Activate subscription in Supabase
      await _activateSubscription(
        purchaseToken: purchase.verificationData.serverVerificationData,
        plan: plan,
      );

      // Complete the purchase
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    } else if (purchase.status == PurchaseStatus.error) {
      state = state.copyWith(error: 'Purchase failed. Please try again.');
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Load subscription plans from Supabase
  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await Supabase.instance.client
          .from('subscription_plans')
          .select()
          .eq('is_active', true)
          .order('duration_days', ascending: true);

      final plans = (response as List)
          .map((e) => SubscriptionPlan.fromMap(e))
          .toList();

      // Fetch dynamic products from Google Play
      Map<String, ProductDetails> storeProducts = {};
      final isAvailable = await _iap.isAvailable();
      if (isAvailable && plans.isNotEmpty) {
        final productIds = plans.map((e) => e.playStoreProductId).toSet();
        print('Querying Google Play for products: $productIds');
        final playResponse = await _iap.queryProductDetails(productIds);

        if (playResponse.error != null) {
          print('Google Play Query Error: ${playResponse.error!.message}');
        }

        for (var product in playResponse.productDetails) {
          print(
            'Found Product: ${product.id} -> Raw Price: ${product.price} | Title: ${product.title}',
          );
          storeProducts[product.id] = product;
        }

        if (playResponse.notFoundIDs.isNotEmpty) {
          print(
            'Products NOT FOUND in Play Console: ${playResponse.notFoundIDs}',
          );
        }
      }

      state = state.copyWith(
        plans: plans,
        storeProducts: storeProducts,
        isLoading: false,
      );
    } catch (e) {
      print('Error loading plans: $e');
      state = state.copyWith(isLoading: false, error: 'Failed to load plans');
    }
  }

  /// Check user's current subscription status
  Future<void> checkSubscription() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await Supabase.instance.client
          .from('user_subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('ends_at', ascending: false)
          .limit(1);

      if ((response as List).isNotEmpty) {
        final sub = UserSubscription.fromMap(response.first);
        if (sub.isCurrentlyActive) {
          state = state.copyWith(activeSubscription: sub);
        } else {
          state = state.copyWith(clearSubscription: true);
        }
      } else {
        state = state.copyWith(clearSubscription: true);
      }
    } catch (e) {
      print('Error checking subscription: $e');
    }
  }

  /// Initiate a purchase via Google Play
  Future<void> purchasePlan(SubscriptionPlan plan) async {
    state = state.copyWith(isLoading: true, error: null);

    final available = await _iap.isAvailable();
    if (!available) {
      state = state.copyWith(
        isLoading: false,
        error: 'In-app purchases are not available on this device.',
      );
      return;
    }

    final productIds = {plan.playStoreProductId};
    final response = await _iap.queryProductDetails(productIds);

    if (response.productDetails.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Product not found. Please try again later.',
      );
      return;
    }

    final productDetails = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    // Use buyNonConsumable for subscription-like products
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    state = state.copyWith(isLoading: false);
  }

  /// Activate subscription in Supabase after successful purchase
  Future<void> _activateSubscription({
    required String purchaseToken,
    required SubscriptionPlan plan,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final now = DateTime.now();
      final endsAt = plan.durationDays == 0
          ? null // lifetime
          : now.add(Duration(days: plan.durationDays));

      await Supabase.instance.client.from('user_subscriptions').insert({
        'user_id': userId,
        'plan_id': plan.id,
        'purchase_token': purchaseToken,
        'starts_at': now.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
        'is_active': true,
      });

      await checkSubscription();
    } catch (e) {
      print('Error activating subscription: $e');
      state = state.copyWith(error: 'Failed to activate subscription');
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
