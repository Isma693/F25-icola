import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_state.dart';
import '../../core/widgets/beer_menu.dart';
import '../client/home_screen.dart';
import 'beer_form_screen.dart';

/// Écran temporaire qui encapsule le catalogue de bières pour l’espace admin.
/// TODO: enrichir avec filtres avancés et actions CRUD.
class MyBeersScreen extends StatelessWidget {
  static const routeSegment = 'beers';

  const MyBeersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateScope.of(context, listen: false).refreshAdminSession();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Bières'),
      ),
      body: BeerListScreen(
        filters: null,
        onBeerTap: (beer) => context.push(
          '${ClientHomeScreen.routePath}/beers/${beer.id}',
          extra: beer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(BeerFormScreen.routePath),
        tooltip: 'Ajouter une bière',
        child: const Icon(Icons.add),
      ),
    );
  }
}
