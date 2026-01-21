import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, __) => const _RootPage()),

     
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
}

class _RootPage extends StatelessWidget {
  const _RootPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Root')));
  }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(error?.toString() ?? 'Router error')),
    );
  }
}
