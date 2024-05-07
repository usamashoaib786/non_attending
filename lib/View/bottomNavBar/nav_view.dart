import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/bottomNavBar/bottom_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: AppTheme.appColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                pushUntil(
                    context,
                    const BottomNavView(
                      index: 0,
                    ));
              },
              child: Image.asset(
                "assets/images/search.png",
                color: AppTheme.blackColor,
                height: 48,
              ),
            ),
            GestureDetector(
              onTap: () {
                pushUntil(
                    context,
                    const BottomNavView(
                      index: 1,
                    ));
              },
              child: Image.asset(
                "assets/images/home.png",
                color: AppTheme.blackColor,
                height: 48,
              ),
            ),
            GestureDetector(
              onTap: () {
                pushUntil(
                    context,
                    const BottomNavView(
                      index: 2,
                    ));
              },
              child: Image.asset(
                "assets/images/person.png",
                height: 48,
                color: AppTheme.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
