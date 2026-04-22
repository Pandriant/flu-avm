import 'package:flutter/material.dart';
import 'config/theme/config.dart';  
import 'presentation/screens/screens.dart';


import 'package:flutter_application_1/config/theme/app_theme.dart';void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: DomusScreen(),
    );
  }
}
        // This is the theme of your application.
    