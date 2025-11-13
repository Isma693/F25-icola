import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/ingredient_list.dart';
import '../../core/widgets/ingredient_detail_screen.dart';

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
      body: IngredientListView(
        onIngredientTap: (ingredient) {
          // Ouvre la fiche détaillée en conservant les données mock pour l’instant.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => IngredientDetailScreen(
                ingredientId: ingredient.id,
                sample: ingredient,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(IngredientFormScreen.routePath),
        tooltip: 'Ajouter un ingrédient',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Placeholder d’ajout / modification d’ingrédient.
/// TODO: implémenter un vrai formulaire (nom, catégorie, allergènes, etc.).
class IngredientFormScreen extends StatelessWidget {
  static const routePath = '/admin/ingredients/form';

  const IngredientFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer / éditer un ingrédient'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text('Formulaire d’ingrédient à venir.'),
      ),
    );
  }
}
