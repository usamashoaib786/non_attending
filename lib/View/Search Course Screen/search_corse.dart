import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/View/Cart%20Screens/cart_class.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:provider/provider.dart';

class SearchCourseScreen extends StatefulWidget {
  const SearchCourseScreen({super.key});

  @override
  State<SearchCourseScreen> createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedText = "Course Type";
  List options = ["Paid", "Unpaid"];
  bool isLoading = true;
  bool isShow = false;
  var userId;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey,
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
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 268,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 145, 158, 222),
                                  blurRadius: 3,
                                  offset: Offset(3, 5))
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.whiteColor),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: AppText.appText(selectedText,
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Image.asset(
                                    "assets/images/down.png",
                                    height: 15,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isShow == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          height: 150,
                          width: 257,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 145, 158, 222),
                                    blurRadius: 3,
                                    offset: Offset(3, 5))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.whiteColor),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0)
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedText = options[index];
                                          isShow = false;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 219,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 171, 182, 237)),
                                        child: Center(
                                          child: AppText.appText(
                                              "${options[index]}",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Container(
                          width: 268,
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
                                    AppText.appText("250 INR",
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
                                AppText.appText("Applied Sciences",
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
                                        final product = Product(
                                          id: 1,
                                          name: 'Product 1',
                                          price: 10.0,
                                          rating: 2.0,
                                          image: 'null',
                                        );
                                        cart.addToCart(product);
                                      },
                                      child: Image.asset(
                                        "assets/images/cart.png",
                                        height: 40,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
