import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Cart%20Screens/cart_class.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/View/Detailed%20Screen/detail_screen.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/config/Apis%20Manager/apis_provider.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCourseScreen extends StatefulWidget {
  const SearchCourseScreen({super.key});

  @override
  State<SearchCourseScreen> createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedText = "Course Type";
  List options = ["Paid", "Unpaid"];
  var coursesData;
  bool isLoading = false;
  bool isShow = false;
  var userId;
  var email;
  var phone;
  var token;
  late AppDio dio;
  AppLogger logger = AppLogger();
  late Razorpay _razorpay;
  var courseId;
  void openCheckOut(amount) async {
    amount = amount * 100;
    var options = {
      'key': "rzp_live_bMz0RWvMMqvJuW",
      'amount': amount,
      'name': 'Non Attending',
      'prefill': {
        'contact': '$phone',
        'email': '$email',
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successfull${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);

    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.buyNow(
        dio: dio, context: context, userId: userId, courseId: courseId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Fail${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.id);
      email = pref.getString(PrefKey.email);
      phone = pref.getString(PrefKey.phone);
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
                                          if (index == 0) {
                                            searchCourses(paid: true);
                                          } else {
                                            searchCourses(paid: false);
                                          }
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
                  isLoading == true
                      ? const Center(child: CircularProgressIndicator())
                      : coursesData == null
                          ? const SizedBox.shrink()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: coursesData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20, top: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      push(
                                          context,
                                          DetailScreen(
                                            title:
                                                "${coursesData[index]["title"]}",
                                            courseId: coursesData[index]["id"],
                                          ));
                                    },
                                    child: Container(
                                      width: 268,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                "https://test.nonattending.com/${coursesData[index]["cover_image"]}",
                                              ),
                                              fit: BoxFit.fill,
                                              opacity: 0.3),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 145, 158, 222),
                                                blurRadius: 3,
                                                offset: Offset(3, 5))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(27),
                                          color: const Color.fromARGB(
                                              255, 231, 224, 224)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText.appText(
                                                    "${coursesData[index]["price"]} INR",
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                StarRating(
                                                  rating: coursesData[index]
                                                              ["stars"] ==
                                                          null
                                                      ? 0.0
                                                      : coursesData[index]
                                                              ["stars"]
                                                          .toDouble(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            AppText.appText(
                                                "${coursesData[index]["title"]}",
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                textColor:
                                                    const Color(0xff0D2393)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            coursesData[index]["type"] != "paid"
                                                ? const SizedBox(
                                                    height: 10,
                                                  )
                                                : coursesData[index]
                                                            ["purchased"] !=
                                                        0
                                                    ? const SizedBox(
                                                        height: 10,
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (token !=
                                                                  null) {
                                                                setState(() {
                                                                  courseId =
                                                                      coursesData[
                                                                              index]
                                                                          [
                                                                          "id"];
                                                                  int amount = int.parse(
                                                                      coursesData[index]
                                                                              [
                                                                              "price"]
                                                                          .toString());
                                                                  openCheckOut(
                                                                      amount);
                                                                });
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return const CustomPopupDialog(
                                                                      image:
                                                                          "assets/images/oops.png",
                                                                      msg1: "",
                                                                      msg2:
                                                                          "Please Login First",
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: AppText.appText(
                                                                "Buy Now",
                                                                shadow: true,
                                                                shadowColor:
                                                                    AppTheme
                                                                        .blue,
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              cart.addProduct(Product(
                                                                  "${coursesData[index]["title"]}",
                                                                  "${coursesData[index]["price"]}",
                                                                  "${coursesData[index]["cover_image"]}",
                                                                  coursesData[
                                                                          index]
                                                                      ["stars"],
                                                                  coursesData[
                                                                          index]
                                                                      ["id"]));

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return CustomPopupDialog(
                                                                    image:
                                                                        "assets/images/happy.png",
                                                                    msg1:
                                                                        "Hurray!!",
                                                                    color: AppTheme
                                                                        .green,
                                                                    msg2:
                                                                        "Successfully Added to Cart",
                                                                  );
                                                                },
                                                              );
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

  void searchCourses({paid}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "user_id": userId,
    };
    try {
      response = await dio.post(
          path: paid == true ? AppUrls.searhPaid : AppUrls.searchFree,
          data: params);

      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          setState(() {
            isLoading = false;
            coursesData = responseData["courses"];
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
