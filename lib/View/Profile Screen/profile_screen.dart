import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:non_attending/Utils/resources/app_button.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/Authentication/signin_screen.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';
import 'package:non_attending/View/PDF%20viewer/pdf_screen.dart';
import 'package:non_attending/config/Apis%20Manager/apis_provider.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';
import 'package:non_attending/config/keys/pref_keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cnfrmPassController = TextEditingController();
  bool edit = false;
  bool info = true;
  var _pickedFilePath;
  bool isLoading = true;
  var userId;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getuserCredential(context);

    super.initState();
  }

  getuserCredential(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString(PrefKey.authorization);
    userId = pref.getString(PrefKey.id);
    if (token != null) {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      apiProvider.getProfile(
        dio: dio,
        context: context,
      );
    } else {
      showSnackBar(context, "Please Login First");
      pushUntil(context, const SignInScreen());
    }
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedFilePath = image.path;
        print("electedfilePath${_pickedFilePath}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final apiProvider = Provider.of<ApiProvider>(context);
    print("knfn$userId");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        leading: IconButton(
          icon: Image.asset(
              'assets/images/drawer.png'), // Replace with your image asset
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
        child: apiProvider.profileData == null
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.blackColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 210,
                      width: screenWidth,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                if (edit == true) {
                                  pickImage();
                                }
                              },
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 137,
                                  width: 137,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.blue, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: _pickedFilePath != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(_pickedFilePath!),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : apiProvider.profileData[
                                                  "profile_photo_path"] !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                "https://test.nonattending.com/${apiProvider.profileData["profile_photo_path"]}",
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : Center(
                                              child: AppText.appText(
                                                  "${apiProvider.profileData["name"]}"
                                                      .substring(0, 1)),
                                            ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 80.0),
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                        "assets/images/pen.png",
                                        height: 50,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                width: screenWidth,
                                child: Image.asset(
                                  "assets/images/line.png",
                                  fit: BoxFit.fill,
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      width: screenWidth,
                      color: const Color.fromARGB(255, 188, 190, 197),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                info = true;
                              });
                            },
                            child: AppText.appText("Personal Info",
                                fontSize: 19, fontWeight: FontWeight.w400),
                          ),
                          Container(
                            height: 45,
                            width: 1,
                            color: AppTheme.blackColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (info == true) {
                                setState(() {
                                  info = false;
                                  apiProvider.getSavedData(
                                      dio: dio,
                                      context: context,
                                      userId: userId);
                                });
                              }
                            },
                            child: AppText.appText("Saved Files",
                                fontSize: 19, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    info == true
                        ? profileColumn()
                        : apiProvider.savedData == null
                            ? Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: CircularProgressIndicator(
                                color: AppTheme.blackColor,
                              ),
                            )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 405,
                                child: savedColumn()),
                    // const SizedBox(height: 20,)
                  ],
                ),
              ),
      ),
    );
  }

  Widget profileColumn() {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    _emailController.text = apiProvider.profileData["email"];
    _nameController.text = apiProvider.profileData["name"];
    _phoneController.text = apiProvider.profileData["mobile"].toString();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: edit == true ? 360 : 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppFormField(
              texthint: "Enter Name",
              readOnly: edit == true ? false : true,
              controller: _nameController,
              prefixImge: "assets/images/name.png",
            ),
            CustomAppFormField(
              texthint: "",
              readOnly: true,
              controller: _emailController,
              prefixImge: "assets/images/email.png",
            ),
            CustomAppFormField(
              texthint: "",
              controller: _phoneController,
              readOnly: true,
              prefixImge: "assets/images/phone.png",
            ),
            if (edit == true)
              CustomAppPasswordfield(
                texthint: "Enter Password",
                controller: _passController,
                prefixImge: "assets/images/passKey.png",
              ),
            if (edit == true)
              CustomAppPasswordfield(
                texthint: "Confirm Password",
                controller: _cnfrmPassController,
                prefixImge: "assets/images/passKey.png",
              ),
            if (edit == true)
              apiProvider.isLoading == true
                  ? CircularProgressIndicator(
                      color: AppTheme.blackColor,
                    )
                  : AppButton.appButton("Update", onTap: () {
                      setState(() {
                        edit = false;
                        updateProfile();
                      });
                    },
                      height: 46,
                      width: 191,
                      fontSize: 28,
                      fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }

  Widget savedColumn() {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: apiProvider.savedData.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: GestureDetector(
                onTap: () {
                  if (apiProvider.savedData[index]["video_id"] == null) {
                    push(
                        context,
                        PdfViewerPage(
                            url:
                                "https://test.nonattending.com/${apiProvider.savedData[index]["chapters"]["pdf_path"]}"));
                  } else {}
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 128, 141, 204)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    child: Stack(
                      children: [
                        Image.asset(
                          apiProvider.savedData[index]["video_id"] == null
                              ? "assets/images/pdfImg.png"
                              : "assets/images/vedioImg.png",
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              AppText.appText(
                                  "${apiProvider.savedData[index]["course_title"]}",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                              AppText.appText(
                                  apiProvider.savedData[index]["video_id"] ==
                                          null
                                      ? "${apiProvider.savedData[index]["chapters"]["title"]}"
                                      : apiProvider.savedData[index]
                                                  ["videos"] ==
                                              null
                                          ? ""
                                          : "${apiProvider.savedData[index]["videos"]["title"]}",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (index == apiProvider.savedData.length - 1)
              const SizedBox(
                height: 20,
              )
          ],
        );
      },
    );
  }

  void updateProfile() async {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
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
    FormData formData;
    if (_pickedFilePath != null) {
      File profilePhoto = File(_pickedFilePath!);
      formData = FormData.fromMap({
        "name": _nameController.text,
        "profile_photo": await MultipartFile.fromFile(profilePhoto.path),
        "password": _passController.text,
        "id": userId,
      });
    } else {
      formData = FormData.fromMap({
        "name": _nameController.text,
        "password": _passController.text,
        "id": userId,
      });
    }
    try {
      response = await dio.post(path: AppUrls.updateProfile, data: formData);
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
          showSnackBar(context, "Profile Update Successfully");
          setState(() {
            isLoading = false;
            _passController.clear();
            _cnfrmPassController.clear();
            apiProvider.getProfile(dio: dio, context: context);
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
