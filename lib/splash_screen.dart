import 'package:flutter/material.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/bottomNavBar/bottom_bar.dart';

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
      pushReplacement(context,  const BottomNavView());
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/bgimage.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
