import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NothingNotesApp()));
}

class NothingNotesApp extends ConsumerWidget {
  const NothingNotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'Nothing Notes',
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
      routerConfig: appRouter,
    );
  }
}