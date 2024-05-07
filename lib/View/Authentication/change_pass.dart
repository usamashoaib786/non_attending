import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/otpScreen.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';

class ChangePasswordScreen extends StatefulWidget {
  final email;
  const ChangePasswordScreen({super.key, this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
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
    _passController.dispose();

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
                  "assets/images/forgot.png",
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: AppText.appText("CHANGE PASSWORD",
                    textAlign: TextAlign.center,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    shadow: true),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: AppText.appText("Enter New Password",
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
                    CustomAppPasswordfield(
                      texthint: "Enter Password",
                      controller: _passController,
                      prefixImge: "assets/images/passKey.png",
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
                          if (_passController.text.isNotEmpty) {
                            changePassword();
                          } else {
                            showSnackBar(context, "Enter Password");
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText.appText("Change Password",
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

  void changePassword() async {
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
      "email": widget.email,
      "password": _passController.text,
    };
    try {
      response = await dio.post(path: AppUrls.changePass, data: params);
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
            pushReplacement(context, const SignInScreen());
          });
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
