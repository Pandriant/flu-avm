import 'package:flutter/material.dart';
import '../../presentation/providers/modus_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/config.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(mapboxAccessToken);

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
    