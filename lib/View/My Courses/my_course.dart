import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/resources/popUp.dart';
import 'package:non_attending/Utils/resources/rating.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Detailed%20Screen/detail_screen.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  bool isLoading = true;
  var userId;
  var token;
  var courseData;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString(PrefKey.authorization);
      userId = pref.getString(PrefKey.id);
      if (token != null) {
        getMyCourses(id: userId);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
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
          title: AppText.appText("My Courses",
              fontSize: 24, fontWeight: FontWeight.w600)),
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
        child: courseData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: courseData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == 0)
                        const SizedBox(
                          height: 30,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            push(
                                context,
                                DetailScreen(
                                  title:
                                      "${courseData[index]["courses"]["title"]}",
                                  courseId: courseData[index]["courses"]["id"],
                                ));
                          },
                          child: Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "https://test.nonattending.com/${courseData[index]["courses"]["cover_image"]}",
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
                                          "${courseData[index]["courses"]["price"]} INR",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      StarRating(
                                        rating: courseData[index]["courses"]
                                                    ["stars"] ==
                                                null
                                            ? 0.0
                                            : courseData[index]["courses"]
                                                    ["stars"]
                                                .toDouble(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppText.appText(
                                      "${courseData[index]["courses"]["title"]}",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      textColor: const Color(0xff0D2393)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void getMyCourses({id}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"user_id": id};
    try {
      response = await dio.post(path: AppUrls.myCourses, data: params);

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
            courseData = responseData["courses"];
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
}
