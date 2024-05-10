import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/View/Cart%20Screens/checkout.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var token;
  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString(PrefKey.authorization);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomNav(),
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        leading: IconButton(
          icon: Image.asset('assets/images/drawer.png'),
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
          child: Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: cart.products.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 145, 158, 222),
                                    blurRadius: 3,
                                    offset: Offset(3, 5))
                              ],
                              borderRadius: BorderRadius.circular(27),
                              color: AppTheme.whiteColor),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText.appText(
                                        "${cart.products[index].price} INR",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                    const StarRating(
                                      rating: 3.5,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AppText.appText(cart.products[index].name,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    textColor: const Color(0xff0D2393)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText.appText("Buy Now",
                                        shadow: true,
                                        shadowColor: AppTheme.blue,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                    GestureDetector(
                                      onTap: () {
                                        cart.clearProduct(cart.products[index]);
                                      },
                                      child: Image.asset(
                                        "assets/images/dell.png",
                                        height: 40,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index == cart.products.length - 1)
                        const SizedBox(
                          height: 90,
                        ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AppButton.appButton("Checkout All", onTap: () {
                    if (token != null ) {
                      if (cart.products.isNotEmpty) {
                      push(context, const CheckOutScreen());
                        
                      } else {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomPopupDialog(
                            image: "assets/images/oops.png",
                            msg1: "",
                            msg2: "You don't have any item in cart",
                          );
                        },
                      );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomPopupDialog(
                            image: "assets/images/oops.png",
                            msg1: "",
                            msg2: "Please Login First",
                          );
                        },
                      );
                    }
                  },
                      height: 60,
                      width: 225,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          )),
    );
  }
}
