import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/providers/modus_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/config.dart';

void main() {
  runApp(
    const ProviderScope (
      child: MainApp()
    )
    );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final tenebrisModusEst = ref.watch(estTenebrisModusProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme( tenebrisModusEst: tenebrisModusEst, electusColor: Colors.pink.shade900).getTheme(),
      
    );
  }
}
        // This is the theme of your application.
    