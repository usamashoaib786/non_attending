import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';

class ReviewPopUp extends StatefulWidget {
  final userId;
  final courseId;
  const ReviewPopUp({super.key, this.userId, this.courseId});

  @override
  State<ReviewPopUp> createState() => _ReviewPopUpState();
}

class _ReviewPopUpState extends State<ReviewPopUp> {
  bool isLoading = false;
  bool isLoading1 = false;
  late AppDio dio;
  var currentRating;
  AppLogger logger = AppLogger();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    // getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 270.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.43, 0.5174, 0.6745],
            colors: [
              Color.fromARGB(255, 237, 216, 167), // 43%
              Color.fromARGB(255, 223, 214, 192), // 7.74%
              Color.fromARGB(255, 233, 216, 177), // 22.45%
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReviewRating(
                onRatingChanged: (rating) {
                  // Handle the rating change, e.g., update a variable in your state
                  setState(() {
                    currentRating = rating;
                  });
                },
              ),
              CustomAppFormField(
                  texthint: "Enter your review here",
                  prefixIcon: true,
                  lines: 3,
                  height: 120,
                  controller: _controller),
              AppButton.appButton("Submit", onTap: () {
                review(stars: currentRating, comments: _controller.text);
              },
                  height: 46,
                  width: 191,
                  fontSize: 28,
                  fontWeight: FontWeight.w600)
            ],
          ),
        ),
      ),
    );
  }

  void review({required stars, required comments}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "user_id": widget.userId,
      "course_id": widget.courseId,
      "stars": "$stars",
      "comments": "$comments",
    };
    try {
      response = await dio.post(path: AppUrls.review, data: params);

      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomPopupDialog(
                image: "assets/images/sad.png",
                msg1: "",
                msg2: "${responseData["message"]}",
              );
            },
          );
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
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomPopupDialog(
                  image: "assets/images/happy.png",
                  msg1: "",
                  color: AppTheme.green,
                  msg2: "Review Addded Successfuly",
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

class ReviewRating extends StatefulWidget {
  final Function(int) onRatingChanged;
  final int initialRating;

  const ReviewRating({
    Key? key,
    required this.onRatingChanged,
    this.initialRating = 0,
  }) : super(key: key);

  @override
  _ReviewRatingState createState() => _ReviewRatingState();
}

class _ReviewRatingState extends State<ReviewRating> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
              widget.onRatingChanged(_rating);
            });
          },
          child: Icon(
            Icons.star,
            color: index < _rating ? AppTheme.appColor : Colors.white,
            size: 35,
          ),
        );
      }),
    );
  }
}
