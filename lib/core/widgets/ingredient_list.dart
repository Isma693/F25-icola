import 'package:flutter/material.dart';

import '../../screens/client/sample_data.dart';

/// Liste réutilisable d’ingrédients, indépendante de toute navigation.
class IngredientListView extends StatelessWidget {
  const IngredientListView({
    super.key,
    this.ingredients,
    this.onIngredientTap,
    this.padding = const EdgeInsets.all(20),
  });

  final List<IngredientSample>? ingredients;
  final ValueChanged<IngredientSample>? onIngredientTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final data = ingredients ?? ingredientCatalog;
    if (data.isEmpty) {
      return const _EmptyPlaceholder();
    }

    return ListView.separated(
      padding: padding,
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final ingredient = data[index];
        return _IngredientTile(
          ingredient: ingredient,
          onTap: onIngredientTap != null ? () => onIngredientTap!(ingredient) : null,
        );
      },
    );
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({required this.ingredient, this.onTap});

  final IngredientSample ingredient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withAlpha((0.12 * 255).round()),
        child: const Icon(Icons.spa),
      ),
      title: Text(ingredient.name),
      subtitle: Text(ingredient.category),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.spa_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Aucun ingrédient à afficher pour le moment.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
