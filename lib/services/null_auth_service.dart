import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

/// Non-Firebase [AuthService] used in tests. Always reports signed out and
/// never touches any network or authentication backend.
class NullAuthService implements AuthService {
  @override
  bool get initialized => true;

  @override
  User? get currentUser => null;

  @override
  Stream<User?> get userChanges => const Stream.empty();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    throw UnimplementedError('Not used in tests.');
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password}) async {
    throw UnimplementedError('Not used in tests.');
  }

  @override
  Future<void> signInWithGoogle() async {
    throw UnimplementedError('Not used in tests.');
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    throw UnimplementedError('Not used in tests.');
  }

  @override
  Future<void> signOut() async {}
}
