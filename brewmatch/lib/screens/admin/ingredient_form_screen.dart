import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/ingredient.dart';
import '../../core/services/admin_catalog_repository.dart';
import 'widgets/ingredient_form.dart';
import '../../core/state/app_state.dart';
import '../../core/widgets/ingredient_detail_screen.dart';
import '../../core/widgets/ingredient_list.dart';

/// Lists ingredients available to administrators.
class IngredientListScreen extends StatefulWidget {
  static const routePath = '/admin/ingredients';

  const IngredientListScreen({super.key});

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  final AdminCatalogRepository _repository = AdminCatalogRepository();

  @override
  Widget build(BuildContext context) {
    AppStateScope.of(context, listen: false).refreshAdminSession();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrédients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: StreamBuilder<List<Ingredient>>(
        stream: _repository.watchIngredients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final ingredients = snapshot.data ?? [];
          if (ingredients.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: ingredients.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                leading: const Icon(Icons.spa),
                title: Text(ingredient.name['fr'] ?? ingredient.id),
                subtitle: Text(_displayCategory(ingredient.category)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openEditForm(ingredient),
                ),
                onTap: () => _openEditForm(ingredient),
              );
            },
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

  Future<void> _openEditForm(Ingredient ingredient) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: IngredientForm(
              initialIngredient: ingredient,
              onSaved: (_) => Navigator.of(context).pop(),
              onCancelled: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  String _displayCategory(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.hop:
        return 'Houblon';
      case IngredientCategory.yeast:
        return 'Levure';
      case IngredientCategory.grain:
        return 'Céréale';
      case IngredientCategory.other:
        return 'Autre';
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Aucun ingrédient enregistré pour l’instant.\nAjoute ton premier ingrédient.',
          textAlign: TextAlign.center,
        ),
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
    AppStateScope.of(context, listen: false).refreshAdminSession();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer / éditer un ingrédient'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: IngredientForm(
              onCancelled: () => context.pop(),
              onSaved: (_) => context.pop(),
            ),
          ),
        ),
      ),
    );
  }
}
