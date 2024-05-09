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
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CourseViewScreen extends StatefulWidget {
  final data;
  final userId;
  final String? email;
  final String? phone;
  final String? token;
  const CourseViewScreen(
      {super.key, this.data, this.userId, this.email, this.phone, this.token});

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  late AppDio dio;
  AppLogger logger = AppLogger();
  late Razorpay _razorpay;
  void openCheckOut(amount) async {
    amount = amount * 100;
    var options = {
      'key': "rzp_test_V90pgwENoCOEzq",
      'amount': amount,
      'name': 'Non Attending',
      'prefill': {
        'contact': '${widget.phone}',
        'email': '${widget.email}',
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
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.initState();
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: GestureDetector(
                          onTap: () {
                            push(
                                context,
                                DetailScreen(
                                  title: "${widget.data[index]["title"]}",
                                  courseId: widget.data[index]["id"],
                                ));
                          },
                          child: Container(
                            width: 268,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "https://test.nonattending.com/${widget.data[index]["cover_image"]}",
                                    ),
                                    fit: BoxFit.fill,
                                    opacity: 0.3),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 145, 158, 222),
                                      blurRadius: 3,
                                      offset: Offset(3, 5))
                                ],
                                borderRadius: BorderRadius.circular(27),
                                color:
                                    const Color.fromARGB(255, 231, 224, 224)),
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
                                          "${widget.data[index]["price"]} INR",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      StarRating(
                                        rating:
                                            widget.data[index]["stars"] == null
                                                ? 0.0
                                                : widget.data[index]["stars"]
                                                    .toDouble(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppText.appText(
                                      "${widget.data[index]["title"]}",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      textColor: const Color(0xff0D2393)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  widget.data[index]["type"] != "paid"
                                      ? const SizedBox(
                                          height: 10,
                                        )
                                      : widget.data[index]["purchased"] != 0
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
                                                    if (widget.token != null) {
                                                      setState(() {
                                                        int amount = int.parse(
                                                            widget.data[index]
                                                                    ["price"]
                                                                .toString());
                                                        openCheckOut(amount);
                                                      });
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
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
                                                          AppTheme.blue,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    cart.addProduct(Product(
                                                        "${widget.data[index]["title"]}",
                                                        "${widget.data[index]["price"]}",
                                                        "${widget.data[index]["cover_image"]}",
                                                        widget.data[index]
                                                            ["stars"]));

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomPopupDialog(
                                                          image:
                                                              "assets/images/happy.png",
                                                          msg1: "Hurray!!",
                                                          color: AppTheme.green,
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
}
