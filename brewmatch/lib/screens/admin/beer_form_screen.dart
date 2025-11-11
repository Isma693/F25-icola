import 'package:brewmatch/screens/admin/ingredient_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for the beer creation/editing form in the admin flow.
/// TODO: Implement actual form fields, validation, and data submission.
class BeerFormScreen extends StatelessWidget {
  static const routePath = '/admin/beers/form';

  const BeerFormScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuration de la fiche',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ce formulaire permettra bientôt de définir une bière et de la publier dans BrewMatch.',
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: 'Nom de la bière'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Style'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Taux d’alcool (%)'),
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(IngredientListScreen.routePath),
              icon: const Icon(Icons.spa),
              label: const Text('Sélectionner des ingrédients'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bientôt : sauvegarder cette bière dans Firestore.'),
                  ),
                );
              },
              child: const Text('Enregistrer (désactivé)'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
