import 'package:brewmatch/screens/admin/login_screen.dart';
import 'package:brewmatch/screens/admin/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_state.dart';
import '../admin/admin_unlock_screen.dart';
import '../alcotest_screen.dart';
import 'sample_data.dart';

/// Entry point for the client experience.
/// TODO: Link the sliders and results to the actual recommendation engine. Create and encapsulate them in the necessary widgets.
class ClientHomeScreen extends StatefulWidget {
  static const routePath = '/client';

  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  double bitterness = 0.5;
  double sweetness = 0.4;
  double alcohol = 0.6;
  double carbonation = 0.5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('BrewMatch'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.tune),
            onPressed: () => context.push(SettingsScreen.routeName),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'alcotest':
                  context.push(AlcotestScreen.routeName);
                  break;
                case 'admin':
                  context.push(AdminUnlockScreen.routeName);
                  break;
                case 'logout':
                  AppStateScope.of(context, listen: false).lockAdmin();
                  context.go(LoginScreen.routeName);
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'alcotest',
                child: Text('Alcotest (Easter egg)'),
              ),
              const PopupMenuItem(
                value: 'admin',
                child: Text('Unlock admin'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Back to login'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tu bois quoi ?',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Réglons ton mood dégustation pour trouver ta prochaine bière coup de coeur.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildSliderCard(
                      context,
                      title: 'Amertume',
                      value: bitterness,
                      onChanged: (v) => setState(() => bitterness = v),
                      emoji: '🌿',
                    ),
                    _buildSliderCard(
                      context,
                      title: 'Sucre',
                      value: sweetness,
                      onChanged: (v) => setState(() => sweetness = v),
                      emoji: '🍯',
                    ),
                    _buildSliderCard(
                      context,
                      title: 'Alcool',
                      value: alcohol,
                      onChanged: (v) => setState(() => alcohol = v),
                      emoji: '🔥',
                    ),
                    _buildSliderCard(
                      context,
                      title: 'Effervescence',
                      value: carbonation,
                      onChanged: (v) => setState(() => carbonation = v),
                      emoji: '💫',
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      onPressed: () {
                        final filters = BeerFilterOptions(
                          bitterness: bitterness,
                          sweetness: sweetness,
                          alcohol: alcohol,
                          carbonation: carbonation,
                        );
                        context.go('${ClientHomeScreen.routePath}/beers', extra: filters);
                      },
                      child: const Text('Vite ma bière !'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push(AlcotestScreen.routeName),
                      child: const Text('Mode découverte (Alcotest)'),
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

  Widget _buildSliderCard(
    BuildContext context, {
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    required String emoji,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Slider(
              value: value,
              onChanged: onChanged,
              thumbColor: theme.colorScheme.primary,
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Doux'),
                Text('Intense'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
