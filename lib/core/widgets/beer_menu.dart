import 'package:flutter/material.dart';

import '../../screens/client/sample_data.dart';

/// Liste réutilisable de bières filtrées.
/// L’affichage (app bar, navigation, filtres) est délégué au parent.
class BeerListScreen extends StatelessWidget {
  const BeerListScreen({
    super.key,
    this.filters,
    this.beers,
    this.onBeerTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.enableHeroAnimation = true,
  });

  final BeerFilterOptions? filters;
  final List<BeerSample>? beers;
  final ValueChanged<BeerSample>? onBeerTap;
  final EdgeInsetsGeometry padding;
  final bool enableHeroAnimation;

  List<BeerSample> _computeResults() {
    final source = List<BeerSample>.from(beers ?? mockBeers);
    final filter = filters;
    if (filter == null) return source;
    source.sort((a, b) => b.matchScore(filter).compareTo(a.matchScore(filter)));
    return source;
  }

  @override
  Widget build(BuildContext context) {
    final results = _computeResults();
    final filter = filters;

    if (results.isEmpty) {
      return const _EmptyPlaceholder();
    }

    return ListView.builder(
      padding: padding,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final beer = results[index];
        final score = filter != null ? beer.matchScore(filter) : 1.0;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 240 + index * 60),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _BeerCard(
            sample: beer,
            score: score,
            enableHero: enableHeroAnimation,
            onTap: () => onBeerTap?.call(beer),
          ),
        );
      },
    );
  }
}

class _BeerCard extends StatelessWidget {
  const _BeerCard({
    required this.sample,
    required this.score,
    required this.onTap,
    required this.enableHero,
  });

  final BeerSample sample;
  final double score;
  final VoidCallback onTap;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _wrapIfNeeded(
        child: Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _PlaceholderBottle(style: sample.style),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sample.name,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sample.style,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          sample.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Chip(
                            label: Text('${(score * 100).round()}% match'),
                          ),
                        ),
                      ],
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

  Widget _wrapIfNeeded({required Widget child}) {
    if (!enableHero) return child;
    return Hero(tag: 'beer-${sample.id}', child: child);
  }
}

class _PlaceholderBottle extends StatelessWidget {
  const _PlaceholderBottle({required this.style});

  final String style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade200,
            Colors.deepOrange.shade300,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            style,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 56, color: Colors.orange.shade300),
            const SizedBox(height: 16),
            const Text(
              'Aucune bière ne correspond à tes envies (encore !)',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
