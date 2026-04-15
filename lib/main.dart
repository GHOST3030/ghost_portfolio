import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: GhostPortfolioApp()));
}

class GhostPortfolioApp extends StatelessWidget {
  const GhostPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ahmed Allaw — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
