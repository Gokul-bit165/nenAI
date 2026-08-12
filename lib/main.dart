import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'background/note_processing_worker.dart';
import 'injection.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await configureDependencies();

  // Initialize WorkManager for background note processing on Android
  try {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  } catch (e) {
    debugPrint('WorkManager initialization skipped or failed: $e');
  }

  runApp(
    const ProviderScope(
      child: NENAIApp(),
    ),
  );
}

class NENAIApp extends StatelessWidget {
  const NENAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NENAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
