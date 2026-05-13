import 'package:flutter_application_1/presentation/screens/bands/bands_screen.dart';
import 'package:flutter_application_1/presentation/screens/domus/domus_screen.dart';
import 'package:flutter_application_1/presentation/screens/charta/charta_screen.dart';
import 'package:flutter_application_1/presentation/screens/numerator/numerator_screen.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder:(context, state) => const DomusScreen(),
      ),
    GoRoute(
      path: '/numerator-riverpod',
      builder:(context, state) => const NumeratorScreen(),
      ),
    GoRoute(
      path: '/bands',
      builder:(context, state) => const  BandsScreen(),
      ),
    GoRoute(
      path: '/charta',
      builder:(context, state) => const  ChartaScreen(),
      ),
  ]
  );