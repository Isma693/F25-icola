import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'client_home_screen.dart';
import 'sample_data.dart';

/// Displays the list of beers for a given set of taste filters.
/// TODO: Replace mock data with Firestore driven list and real filtering.
class BeerListScreen extends StatefulWidget {
  static const routePath = '/client/beers';

  const BeerListScreen({super.key, this.filters});

  final BeerFilterOptions? filters;

  @override
  State<BeerListScreen> createState() => _BeerListScreenState();
}

class _BeerListScreenState extends State<BeerListScreen> {
  late final List<BeerSample> results;

  @override
  void initState() {
    super.initState();
    final filters = widget.filters;
    if (filters == null) {
      results = List<BeerSample>.from(mockBeers);
    } else {
      results = List<BeerSample>.from(mockBeers)
        ..sort((a, b) => b.matchScore(filters).compareTo(a.matchScore(filters)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.filters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ta sélection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(ClientHomeScreen.routePath),
        ),
        actions: [
          if (filters != null)
            IconButton(
              tooltip: 'Voir les filtres',
              icon: const Icon(Icons.tune),
              onPressed: () => _showFilterSummary(context, filters),
            ),
        ],
      ),
      body: results.isEmpty
          ? const _EmptyPlaceholder()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final beer = results[index];
                final score = filters != null ? beer.matchScore(filters) : 1.0;
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
                    onTap: () => context.push(
                      '${ClientHomeScreen.routePath}/beers/${beer.id}',
                      extra: beer,
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFilterSummary(BuildContext context, BeerFilterOptions filters) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tes envies',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _FilterRow(label: 'Amertume', value: filters.bitterness),
              _FilterRow(label: 'Sucre', value: filters.sweetness),
              _FilterRow(label: 'Alcool', value: filters.alcohol),
              _FilterRow(label: 'Effervescence', value: filters.carbonation),
            ],
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
  });

  final BeerSample sample;
  final double score;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Hero(
        tag: 'beer-${sample.id}',
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

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
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
