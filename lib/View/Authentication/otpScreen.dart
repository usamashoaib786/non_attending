import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/change_pass.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final email;
  final bool? signUp;
  final String? password;
  final String? name;
  final String? phone;
  const OtpScreen(
      {super.key,
      this.email,
      this.signUp,
      this.password,
      this.name,
      this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bgimage.png"),
                fit: BoxFit.fill,
                opacity: 0.5)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Image.asset(
                  "assets/images/otp.png",
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: AppText.appText("OTP",
                    textAlign: TextAlign.center,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    shadow: true),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: AppText.appText(
                    "Enter Verification code sent to your phone number",
                    textColor: AppTheme.red,
                    fontSize: 19,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    shadow: true),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomAppFormField(
                      texthint: "Enter Otp",
                      controller: _otpController,
                      prefixImge: "assets/images/email.png",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (widget.signUp == true) {
                            if (_otpController.text.isNotEmpty) {
                              verifyOtpPhone();
                            } else {
                              showSnackBar(context, "Enter Otp");
                            }
                          } else {
                            if (_otpController.text.isNotEmpty) {
                              verifyOtp();
                            } else {
                              showSnackBar(context, "Enter Otp");
                            }
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText.appText("Verify OTP",
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                shadow: true),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/images/arrow.png",
                              height: 28,
                            )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found

    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "otp": _otpController.text,
      "email": widget.email,
    };
    try {
      response = await dio.post(path: AppUrls.verifyOtp, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
            pushReplacement(
                context,
                ChangePasswordScreen(
                  email: widget.email,
                ));
          });
        }
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  //////////////////// phoneotp////////////////////////
  void verifyOtpPhone() async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found

    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "otp": _otpController.text,
      "mobile": widget.phone,
    };
    try {
      response = await dio.post(path: "https://control.msg91.com/api/v5/otp/verify", data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
            signUp();
          });
        }
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  ////// signup /////////////
  void signUp() async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode201 = 201; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found

    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "name": widget.name,
      "email": widget.email,
      "mobile": widget.phone,
      "password": widget.password,
    };
    try {
      response = await dio.post(path: AppUrls.signUp, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode201) {
        if (responseData["status"] == false) {
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          setState(() {
            isLoading = false;
          });
          var token = responseData["token"];
          print("token $token");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefKey.authorization, token ?? '');

          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const BottomNavView(),
          //     ),
          //     (route) => false);
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
