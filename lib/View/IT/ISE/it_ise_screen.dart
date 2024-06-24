import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/View/Course%20View/course_view.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItScreen extends StatefulWidget {
  final String? title;
  final id;
  const ItScreen({super.key, this.title, this.id});

  @override
  State<ItScreen> createState() => _ItScreenState();
}

class _ItScreenState extends State<ItScreen> {
  String selectedBranch = "Select Branch";
  String selectedSemester = "Select Semester";
  String selectedSubject = "Select Subject";
  bool isBranch = false;
  bool isSem = false;
  bool isSub = false;
  var branchId;
  var semId;
  var subId;

  List semester = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8",
  ];
  var branchdata;
  var subjectData;
  var userId;
  var email;
  var phone;
  var token;
  bool isLoading = false;
  bool isLoading1 = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getBranches(id: widget.id);
    getUserDetail();
    
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
            title: AppText.appText("${widget.title}",
                fontSize: 36, fontWeight: FontWeight.w800)),
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
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isBranch = !isBranch;
                          isSem = false;
                          isSub = false;
                        });
                      },
                      child: custom(txt: selectedBranch)),
                  if (isBranch == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          height: 150,
                          width: 257,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 145, 158, 222),
                                    blurRadius: 3,
                                    offset: Offset(3, 5))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.whiteColor),
                          child: branchdata == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: branchdata.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        if (index == 0)
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20,
                                              bottom: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedBranch =
                                                    "${branchdata[index]["title"]}";
                                                isBranch = false;
                                                branchId =
                                                    branchdata[index]["id"];
                                                getSubject(id: branchId);
                                              });
                                            },
                                            child: Container(
                                              width: 219,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color.fromARGB(
                                                      255, 171, 182, 237)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4),
                                                child: Center(
                                                  child: AppText.appText(
                                                      "${branchdata[index]["title"]}",
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isSem = !isSem;
                          isBranch = false;
                          isSub = false;
                        });
                      },
                      child: custom(txt: selectedSemester)),
                  if (isSem == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          height: 150,
                          width: 257,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 145, 158, 222),
                                    blurRadius: 3,
                                    offset: Offset(3, 5))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.whiteColor),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: semester.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0)
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSemester =
                                              "${semester[index]}";
                                          isSem = false;
                                          semId = index + 1;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 219,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 171, 182, 237)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4),
                                          child: Center(
                                            child: AppText.appText(
                                                "${semester[index]}",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isSub = !isSub;
                          isBranch = false;
                          isSem = false;
                        });
                      },
                      child: custom(txt: selectedSubject)),
                  if (isSub == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          height: 150,
                          width: 257,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 145, 158, 222),
                                    blurRadius: 3,
                                    offset: Offset(3, 5))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.whiteColor),
                          child: branchId == null
                              ? Center(
                                  child: AppText.appText("Select Branch First"),
                                )
                              : subjectData == null
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: subjectData.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            if (index == 0)
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20,
                                                  bottom: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSubject =
                                                        "${subjectData[index]["title"]}";
                                                    isSub = false;
                                                    subId = subjectData[index]
                                                        ["id"];
                                                  });
                                                },
                                                child: Container(
                                                  width: 219,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              171,
                                                              182,
                                                              237)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4),
                                                    child: Center(
                                                      child: AppText.appText(
                                                          "${subjectData[index]["title"]}",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: isLoading1 == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : AppButton.appButton("Submit", onTap: () {
                            if (branchId != null) {
                              if (semId != null) {
                                if (subId != null) {
                                  getCourses();
                                } else {
                                  showSnackBar(context, "Select Subject");
                                }
                              } else {
                                showSnackBar(context, "Select Semester");
                              }
                            } else {
                              showSnackBar(context, "Select Branch");
                            }
                          },
                            height: 46,
                            width: 191,
                            fontSize: 28,
                            fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )));
  }

  Widget custom({txt}) {
    return Container(
      height: 50,
      width: 268,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(255, 145, 158, 222),
            blurRadius: 3,
            offset: Offset(3, 5))
      ], borderRadius: BorderRadius.circular(10), color: AppTheme.whiteColor),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 10),
              child: AppText.appText(txt,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  "assets/images/down.png",
                  height: 15,
                ),
              ))
        ],
      ),
    );
  }

  //////////////////////////////

  void getBranches({required id}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": id,
    };
    try {
      response = await dio.post(path: AppUrls.getBranches, data: params);

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
            branchdata = responseData["branches"];
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

  void getSubject({required id}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": id,
    };
    try {
      response = await dio.post(path: AppUrls.getSubjects, data: params);

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
            subjectData = responseData["subjects"];
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

  void getCourses() async {
    isLoading1 = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "branchid": branchId,
      "semesterid": semId,
      "subjectid": subId,
      "user_id": userId
    };
    try {
      response = await dio.post(path: AppUrls.getCourses, data: params);

      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading1 = false;
        });
      } else if (response.statusCode == responseCode401) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading1 = false;
        pushUntil(context, const SignInScreen());

        });
      } else if (response.statusCode == responseCode404) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading1 = false;
        });
      } else if (response.statusCode == responseCode500) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading1 = false;
        });
      } else if (response.statusCode == responseCode422) {
        Fluttertoast.showToast(msg: "${responseData["message"]}");
        setState(() {
          isLoading1 = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          Fluttertoast.showToast(msg: "${responseData["message"]}");
          setState(() {
            isLoading1 = false;
          });

          return;
        } else {
          setState(() {
            isLoading1 = false;
            var courseData = responseData["courses"];
            push(
                context,
                CourseViewScreen(
                  data: courseData,
                  email: email,
                  phone: phone,
                  token: token,
                  userId: userId,
                ));
          });
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading1 = false;
      });
    }
  }
}
