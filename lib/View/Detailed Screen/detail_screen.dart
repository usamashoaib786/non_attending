import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/Utils/resources/review_popup.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/View/Cart%20Screens/cart_class.dart';
import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
import 'package:non_attending/View/PDF%20viewer/pdf_screen.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/View/vedio%20player/vedio_player.dart';
import 'package:non_attending/config/Apis%20Manager/apis_provider.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final courseId;
  const DetailScreen({super.key, required this.title, required this.courseId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLoading = true;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var detailData;
  var userId;
  var email;
  var phone;
  var token;
  late Razorpay _razorpay;
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
      Fluttertoast.showToast(msg: "$e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successfull${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.buyNow(
        dio: dio, context: context, userId: userId, courseId: widget.courseId);
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
    diableFuction();

    super.initState();
  }

  diableFuction() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.id);
      email = pref.getString(PrefKey.email);
      phone = pref.getString(PrefKey.phone);
      token = pref.getString(PrefKey.authorization);
      getCourseDetail(id: userId, courseId: widget.courseId);
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
      appBar: AppBar(
          backgroundColor: AppTheme.appColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/back.png",
                height: 30,
              ),
            ),
          ),
          centerTitle: true,
          title: AppText.appText(widget.title,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: const Color(0xff0D2393))),
      bottomNavigationBar: const BottomNav(),
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
        child: detailData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    topContainer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customCard(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AppText.appText(
                                  "${detailData["description"]}",
                                  textAlign: TextAlign.center,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: AppText.appText("Syllabus",
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          customCard(height: 60.0, child: syllabusContainer()),
                          for (int i = 0;
                              i < detailData["chapters"].length;
                              i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: AppText.appText(
                                      "${detailData["chapters"][i]["title"]}:",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (token != null) {
                                      if (detailData["purchased"] != 0) {
                                        push(
                                            context,
                                            PdfViewerPage(
                                                url:
                                                    "https://test.nonattending.com/${detailData["chapters"][i]["pdf_path"]}"));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomPopupDialog(
                                              image: "assets/images/oops.png",
                                              msg1: "OOPS!!",
                                              msg2:
                                                  "You haven't bought this course",
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
                                  child: customCard(
                                      height: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.appText("Click to view pdf",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            AppButton.appButton(
                                              "Save PDF",
                                              width: 100,
                                              onTap: () {
                                                if (token != null) {
                                                  if (detailData["purchased"] !=
                                                      0) {
                                                    savePdf(
                                                        title: widget.title,
                                                        type: "pdf",
                                                        chapterId: detailData[
                                                                "chapters"][i]
                                                            ["id"]);
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const CustomPopupDialog(
                                                          image:
                                                              "assets/images/oops.png",
                                                          msg1: "OOPS!!",
                                                          msg2:
                                                              "You haven't bought this course",
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: AppText.appText(
                                      "${detailData["chapters"][i]["video_title"]}:",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (token != null) {
                                      if (detailData["purchased"] != 0) {
                                        push(
                                            context,
                                            VideoPlayerScreen(
                                                url:
                                                    "https://test.nonattending.com/${detailData["chapters"][i]["video_path"]}"));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomPopupDialog(
                                              image: "assets/images/oops.png",
                                              msg1: "OOPS!!",
                                              msg2:
                                                  "You haven't bought this course",
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
                                  child: customCard(
                                      height: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.appText(
                                                "Click to Play video",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            AppButton.appButton(
                                              "Save Video",
                                              width: 100,
                                              onTap: () {
                                                if (token != null) {
                                                  if (detailData["purchased"] !=
                                                      0) {
                                                    savePdf(
                                                        title: widget.title,
                                                        type: "video",
                                                        chapterId: detailData[
                                                                "chapters"][i]
                                                            ["id"]);
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const CustomPopupDialog(
                                                          image:
                                                              "assets/images/oops.png",
                                                          msg1: "OOPS!!",
                                                          msg2:
                                                              "You haven't bought this course",
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          detailData["purchased"] == 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppButton.appButton("Buy Now", onTap: () {
                                      if (token != null) {
                                        setState(() {
                                          int amount = int.parse(
                                              detailData["price"].toString());
                                          openCheckOut(
                                              amount: amount,
                                              phone: phone,
                                              email: email);
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
                                        height: 46,
                                        width: screenWidth * 0.4,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    AppButton.appButton("Add to Cart",
                                        onTap: () {
                                      cart.addProduct(Product(
                                          "${detailData["title"]}",
                                          "${detailData["price"]}",
                                          "${detailData["cover_image"]}",
                                          detailData["stars"],
                                          detailData["id"]));

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomPopupDialog(
                                            image: "assets/images/happy.png",
                                            msg1: "Hurray!!",
                                            color: AppTheme.green,
                                            msg2: "Successfully Added to Cart",
                                          );
                                        },
                                      );
                                    },
                                        height: 46,
                                        width: screenWidth * 0.4,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: AppButton.appButton("Review",
                                      onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ReviewPopUp(
                                          userId: userId,
                                          courseId: widget.courseId,
                                        );
                                      },
                                    );
                                  },
                                      height: 46.0,
                                      width: screenWidth * 0.4,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  /////////  Widgets .... ////////////////
  Widget topContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 237,
      width: screenWidth,
      color: AppTheme.appColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 116,
              width: screenWidth,
              child: Image.network(
                "https://test.nonattending.com/${detailData["cover_image"]}",
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.appText("${detailData["price"]} INR",
                    fontSize: 24, fontWeight: FontWeight.w600),
                Container(
                  height: 29,
                  width: 157,
                  color: AppTheme.blue,
                  child: StarRating(
                      rating: detailData["stars"] == null
                          ? 0.0
                          : detailData["stars"].toDouble()),
                )
              ],
            ),
            AppText.appText("Valid Upto ${detailData["validity"]}",
                fontSize: 17,
                fontWeight: FontWeight.w600,
                textColor: AppTheme.red),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // await Share.shareUri(Uri.parse("https://lms.nonattending.com/sharecourse/${detailData["id"]}/"));
                  },
                  child: Image.asset(
                    "assets/images/Share.png",
                    height: 31,
                  ),
                ),
                AppText.appText("Teacher: ${detailData["teacher"]}",
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customCard({child, height}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
          height: height,
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: const Color.fromARGB(255, 237, 215, 164),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 145, 158, 222),
                  blurRadius: 3,
                  offset: Offset(4, 5))
            ],
          ),
          child: child),
    );
  }

  Widget syllabusContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppText.appText("${detailData["unitscount"]} Units",
                fontSize: 12, fontWeight: FontWeight.w500),
            Container(
              height: 1,
              width: screenWidth * 0.43,
              color: Colors.black12,
            ),
            AppText.appText("${detailData["videoscount"]} Videos",
                fontSize: 12, fontWeight: FontWeight.w500),
          ],
        ),
        Container(
          height: 50,
          width: 1,
          color: Colors.black12,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppText.appText("${detailData["hours_count"]} Hours",
                fontSize: 12, fontWeight: FontWeight.w500),
            Container(
              height: 1,
              width: screenWidth * 0.43,
              color: Colors.black12,
            ),
            AppText.appText("${detailData["chapterscount"]} Pdf",
                fontSize: 12, fontWeight: FontWeight.w500),
          ],
        ),
      ],
    );
  }

  ////////////////////// Apis ////////////////////////
  void getCourseDetail({id, courseId}) async {
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
      "id": courseId,
    };
    try {
      response = await dio.post(path: AppUrls.getCourseDetail, data: params);

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
          pushUntil(context, const SignInScreen());
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
            detailData = responseData["course"];
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

  void savePdf({chapterId, required type, required title}) async {
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
      "chapter_id": chapterId,
      "type": "$type",
      "course_title": "$title",
    };
    try {
      response = await dio.post(path: AppUrls.savePdf, data: params);

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
          pushUntil(context, const SignInScreen());
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomPopupDialog(
                  image: "assets/images/happy.png",
                  msg1: "",
                  color: AppTheme.green,
                  msg2: type == "pdf"
                      ? "Successfuly Save Pdf"
                      : "Successfuly Save Video",
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
