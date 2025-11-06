import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'client_home_screen.dart';
import 'sample_data.dart';

/// Detailed view for an ingredient shown in beer descriptions.
/// TODO: Hook into real ingredient entities from Firestore.
class IngredientDetailScreen extends StatelessWidget {
  static const routeSegment = 'ingredient/:ingredientId';

  const IngredientDetailScreen({
    super.key,
    required this.ingredientId,
    this.sample,
  });

  final String ingredientId;
  final IngredientSample? sample;

  @override
  Widget build(BuildContext context) {
    final ingredient = sample ?? ingredientById[ingredientId];
    if (ingredient == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ingrédient'),
        ),
        body: const Center(
          child: Text('Ingrédient introuvable.'),
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(ingredient.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Retour au client',
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.go(ClientHomeScreen.routePath),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'ingredient-${ingredient.id}',
              child: _IngredientBadge(category: ingredient.category),
            ),
            const SizedBox(height: 24),
            Text(
              ingredient.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (ingredient.origin != null)
              _InfoTile(
                icon: Icons.public,
                label: 'Origine',
                value: ingredient.origin!,
              ),
            if (ingredient.pairingTip != null)
              _InfoTile(
                icon: Icons.restaurant_menu,
                label: 'Accords parfaits',
                value: ingredient.pairingTip!,
              ),
            const SizedBox(height: 24),
            Text(
              'Bières associées',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._buildAssociatedBeers(ingredient),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAssociatedBeers(IngredientSample ingredient) {
    final associated = mockBeers.where((beer) => beer.ingredientIds.contains(ingredient.id)).toList();
    if (associated.isEmpty) {
      return const [Text('Aucune bière listée pour le moment.')];
    }
    return associated
        .map(
          (beer) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_drink),
            title: Text(beer.name),
            subtitle: Text(beer.style),
          ),
        )
        .toList();
  }
}

class _IngredientBadge extends StatelessWidget {
  const _IngredientBadge({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withAlpha((0.15 * 255).round()),
            colorScheme.primary.withAlpha((0.3 * 255).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.spa, size: 40),
          const SizedBox(height: 16),
          Text(
            category,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
