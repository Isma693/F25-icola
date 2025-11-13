import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_state.dart';
import '../client/home_screen.dart';
import 'myBeers_screen.dart';
import 'settings_screen.dart';

/// Administrator hub for managing catalog content.
/// TODO: Add live dashboard metrics widgets. Contrast the UX to differentiate the client side from the user side. 
class AdminDashboardScreen extends StatelessWidget {
  static const routePath = '/admin';

  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    appState.refreshAdminSession();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BrewMatch Admin'),
        actions: [
          IconButton(
            tooltip: 'Paramètres',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(SettingsScreen.routeName),
          ),
          IconButton(
            tooltip: 'Mode Client',
            icon: const Icon(Icons.lock),
            onPressed: () {
              appState.lockAdmin();
              context.go(ClientHomeScreen.routePath);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tableau de bord',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aperçu global des bières, ingrédients et actions rapides pour gérer la carte.',
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _AdminCard(
                  icon: Icons.soup_kitchen,
                  title: 'Ingrédients',
                  description: 'Gère les matières premières et allergènes.',
                  onTap: () => context.go('${AdminDashboardScreen.routePath}/ingredients'),
                ),
                _AdminCard(
                  icon: Icons.local_drink,
                  title: 'Mes Bières',
                  description: 'Ajoute ou modifie les références du catalogue.',
                  onTap: () => context.go('${AdminDashboardScreen.routePath}/${MyBeersScreen.routeSegment}'),
                ),
              ],
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => context.go(ClientHomeScreen.routePath),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour au mode client'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withAlpha((0.12 * 255).round()),
                  child: Icon(icon, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
