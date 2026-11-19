import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import '../core/presentation/providers/theme_provider.dart';
import '../features/auth/presentation/widgets/auth_migration_listener.dart';
import '../features/sync/presentation/widgets/sync_initializer.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return SyncInitializer(
      child: AuthMigrationListener(
        child: MaterialApp.router(
          title: 'Gym Workout Tracker V2',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
