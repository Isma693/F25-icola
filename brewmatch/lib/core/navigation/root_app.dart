import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/login_screen.dart';
import '../../screens/client/client_home_screen.dart';
import '../../screens/client/beer_list_screen.dart';
import '../../screens/client/beer_detail_screen.dart';
import '../../screens/client/ingredient_detail_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/ingredient_list_screen.dart';
import '../../screens/admin/beer_form_screen.dart';
import '../../screens/alcotest_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/admin_unlock_screen.dart';
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
  late final AppState _appState;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _router = GoRouter(
      initialLocation: LoginScreen.routeName,
      debugLogDiagnostics: false,
      refreshListenable: _appState,
      redirect: (context, state) {
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
                final filters = state.extra is BeerFilterOptions ? state.extra as BeerFilterOptions : null;
                return BeerListScreen(filters: filters);
              },
              transition: _slideUpTransition,
              routes: [
                _buildRoute(
                  path: ':beerId',
                  builder: (context, state) {
                    final sample = state.extra is BeerSample ? state.extra as BeerSample : null;
                    final beerId = state.pathParameters['beerId'] ?? '';
                    return BeerDetailScreen(beerId: beerId, sample: sample);
                  },
                  transition: _zoomTransition,
                  routes: [
                    _buildRoute(
                      path: IngredientDetailScreen.routeSegment,
                      builder: (context, state) {
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
    _router.dispose();
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

Widget _fadeTransition(BuildContext context, Animation<double> animation, Animation<double> _, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

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

Widget _slideUpTransition(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutQuart);
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}

Widget _zoomTransition(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCirc);
  return ScaleTransition(
    scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}
