import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/legal/legal_content.dart';
import '../../l10n/ext.dart';
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
    final l = context.l10n;
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_agree) {
      setState(() => _error = l.loginErrorAgreeRequired);
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
      setState(() => _error = _messageFor(context, e.code));
    } catch (_) {
      setState(() => _error = l.loginErrorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final l = context.l10n;
    setState(() => _error = null);
    if (!_agree) {
      setState(() => _error = l.loginErrorAgreeRequired);
      return;
    }
    setState(() => _busy = true);
    try {
      await context.read<AppState>().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(context, e.code));
    } catch (_) {
      setState(() => _error = l.loginErrorGoogleFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgotPassword() async {
    final l = context.l10n;
    if (_email.text.trim().isEmpty) {
      setState(() => _error = l.loginErrorEnterEmail);
      return;
    }
    try {
      await context.read<AppState>().sendPasswordReset(email: _email.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.loginSnackResetSent)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.loginSnackResetFailed)),
        );
      }
    }
  }

  String _messageFor(BuildContext context, String code) {
    final l = context.l10n;
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l.loginErrorIncorrectCredentials;
      case 'user-disabled':
        return l.loginErrorUserDisabled;
      case 'email-already-in-use':
        return l.loginErrorEmailInUse;
      case 'invalid-email':
        return l.loginErrorInvalidEmail;
      case 'weak-password':
        return l.loginErrorWeakPassword;
      case 'operation-not-allowed':
        return l.loginErrorMethodNotAllowed;
      case 'too-many-requests':
        return l.loginErrorTooManyRequests;
      default:
        return l.loginErrorAuthFailed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
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
                      l.loginTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSignUp ? l.loginSubtitleCreate : l.loginSubtitleSignIn,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l.loginEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || !v.contains('@')) ? l.loginValidatorEmail : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l.loginPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6) ? l.loginValidatorPassword : null,
                    ),
                    if (!_isSignUp)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: Text(l.loginForgotPassword),
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
                          : Text(_isSignUp ? l.loginCreateAccount : l.loginSignIn),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(l.loginOr, style: theme.textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: Text(l.loginContinueWithGoogle),
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
                        _isSignUp ? l.loginSwitchToSignIn : l.loginSwitchToSignUp,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.loginPrivacyNotice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.4),
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
    final l = context.l10n;
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
                    TextSpan(text: l.loginConsentAgree),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: onTerms,
                        child: Text(
                          l.loginConsentTerms,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: l.loginConsentAnd),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: onPrivacy,
                        child: Text(
                          l.loginConsentPrivacy,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: l.loginConsentRequired),
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
