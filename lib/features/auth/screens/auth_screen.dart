import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';

/// Combined sign-in / sign-up / continue-as-guest screen backed by Supabase.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  String _mapAuthError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('invalid_credentials') || msg.contains('invalid login')) {
      return 'E-Mail oder Passwort ist falsch.';
    }
    if (msg.contains('email_not_confirmed') || msg.contains('not confirmed')) {
      return 'Bitte bestätige deine E-Mail-Adresse. Schau in deinen Posteingang.';
    }
    if (msg.contains('user_already_exists') ||
        msg.contains('already registered')) {
      return 'Diese E-Mail ist bereits registriert. Bitte einloggen.';
    }
    if (msg.contains('weak_password') || msg.contains('password')) {
      return 'Passwort zu schwach. Mindestens 8 Zeichen verwenden.';
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Keine Internetverbindung. Bitte versuche es erneut.';
    }
    if (msg.contains('rate') || msg.contains('too many')) {
      return 'Zu viele Versuche. Bitte warte einen Moment.';
    }
    return 'Fehler beim Anmelden. Bitte versuche es erneut.';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final sync = ref.read(supabaseSyncProvider);
    try {
      if (_isSignUp) {
        await sync.signUpEmail(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          username: _usernameCtrl.text.trim(),
        );
      } else {
        await sync.signInEmail(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
      }
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _error = _mapAuthError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(supabaseSyncProvider).signInWithGoogle();
      if (mounted) context.go('/home/lessons');
    } catch (e) {
      setState(() => _error = _mapAuthError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(supabaseSyncProvider).signInWithApple();
      if (mounted) context.go('/home/lessons');
    } catch (e) {
      setState(() => _error = _mapAuthError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final sync = ref.read(supabaseSyncProvider);
    try {
      await sync.signInAnonymously();
      if (mounted) context.go('/home');
    } catch (e) {
      // Anonymous auth might be disabled; fall back to local-only mode.
      if (mounted) context.go('/home');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailCtrl = TextEditingController(text: _emailCtrl.text.trim());
    String? dialogError;
    String? successMessage;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Passwort zurücksetzen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gib deine E-Mail-Adresse ein. Wir senden dir einen Link zum Zurücksetzen deines Passworts.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'E-Mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      dialogError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  if (successMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      successMessage!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: successMessage != null
                      ? null
                      : () async {
                          final email = emailCtrl.text.trim();
                          if (!email.contains('@') || !email.contains('.')) {
                            setDialogState(
                              () => dialogError =
                                  'Bitte eine gültige E-Mail eingeben.',
                            );
                            return;
                          }
                          try {
                            final sync = ref.read(supabaseSyncProvider);
                            await sync.auth.resetPasswordForEmail(email);
                            setDialogState(() {
                              dialogError = null;
                              successMessage =
                                  'E-Mail wurde gesendet. Prüfe deinen Posteingang.';
                            });
                          } catch (e) {
                            setDialogState(
                              () => dialogError =
                                  'Fehler beim Senden. Bitte versuche es erneut.',
                            );
                          }
                        },
                  child: const Text('Senden'),
                ),
              ],
            );
          },
        );
      },
    );

    emailCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.music_note,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'E-Gitarre Leicht',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSignUp
                        ? 'Erstelle dein Konto und sichere deinen Fortschritt.'
                        : 'Willkommen zurück! Melde dich an, um deinen Fortschritt zu laden.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Dismissible error banner
                  if (_error != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _error = null),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isSignUp)
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Benutzername',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  if (_isSignUp) const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'E-Mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Bitte E-Mail eingeben';
                      }
                      if (!v.contains('@') || !v.contains('.')) {
                        return 'Bitte eine gültige E-Mail eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Passwort',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Bitte Passwort eingeben';
                      }
                      if (v.length < 8) {
                        return 'Mindestens 8 Zeichen erforderlich';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _busy ? null : _showForgotPasswordDialog,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Passwort vergessen?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isSignUp ? 'Registrieren' : 'Anmelden'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'oder',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Mit Google anmelden'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (Theme.of(context).platform == TargetPlatform.iOS ||
                      Theme.of(context).platform == TargetPlatform.macOS)
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _signInWithApple,
                      icon: const Icon(Icons.apple, size: 24),
                      label: const Text('Mit Apple anmelden'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _isSignUp = !_isSignUp;
                              _error = null;
                            }),
                    child: Text(
                      _isSignUp
                          ? 'Schon ein Konto? Anmelden'
                          : 'Noch kein Konto? Registrieren',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _continueAsGuest,
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Als Gast fortfahren'),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Im Gast-Modus wird dein Fortschritt nur lokal gespeichert.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
