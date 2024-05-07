import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/config/Apis%20Manager/apis_provider.dart';
import 'package:non_attending/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiProvider>(create: (_) => ApiProvider()),
        ChangeNotifierProvider<Cart>(create: (_) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Non Attending',
        theme: ThemeData(),
        home: const SplashScreen(),
      ),
    );
  }
}
