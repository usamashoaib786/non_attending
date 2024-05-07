import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/View/Cart%20Screens/cart_screen.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        leading: IconButton(
          icon: Image.asset(
              'assets/images/drawer.png'), // Replace with your image asset
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: const MyDrawer(),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 216, 167), // 43%
              Color.fromARGB(255, 223, 214, 192), // 7.74%
              Color.fromARGB(255, 231, 221, 198), // 22.45%
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                custom(ontap: () {}, txt: "IT/ISE"),
                custom(ontap: () {}, txt: "DIPLOMA"),
                custom(ontap: () {}, txt: "DEGREE"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget custom({txt, required Function() ontap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 145,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/images/homeCon.png",
            ),
            fit: BoxFit.fill,
          )),
          child: Center(
            child: AppText.appText("$txt",
                shadow: true, fontSize: 50, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var token;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString(PrefKey.authorization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox(
          height: 530,
          width: 280,
          child: Drawer(
            backgroundColor: AppTheme.appColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Column(
              children: [
                if (token == null)
                  customColumn(
                      onTap: () {
                        pushUntil(context, const SignInScreen());
                      },
                      text: "Login"),
                customColumn(onTap: () {
                  // push(context, const CartScreen());
                }, text: "Cart"),
                customColumn(onTap: () {}, text: "My Courses"),
                customColumn(onTap: () {}, text: "Privacy policy"),
                customColumn(onTap: () {}, text: "Terms & Conditions"),
                if (token != null)
                  customColumn(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        pushUntil(context, const SignInScreen());
                      },
                      text: "Logout"),
              ],
            ),
          )),
    );
  }

  Widget customColumn({required Function() onTap, text}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 17.0),
            child: AppText.appText("$text",
                fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Divider(
            height: 1,
            color: AppTheme.blackColor,
          )
        ],
      ),
    );
  }
}
