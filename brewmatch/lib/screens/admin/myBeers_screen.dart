import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/beer.dart';
import '../../core/services/admin_catalog_repository.dart';
import '../../core/state/app_state.dart';
import 'beer_form_screen.dart';

/// Liste des bières côté admin avec accès rapide à l’édition.
class MyBeersScreen extends StatefulWidget {
  static const routeSegment = 'beers';

  const MyBeersScreen({super.key});

  @override
  State<MyBeersScreen> createState() => _MyBeersScreenState();
}

class _MyBeersScreenState extends State<MyBeersScreen> {
  final AdminCatalogRepository _repository = AdminCatalogRepository();

  @override
  Widget build(BuildContext context) {
    AppStateScope.of(context, listen: false).refreshAdminSession();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Bières'),
      ),
      body: StreamBuilder<List<Beer>>(
        stream: _repository.watchBeers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final beers = snapshot.data ?? [];
          if (beers.isEmpty) {
            return const _EmptyBeers();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: beers.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final beer = beers[index];
              return ListTile(
                title: Text(beer.name['fr'] ?? beer.localizedName('fr')),
                subtitle: Text('${beer.style} · ${beer.alcoholLevel.toStringAsFixed(1)}%'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openForm(beer),
                ),
                onTap: () => _openForm(beer),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(null),
        tooltip: 'Ajouter une bière',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openForm(Beer? beer) {
    return context.push(
      BeerFormScreen.routePath,
      extra: beer,
    );
  }
}

class _EmptyBeers extends StatelessWidget {
  const _EmptyBeers();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Aucune bière n’est enregistrée pour l’instant.\nAjoute ta première référence.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
