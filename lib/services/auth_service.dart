import 'package:firebase_auth/firebase_auth.dart';

/// Minimal auth contract used by [AppState].
///
/// Kept abstract so the app can be exercised in tests with a local/null
/// implementation that never touches Firebase.
abstract class AuthService {
  /// Emits the signed-in user, or `null` when signed out. Fires immediately
  /// with the current state once initialized.
  Stream<User?> get userChanges;

  /// The currently signed-in user, or `null`.
  User? get currentUser;

  /// True once authentication state has been established.
  bool get initialized;

  /// Initializes the auth backend. Safe to call more than once.
  Future<void> initialize();

  Future<void> signUpWithEmail({required String email, required String password});
  Future<void> signInWithEmail({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> sendPasswordReset({required String email});
  Future<void> signOut();
}
