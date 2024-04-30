import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:non_attending/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Non Attending',
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}
