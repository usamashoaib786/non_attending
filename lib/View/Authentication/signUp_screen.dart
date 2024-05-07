import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/otpScreen.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cnfrmPassController = TextEditingController();
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
                  "assets/images/siginImage.png",
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AppText.appText("SIGN UP",
                    fontSize: 38, fontWeight: FontWeight.w800, shadow: true),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  height: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomAppFormField(
                        texthint: "Enter Username",
                        controller: _nameController,
                        prefixImge: "assets/images/name.png",
                      ),
                      CustomAppFormField(
                        texthint: "Enter Email Id",
                        controller: _emailController,
                        prefixImge: "assets/images/email.png",
                      ),
                      CustomAppFormField(
                        texthint: "Enter Phone No.",
                        controller: _phoneController,
                        prefixImge: "assets/images/phone.png",
                      ),
                      CustomAppPasswordfield(
                        texthint: "Enter Password",
                        controller: _passController,
                        prefixImge: "assets/images/passKey.png",
                      ),
                      CustomAppPasswordfield(
                        texthint: "Confirm Password",
                        controller: _cnfrmPassController,
                        prefixImge: "assets/images/passKey.png",
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_nameController.text.isNotEmpty) {
                            if (_emailController.text.isNotEmpty) {
                              final RegExp emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (emailRegex.hasMatch(_emailController.text)) {
                                if (_phoneController.text.isNotEmpty) {
                                  if (_passController.text.isNotEmpty) {
                                    if (_cnfrmPassController.text.isNotEmpty) {
                                      if (_passController.text ==
                                          _cnfrmPassController.text) {
                                        sendOtp();
                                      } else {
                                        showSnackBar(
                                            context, "Password is not Matched");
                                      }
                                    } else {
                                      showSnackBar(
                                          context, "Enter Confirm Passsword");
                                    }
                                  } else {
                                    showSnackBar(context, "Enter Password");
                                  }
                                } else {
                                  showSnackBar(context, "Enter Phone No.");
                                }
                              } else {
                                showSnackBar(context, "Enter Valid Email");
                              }
                            } else {
                              showSnackBar(context, "Enter Email");
                            }
                          } else {
                            showSnackBar(context, "Enter Username");
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText.appText("SIGN UP",
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

  void sendOtp() async {
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
      "template_id": "661d0f5ad6fc0548a5691e93",
      "authkey": "419616AEHyyCJfp4M9661e0e9cP1",
      "mobile": _phoneController.text,
    };
    try {
      response = await dio.post(
          path: "https://control.msg91.com/api/v5/otp", data: params);
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
          showSnackBar(context, "${responseData["message"]}");
          setState(() {
            isLoading = false;
            pushReplacement(
                context,
                OtpScreen(
                  signUp: true,
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  password: _passController.text,
                ));
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
