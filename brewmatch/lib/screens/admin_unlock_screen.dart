import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/state/app_state.dart';
import 'admin/admin_dashboard_screen.dart';

/// Screen to unlock the admin experience with a local passcode.
/// TODO: Replace with secure authentication (Firebase Auth / backend validation).
class AdminUnlockScreen extends StatefulWidget {
  static const routeName = '/admin/unlock';

  const AdminUnlockScreen({super.key});

  @override
  State<AdminUnlockScreen> createState() => _AdminUnlockScreenState();
}

class _AdminUnlockScreenState extends State<AdminUnlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Débloquer l’espace admin'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Auth login',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('Saisis le code temporaire "BREW2025" pour accéder à l''interface de gestion.'),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passController,
                      decoration: const InputDecoration(
                        labelText: 'Passcode admin',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Merci d’entrer le code.';
                        }
                        return null;
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _isSubmitting ? null : () => _unlock(context),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Déverrouiller'),
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

  Future<void> _unlock(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final appState = AppStateScope.of(context, listen: false);
    final router = GoRouter.of(context);

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));
    final success = appState.unlockAdmin(_passController.text);

    if (!mounted) return;

    if (success) {
      router.go(AdminDashboardScreen.routePath);
    } else {
      setState(() {
        _error = 'Code incorrect.';
        _isSubmitting = false;
      });
    }
  }
}
