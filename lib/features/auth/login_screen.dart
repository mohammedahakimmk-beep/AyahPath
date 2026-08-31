import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/legal/legal_content.dart';
import '../../services/app_state.dart';
import 'legal_screen.dart';

/// Authentication gate shown before the app can be used.
///
/// Requires the user to be signed in (email/password or Google) and to accept
/// the Terms of Service and Privacy Policy before signing in or creating an
/// account. The consent checkbox must be ticked for both actions.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isSignUp = false;
  bool _agree = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_agree) {
      setState(() => _error =
          'Please accept the Terms of Service and Privacy Policy to continue.');
      return;
    }

    setState(() => _busy = true);
    try {
      final app = context.read<AppState>();
      if (_isSignUp) {
        await app.signUpWithEmail(email: _email.text.trim(), password: _password.text);
      } else {
        await app.signInWithEmail(email: _email.text.trim(), password: _password.text);
      }
      // Auth success switches the app into the main flow automatically.
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    } catch (_) {
      setState(() => _error =
          'Something went wrong. Please check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _error = null);
    if (!_agree) {
      setState(() => _error =
          'Please accept the Terms of Service and Privacy Policy to continue.');
      return;
    }
    setState(() => _busy = true);
    try {
      await context.read<AppState>().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    } catch (_) {
      setState(() => _error =
          'Google sign-in failed. Please check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty) {
      setState(() => _error = 'Enter your email address first.');
      return;
    }
    try {
      await context.read<AppState>().sendPasswordReset(email: _email.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent if that account exists.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not send a reset email. Please try again.')),
        );
      }
    }
  }

  String _messageFor(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.menu_book_rounded, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'AyahPath',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSignUp ? 'Create your account' : 'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'At least 6 characters' : null,
                    ),
                    if (!_isSignUp)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: const Text('Forgot password?'),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _ConsentBox(
                      agreed: _agree,
                      onChanged: (v) => setState(() => _agree = v),
                      onTerms: () => _pushLegal(termsOfService),
                      onPrivacy: () => _pushLegal(privacyPolicy),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _busy
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(_isSignUp ? 'Create account' : 'Sign in'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR', style: theme.textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() {
                        _isSignUp = !_isSignUp;
                        _error = null;
                      }),
                      child: Text(
                        _isSignUp
                            ? 'Already have an account? Sign in'
                            : 'New here? Create an account',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your recitation audio is analyzed on-device. Account data (profile & progress) is stored securely online for syncing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pushLegal(LegalDocument doc) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LegalScreen(document: doc)));
  }
}

class _ConsentBox extends StatelessWidget {
  const _ConsentBox({
    required this.agreed,
    required this.onChanged,
    required this.onTerms,
    required this.onPrivacy,
  });

  final bool agreed;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: agreed, onChanged: (v) => onChanged(v ?? false)),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: onTerms,
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: onPrivacy,
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' required to use AyahPath.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
