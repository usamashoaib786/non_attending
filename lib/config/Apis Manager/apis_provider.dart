import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:non_attending/Utils/utils.dart';
import 'package:non_attending/config/keys/app_urls.dart';

class ApiProvider extends ChangeNotifier {
  bool isLoading = false;
  var profileData;
  var savedData;
  ////////////////////////////////////////// Make Offer ////////////////////////////////////////////////
  void getProfile({required dio, required context}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: AppUrls.getProfile);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        profileData = responseData;
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

  void getSavedData({required dio, required context, required userId}) async {
    isLoading = true;
    Response response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": userId,
    };
    try {
      response = await dio.post(path: AppUrls.getSavedData, data: params);

      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        savedData = responseData["savedpdfs"];
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

}
