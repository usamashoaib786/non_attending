import 'package:flutter/material.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      getUserCredentials(context);
    });
    // Use this method to get user credentials if needed
  }

  void getUserCredentials(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(PrefKey.authorization);

    if (token != null && token.isNotEmpty) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
