import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/config/Apis%20Manager/apis_provider.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  late AppDio dio;
  AppLogger logger = AppLogger();
  late Razorpay _razorpay;
  var courseIds;
  var userId;
  var email;
  var phone;
  var token;
  void openCheckOut({amount, phone, email}) async {
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
    final cart = Provider.of<Cart>(context, listen: false);
    List<int> productIds = cart.products.map((product) => product.id).toList();
    checkOut(id: userId, courseIds: productIds);
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
  void dispose() {
    _razorpay.clear();
    super.dispose();
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
                                AppText.appText("Buy Now",
                                    shadow: true,
                                    shadowColor: AppTheme.blue,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
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
                  child: AppButton.appButton("Checkout", onTap: () {
                    if (token != null) {
                      setState(() {
                        int amount = cart.totalPrice;
                        openCheckOut(
                            amount: amount, email: email, phone: phone);
                      });
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

  void checkOut({id, courseIds}) async {
    final cart = Provider.of<Cart>(context, listen: false);
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "user_id": id,
      "course_ids[]": courseIds,
    };
    try {
      response = await dio.post(path: AppUrls.checkOut, data: params);

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
            cart.clearAllProducts();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomPopupDialog(
                  image: "assets/images/happy.png",
                  msg1: "Hurray!!",
                  color: AppTheme.green,
                  msg2: "You have successfully baught courses",
                );
              },
            );
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
