import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() {
    // Check if user is currently logged in
    final session = Supabase.instance.client.auth.currentSession;

    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      state = data.session != null;
    });

    return session != null;
  }

  /// Sign in with Google via native flow
  /// Returns null on success, error message string on failure
  Future<String?> signInWithGoogle() async {
    try {
      // Use the Web Client ID from Google Cloud Console
      // This is the one configured in Supabase Dashboard
      const webClientId =
          '490085072807-hv3jagjb03v2mpi13oihpf65ia666mih.apps.googleusercontent.com'; // TODO: Replace with actual Web Client ID

      final googleSignIn = GoogleSignIn(serverClientId: webClientId);

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return 'Sign in cancelled';
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return 'Could not get authentication token';
      }

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      state = true;
      return null; // Success
    } catch (e) {
      print('Google Sign-In error: $e');
      return 'Sign in failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await Supabase.instance.client.auth.signOut();
      state = false;
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  /// Deletes the user's account via a Supabase Edge Function
  /// Returns null on success, error message string on failure
  Future<String?> deleteAccount() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) return 'Not authenticated';

      final response = await Supabase.instance.client.functions.invoke(
        'delete-user',
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      if (response.status != 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['error'] ?? 'Failed to delete account';
      }

      // Sign out locally after deletion
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      state = false;
      return null; // Success
    } catch (e) {
      print('Delete account error: $e');
      return 'Failed to delete account. Please try again.';
    }
  }
}
