import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/otpScreen.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '+91');
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cnfrmPassController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    
    // Ensures the user can't delete the prefix "+91"
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _phoneController.text.isEmpty) {
        _phoneController.text = "+91";
        _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
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
            opacity: 0.5,
          ),
        ),
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
                        focusNode: _phoneFocusNode,
                        onChanged: (value) {
                          // Ensuring the user doesn't remove the "+91" prefix
                          if (!value.startsWith("+91")) {
                            _phoneController.text = "+91";
                            _phoneController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _phoneController.text.length),
                            );
                          } else {
                            // Check if the value after "+91" is numeric
                            String phoneNumber = value.substring(3); // Get the number after the prefix
                            if (phoneNumber.isNotEmpty && !RegExp(r'^[0-9]*$').hasMatch(phoneNumber)) {
                              // If the phone number contains non-numeric characters
                              showSnackBar(context, "Phone number must be numeric after +91");
                              _phoneController.text = "+91"; // Reset to just "+91"
                              _phoneController.selection = TextSelection.fromPosition(
                                TextPosition(offset: _phoneController.text.length),
                              );
                            }
                          }
                        },
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
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: () {
                          // Check all validations including the phone number
                          if (_nameController.text.isNotEmpty) {
                            if (_emailController.text.isNotEmpty) {
                              final RegExp emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (emailRegex.hasMatch(_emailController.text)) {
                                if (_phoneController.text.length > 3 && 
                                    RegExp(r'^\+91[0-9]+$').hasMatch(_phoneController.text)) {
                                  if (_passController.text.isNotEmpty) {
                                    if (_passController.text.length >= 8) {
                                      if (_cnfrmPassController.text.isNotEmpty) {
                                        if (_passController.text == _cnfrmPassController.text) {
                                          sendOtp();
                                        } else {
                                          showSnackBar(context, "Password is not Matched");
                                        }
                                      } else {
                                        showSnackBar(context, "Enter Confirm Password");
                                      }
                                    } else {
                                      showSnackBar(context, "Password must be at least 8 characters");
                                    }
                                  } else {
                                    showSnackBar(context, "Enter Password");
                                  }
                                } else {
                                  showSnackBar(context, "Phone number must start with +91 and be numeric");
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
                                fontSize: 29, fontWeight: FontWeight.w800, shadow: true),
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
      "mobile": _phoneController.text,
    };
    log('-=-=- params -=- $params');
    try {
      response = await dio.post(path: "https://control.msg91.com/api/v5/otp", data: params);
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
          pushReplacement(
            context,
            OtpScreen(
              signUp: true,
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              password: _passController.text,
            ),
          );
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error: $e');
      showSnackBar(context, "An error occurred, please try again.");
    }
  }
}
