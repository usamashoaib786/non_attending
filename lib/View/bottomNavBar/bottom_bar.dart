import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/View/Profile%20Screen/profile_screen.dart';
import 'package:non_attending/View/Search%20Course%20Screen/search_corse.dart';

class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _selectedIndex = 1;

  List screen = [
    const SearchCourseScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screen[_selectedIndex],
        bottomNavigationBar: Container(
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
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Image.asset(
                    "assets/images/search.png",
                    color: _selectedIndex == 0
                        ? AppTheme.blue
                        : AppTheme.blackColor,
                    height: _selectedIndex == 0 ? 62 : 48,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Image.asset(
                    "assets/images/home.png",
                    color: _selectedIndex == 1
                        ? AppTheme.blue
                        : AppTheme.blackColor,
                    height: _selectedIndex == 1 ? 62 : 48,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Image.asset(
                    "assets/images/person.png",
                    height: _selectedIndex == 2 ? 62 : 48,
                    color: _selectedIndex == 2
                        ? AppTheme.blue
                        : AppTheme.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
