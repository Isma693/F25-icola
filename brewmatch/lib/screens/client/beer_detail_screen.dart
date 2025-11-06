import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'client_home_screen.dart';
import 'sample_data.dart';

/// Shows the detailed information of a beer selection.
/// TODO: Bind to Firestore data and add pairing suggestions.
class BeerDetailScreen extends StatelessWidget {
  static const routePath = '/client/beers/:beerId';

  const BeerDetailScreen({
    super.key,
    required this.beerId,
    this.sample,
  });

  final String beerId;
  final BeerSample? sample;

  @override
  Widget build(BuildContext context) {
    final beer = sample ??
        mockBeers.firstWhere(
          (element) => element.id == beerId,
          orElse: () => mockBeers.first,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(beer.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Retour à la liste',
            icon: const Icon(Icons.list),
            onPressed: () => context.go('${ClientHomeScreen.routePath}/beers'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'beer-${beer.id}',
              child: _BottleHero(style: beer.style),
            ),
            const SizedBox(height: 24),
            Text(
              beer.style,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              beer.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _StatRow(label: 'Alcool', value: beer.alcohol),
            _StatRow(label: 'Amertume', value: beer.bitterness),
            _StatRow(label: 'Sucre', value: beer.sweetness),
            _StatRow(label: 'Effervescence', value: beer.carbonation),
            const SizedBox(height: 24),
            Text(
              'Ingrédients',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: beer.ingredients
                  .map(
                    (ingredient) => Hero(
                      tag: 'ingredient-${ingredient.id}',
                      child: ActionChip(
                        avatar: const Icon(Icons.spa, size: 18),
                        label: Text(ingredient.name),
                        onPressed: () => context.push(
                          '${ClientHomeScreen.routePath}/beers/${beer.id}/ingredient/${ingredient.id}',
                          extra: ingredient,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonction à venir : ajouter cette bière à tes favoris !'),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_outline),
              label: const Text('Je la veux au frais'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          const SizedBox(width: 12),
          Text('${(value * 100).round()}%'),
        ],
      ),
    );
  }
}

class _BottleHero extends StatelessWidget {
  const _BottleHero({required this.style});

  final String style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade200,
            Colors.deepOrange.shade400,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.shade100,
            offset: const Offset(0, 20),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                style,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.local_drink,
                size: 48,
                color: Colors.white.withAlpha((0.8 * 255).round()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
