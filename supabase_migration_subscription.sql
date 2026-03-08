-- ============================================================
-- SUBSCRIPTION TABLES MIGRATION
-- Run this in your Supabase SQL Editor:
-- https://supabase.com/dashboard/project/feycrgmmimlmrnfxafmb/sql
-- ============================================================

-- Subscription plans table (admin-configurable pricing)
CREATE TABLE IF NOT EXISTS public.subscription_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price_inr NUMERIC(10,2) NOT NULL,
  duration_days INTEGER NOT NULL, -- 0 = lifetime
  play_store_product_id TEXT NOT NULL UNIQUE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- User subscriptions table
CREATE TABLE IF NOT EXISTS public.user_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES public.subscription_plans(id),
  purchase_token TEXT,
  starts_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  ends_at TIMESTAMPTZ, -- NULL = lifetime
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_subscriptions ENABLE ROW LEVEL SECURITY;

-- Plans: anyone can read active plans
CREATE POLICY "Anyone can read active plans"
  ON public.subscription_plans FOR SELECT
  USING (is_active = true);

-- User subscriptions: users can read their own
CREATE POLICY "Users can read own subscriptions"
  ON public.user_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- User subscriptions: users can insert their own
CREATE POLICY "Users can insert own subscriptions"
  ON public.user_subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Seed 4 subscription plans (admin can update prices later)
INSERT INTO public.subscription_plans (name, description, price_inr, duration_days, play_store_product_id) VALUES
  ('3 Months Premium', 'Access all premium wallpapers for 3 months', 20.00, 90, 'premium_3months'),
  ('6 Months Premium', 'Access all premium wallpapers for 6 months', 35.00, 180, 'premium_6months'),
  ('1 Year Premium', 'Access all premium wallpapers for 1 year', 60.00, 365, 'premium_1year'),
  ('Lifetime Premium', 'Lifetime access to all premium wallpapers', 99.00, 0, 'premium_lifetime');
