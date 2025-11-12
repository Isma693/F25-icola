import 'package:brewmatch/screens/admin/ingredient_form_screen.dart';
import 'package:brewmatch/screens/admin/login_screen.dart';
import 'package:brewmatch/screens/admin/settings_screen.dart';
import 'package:brewmatch/screens/admin/myBeers_screen.dart';
import 'package:brewmatch/core/widgets/beer_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/client/home_screen.dart';
import '../../screens/client/beer_detail_screen.dart';
import '../widgets/ingredient_detail_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/beer_form_screen.dart';
import '../../screens/alcotest_screen.dart';
import '../../screens/admin/admin_unlock_screen.dart';
import '../state/app_state.dart';
import '../../screens/client/sample_data.dart';

typedef TransitionBuilderFn = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  // _appState stocke les infos globales (locale, verrouillage admin, etc.).
  late final AppState _appState;
  // _router coordonne l’ensemble des routes GoRouter avec transitions custom.
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // On initialise l’état global une seule fois à la création du widget racine.
    _appState = AppState();
    // Configuration centralisée de GoRouter : redirections et arborescence des pages.
    _router = GoRouter(
      initialLocation: LoginScreen.routeName,
      debugLogDiagnostics: false,
      refreshListenable: _appState,
      redirect: (context, state) {
        // Vérification des routes admin protégées par l’écran de déverrouillage.
        final isAdminRoute = state.matchedLocation.startsWith('/admin');
        final isUnlockRoute = state.matchedLocation == AdminUnlockScreen.routeName;

        if (isAdminRoute && !_appState.isAdminUnlocked && !isUnlockRoute) {
          return AdminUnlockScreen.routeName;
        }
        if (isUnlockRoute && _appState.isAdminUnlocked) {
          return AdminDashboardScreen.routePath;
        }
        return null;
      },
      routes: [
        _buildRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
          transition: _fadeTransition,
        ),
        _buildRoute(
          path: ClientHomeScreen.routePath,
          builder: (context, state) => const ClientHomeScreen(),
          transition: _fadeScaleTransition,
          routes: [
            _buildRoute(
              path: 'beers',
              builder: (context, state) {
                // Les filtres sont passés via state.extra pour affiner la liste.
                final filters = state.extra is BeerFilterOptions ? state.extra as BeerFilterOptions : null;
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
                  body: BeerListScreen(
                    filters: filters,
                    onBeerTap: (beer) => context.push(
                      '${ClientHomeScreen.routePath}/beers/${beer.id}',
                      extra: beer,
                    ),
                  ),
                );
              },
              transition: _slideUpTransition,
              routes: [
                _buildRoute(
                  path: ':beerId',
                  builder: (context, state) {
                    // On récupère l’échantillon ou l’ID pour afficher un détail précis.
                    final sample = state.extra is BeerSample ? state.extra as BeerSample : null;
                    final beerId = state.pathParameters['beerId'] ?? '';
                    return BeerDetailScreen(beerId: beerId, sample: sample);
                  },
                  transition: _zoomTransition,
                  routes: [
                    _buildRoute(
                      path: IngredientDetailScreen.routeSegment,
                      builder: (context, state) {
                        // Même logique pour les ingrédients liés à une bière donnée.
                        final ingredient = state.extra is IngredientSample ? state.extra as IngredientSample : null;
                        final ingredientId = state.pathParameters['ingredientId'] ?? '';
                        return IngredientDetailScreen(
                          ingredientId: ingredientId,
                          sample: ingredient,
                        );
                      },
                      transition: _slideUpTransition,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        _buildRoute(
          path: AdminDashboardScreen.routePath,
          builder: (context, state) => const AdminDashboardScreen(),
          transition: _fadeScaleTransition,
          routes: [
            _buildRoute(
              path: 'ingredients',
              builder: (context, state) => const IngredientListScreen(),
              transition: _slideUpTransition,
            ),
            _buildRoute(
              path: 'ingredients/form',
              builder: (context, state) => const IngredientFormScreen(),
              transition: _slideUpTransition,
            ),
            _buildRoute(
              path: MyBeersScreen.routeSegment,
              builder: (context, state) => const MyBeersScreen(),
              transition: _slideUpTransition,
            ),
            _buildRoute(
              path: 'beers/form',
              builder: (context, state) => const BeerFormScreen(),
              transition: _slideUpTransition,
            ),
          ],
        ),
        _buildRoute(
          path: AlcotestScreen.routeName,
          builder: (context, state) => const AlcotestScreen(),
          transition: _fadeTransition,
        ),
        _buildRoute(
          path: SettingsScreen.routeName,
          builder: (context, state) => const SettingsScreen(),
          transition: _fadeTransition,
        ),
        _buildRoute(
          path: AdminUnlockScreen.routeName,
          builder: (context, state) => const AdminUnlockScreen(),
          transition: _slideUpTransition,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Nettoyage des écouteurs pour éviter les fuites mémoire.
    _router.dispose();
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder fait reconstruire l’arbre quand AppState change (locale, statut admin).
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        return AppStateScope(
          notifier: _appState,
          child: MaterialApp.router(
            title: 'BrewMatch',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
              scaffoldBackgroundColor: Colors.grey.shade50,
              useMaterial3: true,
            ),
            locale: _appState.locale,
            supportedLocales: const [Locale('en'), Locale('fr')],
            routerConfig: _router,
          ),
        );
      },
    );
  }

  GoRoute _buildRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    required TransitionBuilderFn transition,
    List<RouteBase> routes = const [],
  }) {
    // Méthode utilitaire pour réduire le boilerplate lors de la déclaration des routes.
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        child: builder(context, state),
        transitionsBuilder: transition,
      ),
      routes: routes,
    );
  }
}

// Transition douce utilisée pour les écrans simples (login, réglages, etc.).
Widget _fadeTransition(BuildContext context, Animation<double> animation, Animation<double> _, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

// Variante avec zoom léger pour donner du relief aux vues principales.
Widget _fadeScaleTransition(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
      child: child,
    ),
  );
}

// Transition verticale subtile pour les sous-écrans (listes ou formulaires).
Widget _slideUpTransition(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutQuart);
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}

// Zoom progressif pour mettre l’accent sur les détails (fiche bière).
Widget _zoomTransition(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCirc);
  return ScaleTransition(
    scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
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
