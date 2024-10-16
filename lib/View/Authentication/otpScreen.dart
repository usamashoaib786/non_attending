import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/change_pass.dart';
import 'package:non_attending/View/bottomNavBar/bottom_bar.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/headers.dart';
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

  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
    log('-=-=-=- phone -=-=- ${widget.phone}');
    startTimer(); // Start the timer on screen load
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  // Function to start the 60-second countdown timer
  void startTimer() {
    _canResend = false;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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
                      keyboardType: TextInputType.number,
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
                    ? const Center(
                        child: CircularProgressIndicator(),
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
              const SizedBox(height: 20),
              // Resend OTP section
              _canResend
                  ? TextButton(
                      onPressed: () {
                        // Logic to resend OTP
                        resendOtp();
                      },
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : AppText.appText(
                      "Resend OTP in $_start seconds",
                      textColor: Colors.black,
                      fontSize: 16,
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
    Response response;
    int responseCode200 = 200;
    Map<String, dynamic> params = {
      "otp": _otpController.text,
      "email": widget.email,
    };
    try {
      response = await dio.post(path: AppUrls.verifyOtp, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
            pushReplacement(
                context,
                ChangePasswordScreen(
                  email: widget.email,
                ));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void resendOtp() async {
    setState(() {
      startTimer();
    });
    Response response;
    int responseCode200 = 200;
    int responseCode400 = 400;
    int responseCode401 = 401;
    int responseCode404 = 404;
    int responseCode422 = 422;
    int responseCode500 = 500;

    Map<String, dynamic> params = {
      "template_id": "665d915cd6fc0557fa2d78a2",
      "authkey": "419616AEHyyCJfp4M9661e0e9cP1",
      "mobile": "${widget.phone}",
    };
    log('-=-=- params -=- $params');
    try {
      response = await dio.post(
          path: "https://control.msg91.com/api/v5/otp", data: params);
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
        setState(() {
          isLoading = false;
          log('-=- OTP SEND -=-');
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyOtpPhone() async {
    setState(() {
      isLoading = true;
    });
    Response response;
    Map<String, dynamic> params = {
      "otp": _otpController.text,
      "mobile": "${widget.phone}",
    };
    Options options = Options(
      headers: {
        "authkey": "419616AEHyyCJfp4M9661e0e9cP1",
        HttpHeaders.acceptHeader: Application.json,
      },
    );
    try {
      response = await dio.post(
          path: "https://control.msg91.com/api/v5/otp/verify",
          data: params,
          options: options);
      var responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData["type"] == "error") {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
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

  // void resendOtp() {
  //   setState(() {
  //     startTimer(); // Reset the timer
  //     // Add your logic to resend OTP here, using the same

  ////// signup /////////////
  void signUp() async {
    setState(() {
      isLoading = true;
    });
    Response response;
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
      log('-=-=- responseData -=-=- $responseData');
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
      } else if (response.statusCode == responseCode201) {
        if (responseData["status"] == false) {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          setState(() {
            isLoading = false;
          });
          var token = responseData["token"];
          var id = responseData["user"]["id"];
          var phone = responseData["user"]["mobile"];
          var name = responseData["user"]["name"];
          var email = responseData["user"]["email"];
          var userId = id.toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefKey.authorization, token ?? '');
          prefs.setString(PrefKey.id, userId);
          prefs.setString(PrefKey.name, name ?? "");
          prefs.setString(PrefKey.email, email ?? "");
          prefs.setString(PrefKey.phone, phone ?? "");

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavView(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
