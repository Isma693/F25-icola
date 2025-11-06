import 'package:flutter/material.dart';

import '../core/state/app_state.dart';

/// Temporary settings screen for language selector and mode shortcuts.
/// TODO: Integrate full preferences UI once design is finalized.
class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final locale = appState.locale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Préférences',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            title: 'Langue de l’application',
            child: DropdownButton<Locale>(
              value: locale,
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),
              ],
              onChanged: (selected) {
                if (selected != null) {
                  appState.setLocale(selected);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: 'Mode administrateur',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appState.isAdminUnlocked ? 'Verrouillé après usage pour sécurité.' : 'Protégé par code.',
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => appState.lockAdmin(),
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Reverrouiller'),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
