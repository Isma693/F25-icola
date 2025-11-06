import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../client/sample_data.dart';
import 'beer_form_screen.dart';

/// Lists ingredients available to administrators.
/// TODO: Replace mock data with Firestore-backed list and editing actions.
class IngredientListScreen extends StatelessWidget {
  static const routePath = '/admin/ingredients';

  const IngredientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrédients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((0.15 * 255).round()),
            child: const Icon(Icons.spa),
          ),
          title: Text(ingredientCatalog[index].name),
          subtitle: Text(ingredientCatalog[index].category),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push(BeerFormScreen.routePath),
          ),
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: ingredientCatalog.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(BeerFormScreen.routePath),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle bière'),
      ),
    );
  }
}
