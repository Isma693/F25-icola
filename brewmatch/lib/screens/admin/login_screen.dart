import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/state/app_state.dart';
import 'client/client_home_screen.dart';
import 'admin_unlock_screen.dart';

/// Temporary login / mode selection screen.
/// TODO: Integrate Firebase Auth and proper role handling.
class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFCC80),
              Color(0xFFFFF3E0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'BrewMatch',
                      style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Trouve ta bière idéale ou gère ton bar en toute simplicité.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        AppStateScope.of(context, listen: false).lockAdmin();
                        context.go(ClientHomeScreen.routePath);
                      },
                      icon: const Icon(Icons.favorite),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      label: const Text('Je suis client'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => context.push(AdminUnlockScreen.routeName),
                      icon: const Icon(Icons.lock_open),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        textStyle: const TextStyle(fontSize: 18),
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      label: const Text('Espace tenancier / admin'),
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
}
