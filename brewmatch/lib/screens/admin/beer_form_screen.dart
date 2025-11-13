import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/beer.dart';
import 'widgets/beer_form.dart';

/// Placeholder for the beer creation/editing form in the admin flow.
/// TODO: Implement functional form fields, validation, and data submission.
class BeerFormScreen extends StatelessWidget {
  static const routePath = '/admin/beers/form';

  const BeerFormScreen({super.key, this.initialBeer});

  final Beer? initialBeer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer / éditer une bière'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: BeerForm(
              initialBeer: initialBeer,
              onCancelled: () => context.pop(),
              onSaved: (_) => context.pop(),
            ),
          ),
        ),
      ),
    );
  }
}
