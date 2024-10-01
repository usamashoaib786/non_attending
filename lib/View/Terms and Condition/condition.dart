import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/View/bottomNavBar/nav_view.dart';
import 'package:non_attending/config/dio/app_dio.dart';
import 'package:non_attending/config/dio/app_logger.dart';
import 'package:non_attending/config/keys/app_urls.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool isLoading = true;
  var userId;
  var token;
  var courseData;
  late AppDio dio;
  AppLogger logger = AppLogger();
  String htmlData = '';

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
    fetchHtmlData().then((data) {
      setState(() {
        htmlData = data;
      });
    }).catchError((error) {
      print(error);
      // Handle error appropriately
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
          title: AppText.appText("Terms & Conditions",
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
        child: htmlData.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Html(data: htmlData),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<String> fetchHtmlData() async {
    setState(() {
      isLoading = true;
    });
    Response response;
    int responseCode200 = 200;

    try {
      response = await dio.get(path: AppUrls.terms);

      var responseData = response.data;
      if (response.statusCode == responseCode200) {
        setState(() {
          isLoading = false;
        });
        return responseData['termsandconditions']['terms'] ?? '';
      } else {
        // Handle non-200 response codes
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
      // Optionally, you can rethrow the error or return a default string
      throw Exception('Error fetching HTML data: $e');
    }
  }
}
