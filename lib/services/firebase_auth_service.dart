import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

/// Firebase Authentication backed [AuthService] (email/password + Google).
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  bool _initialized = false;
  bool _googleReady = false;

  @override
  bool get initialized => _initialized;

  @override
  Stream<User?> get userChanges => _auth.userChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> initialize() async {
    if (!_googleReady) {
      try {
        // Initialize Google Sign-In once. On Android, the OAuth client is
        // resolved from google-services.json automatically. Errors here are
        // non-fatal: email/password still works and the Google button reports
        // failures on use.
        await GoogleSignIn.instance.initialize();
        _googleReady = true;
      } catch (_) {
        _googleReady = false;
      }
    }
    _initialized = true;
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() async {
    final account = await GoogleSignIn.instance.authenticate();
    final auth = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Ignore: the Google session may not have been initialized.
    }
  }
}
